# Game Architecture — the standard shape of a generated game

Every game the factory produces follows this architecture unless its spec justifies a deviation
(recorded in that game's `docs/DECISION_LOG.md`). Consistency is what makes the factory scale:
a reviewer or employer can open any repo and immediately know where things live.

## Guiding principles

1. **The repo is the source of truth.** Everything canonical lives in version control: Luau in `src/`
   **and** committed instance artifacts such as the map (`map/Map.rbxmx`). The Roblox place (`.rbxl`)
   is only a build artifact produced by Rojo — never treat it as canonical. (Hand-tunable *world
   geometry* is a committed model file rather than runtime code; see **Map authoring** below.)
2. **Three realms, cleanly separated:** `client`, `server`, `shared`. Trust nothing from the client.
3. **Thin entry points, fat modules.** `Script`/`LocalScript` files only bootstrap; all logic lives
   in reusable `ModuleScript`s.
4. **Explicit boundaries.** Cross-realm communication goes through a small, named set of
   RemoteEvents/RemoteFunctions defined in `shared/`, never ad-hoc.
5. **Server authority.** All state that matters (currency, progress, inventory) is validated and
   owned by the server. The client requests; the server decides.

## Rojo → DataModel mapping

`default.project.json` maps the source tree into Roblox services:

| Source folder | Roblox location | Runs where |
| ------------- | --------------- | ---------- |
| `src/client/` | `StarterPlayer/StarterPlayerScripts` | Each player's client |
| `src/server/` | `ServerScriptService` | Server only |
| `src/shared/` | `ReplicatedStorage/Shared` | Both realms (modules) |
| `map/Map.rbxmx` | `Workspace/Map` | Server-authored, replicated to clients |
| `src/assets/`* | `ReplicatedStorage/Assets` (optional) | Both |

\* Binary assets (meshes, imported models) are referenced by ID and listed in `docs/` with provenance.
Small procedural props may still be built by a ModuleScript in `shared`, but **hand-tunable world
geometry — the map — is a committed model file** (`map/Map.rbxmx`), not runtime code (see below).

## Map authoring

The world/map is a **committed, Studio-editable model file** — not code that builds geometry at
runtime. This is deliberate: a human must be able to fix simple spatial problems (an aisle too narrow,
props too close) in seconds, maps must diff cleanly in git, and a built place must be deterministic
across runs.

- **Default (`map.authoring = "studio-editable"`).** The map lives at `map/Map.rbxmx` (Roblox XML —
  chosen over binary `.rbxm`, whose Rojo support is still buggy, and over runtime code). Rojo mounts it
  at `Workspace/Map`. The seed ships a baseplate + `SpawnLocation`; Claude grows it by editing the file
  directly (the primary authoring path).
- **Studio is an escape hatch, not the workflow.** When a human wants to nudge geometry by hand, they
  edit `Workspace.Map` live in Studio and capture the result back to `map/Map.rbxmx` with
  **`rojo syncback`** (requires Rojo ≥ 7.7.0, pinned in `rokit.toml`). The edit→syncback loop is
  documented in [`DEVELOPMENT_WORKFLOW.md`](DEVELOPMENT_WORKFLOW.md). `syncbackRules` in
  `default.project.json` scope syncback to the map and protect `src/` from being overwritten.
- **Procedural opt-out (`map.authoring = "procedural"`).** A game that genuinely wants a code-built map
  removes the `Workspace/Map` mount and builds geometry from a server module. Recorded in that game's
  decision log. (The scaffolder ships studio-editable by default; procedural is a manual opt-out.)

See [`FACTORY_SETTINGS.md`](FACTORY_SETTINGS.md) for the `factory.json` settings model.

## Reference folder layout inside a game

```
factory.json                    # per-game settings (see FACTORY_SETTINGS.md)
assets/
├── blender/                    # M3 model pipeline: refs/ scripts/ presets/ out/ (see BLENDER_PIPELINE.md)
├── meshes/                     # committed .rbxmx MeshParts imported from Blender
└── PROVENANCE.md               # every non-procedural asset, source, and license
map/
└── Map.rbxmx                   # committed, Studio-editable world; mounts at Workspace/Map
src/
├── client/
│   ├── init.client.luau        # bootstrap: require controllers, start them
│   ├── controllers/            # per-feature client logic (HUD, input, camera)
│   │   ├── HudController.luau   # builds the HUD from the UI kit
│   │   └── InputController.luau # device-agnostic input (ContextActionService)
│   └── ui/
│       └── Kit.luau            # roblox-modern-lowpoly UI kit (consumes shared/Style)
├── server/
│   ├── init.server.luau        # bootstrap: require services, start them
│   └── services/               # per-feature server logic (authoritative)
│       ├── DataService.luau    # persistence (DataStore/ProfileStore)
│       └── GameplayService.luau
└── shared/
    ├── Net.luau                # single place defining all Remotes by name
    ├── Config.luau             # tunables (speeds, prices, timers)
    ├── Style.luau              # UI design tokens (roblox-modern-lowpoly)
    ├── Types.luau              # shared Luau type definitions
    └── util/                   # small pure helpers (no side effects)
```

## Communication contract (`shared/Net.luau`)

All Remotes are declared once, by name, with a documented direction and payload shape. Neither
realm creates Remotes inline. This gives a single audit surface for the client/server boundary and
makes it obvious what a malicious client could send.

```lua
--!strict
-- shared/Net.luau — the ONLY place Remotes are defined.
-- Each entry documents direction and payload; server handlers must validate every field.
local Net = {
    -- client -> server: player asks to buy an item; server validates funds & ownership.
    RequestPurchase = "RequestPurchase",   -- payload: { itemId: string }
    -- server -> client: authoritative currency update for HUD.
    CurrencyChanged = "CurrencyChanged",   -- payload: { amount: number }
}
return Net
```

## Persistence

- Use a vetted profile library (e.g. ProfileService/ProfileStore via Wally) rather than raw
  `DataStoreService`, to get session-locking and reduce data-loss bugs.
- Never trust client-reported balances; the server reconciles against the stored profile.
- Guard all DataStore calls with `pcall` and a documented retry/backoff policy.

## Lifecycle pattern (lightweight, no heavy framework required)

Each service/controller is a ModuleScript exposing an optional `init()` and `start()`:

```lua
--!strict
local GameplayService = {}
function GameplayService.init() end   -- wire up references, no cross-service calls yet
function GameplayService.start() end  -- begin running; other services now exist
return GameplayService
```

The bootstrap requires all modules, calls every `init()`, then every `start()` — a two-phase start
that avoids ordering bugs without pulling in a large framework. A game may adopt Knit/Flamework if
its spec justifies it, recorded in that game's decision log.

## Security posture (baseline for every game)

- Validate every RemoteEvent/RemoteFunction argument type and range on the server.
- Rate-limit client-triggered server work.
- Keep exploitable constants (prices, cooldowns) server-side in `Config` reads, not client-trusted.
- Never `require` a client-supplied ModuleScript or `loadstring` untrusted input.

## Testing shape

- Pure logic in `shared/util` and service helpers is unit-tested with TestEZ/Jest-Lua and runs in
  CI (headless, via lune or a lua runtime where possible).
- Anything requiring the DataModel is exercised in the human playtest, with a checklist derived from
  the spec's core loop.
