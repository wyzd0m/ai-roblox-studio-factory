# Game Architecture — the standard shape of a generated game

Every game the factory produces follows this architecture unless its spec justifies a deviation
(recorded in that game's `docs/DECISION_LOG.md`). Consistency is what makes the factory scale:
a reviewer or employer can open any repo and immediately know where things live.

## Guiding principles

1. **Code is the source of truth.** The Roblox place is a build artifact produced by Rojo from
   `src/`. Never treat a `.rbxl` as canonical.
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
| `src/assets/`* | `ReplicatedStorage/Assets` (optional) | Both |

\* Code-buildable assets (procedural models built by a ModuleScript) live in `shared`; binary
assets are referenced by ID and listed in `docs/` with provenance.

## Reference folder layout inside a game

```
src/
├── client/
│   ├── init.client.luau        # bootstrap: require controllers, start them
│   └── controllers/            # per-feature client logic (input, UI, camera)
│       ├── UIController.luau
│       └── InputController.luau
├── server/
│   ├── init.server.luau        # bootstrap: require services, start them
│   └── services/               # per-feature server logic (authoritative)
│       ├── DataService.luau    # persistence (DataStore/ProfileStore)
│       └── GameplayService.luau
└── shared/
    ├── Net.luau                # single place defining all Remotes by name
    ├── Config.luau             # tunables (speeds, prices, timers)
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
