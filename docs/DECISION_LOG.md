# Factory Decision Log

Architectural decisions for the **factory** (per-game decisions live in each game's own decision
log). Newest first. Format: date, decision, rationale, alternatives considered.

## 2026-07-22 — Scope is "high-automation, human-gated", not "fully autonomous"
**Decision:** The factory automates everything expressible as code/config and gates the rest
(Studio playtesting, publishing, uploads) to a human.
**Rationale:** Roblox Studio is not headless and publishing needs credentials + ToS compliance;
a literal "zero human" pipeline would ship broken/unpublishable games. See RISK_AND_LIMITATIONS.md.
**Alternatives:** Attempt full Studio automation via unsupported tooling — rejected as brittle and
ToS-risky.

## 2026-07-22 — One repo per game + a central factory + registry
**Decision:** Each game is its own repo scaffolded from this factory; a `games/REGISTRY.md` indexes
them; standards live only here.
**Rationale:** Matches the brief's portfolio goal while keeping standards DRY and the collection
navigable at scale.
**Alternatives:** Monorepo of all games — rejected: harder to present individual games to employers
and noisier history per game.

## 2026-07-22 — Rokit for pinned toolchains
**Decision:** Pin Rojo/Selene/StyLua/Wally versions per game via `rokit.toml`.
**Rationale:** Reproducible builds; CI matches local.
**Alternatives:** Aftman (still fine; template maps 1:1), or unpinned "latest" — rejected (drift).

## 2026-07-22 — Lightweight two-phase (init/start) module lifecycle over a heavy framework
**Decision:** Default games use a small `init()`/`start()` convention rather than mandating Knit/
Flamework.
**Rationale:** Keeps the baseline dependency-light and understandable; frameworks are opt-in per
game when the spec justifies them.
**Alternatives:** Mandate Knit everywhere — rejected as over-weight for simple games (obby).

## 2026-07-26 — Maps are committed, Studio-editable `.rbxmx`, not runtime code (M1)

**Decision:** The world/map ships as a committed model file `map/Map.rbxmx`, mounted by Rojo at
`Workspace/Map`. Claude authors and edits the file directly; humans may hand-tune in Studio and capture
edits back with the one-shot `rojo syncback` command, scoped by `syncbackRules` so only the map is
rewritten. Default is `map.authoring = "studio-editable"` in `factory.json`; `procedural` is a manual
opt-out.

**Rationale:** Runtime-generated maps can't be fixed by a human for simple spatial issues, don't diff,
and can drift from what was tested. Committing an editable artifact makes the map deterministic,
diffable, and human-tunable while keeping Claude as the primary author. Verified: a scaffolded game
builds under Rojo 7.7.0 and the map mounts at `Workspace/Map` (baseplate + SpawnLocation present in the
built place).

**Reconciles a prior principle:** `GAME_ARCHITECTURE.md` said "code is the source of truth / procedural
models live in shared." Updated to "the **repo** is the source of truth" — committed instance artifacts
(the map) are canonical alongside Luau; the `.rbxl` place remains the only non-canonical build artifact.

**Toolchain change:** bumped the pinned Rojo from 7.4.4 → 7.7.0, because `rojo syncback` only exists in
7.7.0+. Chose XML `.rbxmx` over binary `.rbxm` (Rojo's rbxm support is still buggy) and over runtime
code.

**Alternatives considered:** Rojo JSON model (`.model.json`) — cleaner diffs, but the syncback story is
weaker (format mismatch on round-trip); rejected for consistency of one format across author→edit→
syncback. Rojo *live* two-way sync — still experimental and script-only; rejected for geometry.

## 2026-07-27 — Native Roblox UI via a token module + kit, device-agnostic input (M2)

**Decision:** Ship a `roblox-modern-lowpoly` design system: tokens in `src/shared/Style.luau`
(palette, radii, thick strokes, gloss, fonts, spacing) consumed by a reusable kit in
`src/client/ui/Kit.luau` (card, header, tile, currency pill, pill button, side-rail button). UI code
never hardcodes a look. Input goes through `InputController.luau` using ContextActionService, which is
device-agnostic (keyboard + gamepad + auto touch button) and covers `input.targets`. New settings
`style.preset` and `input.targets` in `factory.json`. World counterpart: `standards/ART_DIRECTION.md`;
visual source of truth: `standards/ui-reference/`.

**Rationale:** Free-styled UI reads as "programmer output"; a token system + kit makes every screen
look like one coherent, native Roblox game and gives Claude something to consume instead of inventing
values per screen. Roblox is mobile-majority, so device-agnostic input is a default, not an add-on.
Verified headlessly: scaffolded game passes `stylua --check`, `selene` (0 warnings), and `rojo build`;
Style/Kit/HudController/InputController all mount in the tree.

**Deviation from the roadmap (recorded):** the roadmap listed the UI kit "in `HudController.luau`". It
lives in a dedicated `src/client/ui/Kit.luau` instead so the kit is reusable across controllers and
`HudController` stays a thin consumer — consistent with "thin entry points, fat modules".

**Limitation:** the *visual* result can't be verified headlessly (no Studio); rendering on desktop +
phone is an M2 human gate. Tokens/kit are structurally verified only.

**Alternatives considered:** a UI framework (Fusion/Roact) — rejected for v1 as over-weight; the kit is
dependency-free and a game may adopt a framework per its spec. Per-screen ad-hoc styling — rejected as
exactly the inconsistency this milestone removes.

## 2026-07-27 — Blender model pipeline: Claude authors headless, human imports (M3)

**Decision:** Add a Blender pipeline for meshes primitives can't express. Claude writes a `bpy` build
script in `assets/blender/scripts/` and runs Blender in **background mode** to export an FBX per a
fixed export contract; a human imports via Studio's 3D Importer and commits the MeshPart as
`assets/meshes/<Prop>.rbxmx`. Reference images in `assets/blender/refs/` drive accuracy. Gated by
`art.blenderPipeline` in `factory.json` (default `disabled`). Contract:
`standards/BLENDER_PIPELINE.md`.

**Rationale:** Blender being headless-runnable (`blender -b --python`) means Claude authors the mesh
end-to-end — consistent with "use Claude to full potential, Studio as escape hatch." Only the 3D
import isn't headless, so it's the single human step. Verified on Blender 3.2: the example script
exports a valid ~13 KB crate FBX headlessly.

**Default is `disabled` on purpose:** it adds a Blender dependency, and some games *want* procedural
geometry. This reconciles with games like Night Shift whose frozen spec keeps NPCs as blocky rigs —
the pipeline is opt-in and aimed at props/environment there, never forced onto NPCs.

**Limitations (human-gated, can't verify headless):** import scale, orientation, shading, and whether
the mesh *looks* right — Claude can't open the 3D Importer. Recorded in RISK_AND_LIMITATIONS.

**Alternatives considered:** procedural-only geometry — kept as the default for games that want it, but
insufficient for organic shapes; paid art assets / handcrafted Blender models — rejected per the brief
(procedural/Claude-authored, no paid assets in v1).

## 2026-07-27 — Content completeness: audio registry, DataStore gate, physics tuning (M4)

**Decision:** Close the "works but incomplete" gaps. **Audio:** a single registry `src/shared/Audio.luau`
(names → SoundIds, `Audio.get` warns on unset) + `assets/audio/PROVENANCE.md`; audio is human-sourced
(`audio.source`, default `human-sourced`). **Persistence:** `persistence.datastore` setting (default
`disabled`) with a documented human test step (enable Studio Access to API Services, verify save/load
across rejoin). **Physics/collision tuning:** added explicit human-gated items to
`DEFINITION_OF_DONE.md` (CanCollide/hitboxes, WalkSpeed/Jump, interaction ranges) — all tunable via
`Config.luau`.

**Rationale:** These are the things a mechanical (CI) gate can't catch but that make a game feel
finished. Audio and DataStore correctness are inherently human/licensing/Studio concerns; naming them
as explicit gates (not silent assumptions) keeps the factory honest and the DoD complete. The audio
registry mirrors the existing `Net.luau` "single audit surface" pattern.

**Verified headlessly:** scaffolded game passes `stylua --check`, `selene` (0 warnings), `rojo build`;
`Audio.luau` mounts under `ReplicatedStorage/Shared`; `factory.json` parses with the two new keys.

**Limitation:** DataStore save/load and physics feel can't be verified headlessly — both are
Definition-of-Done human gates (recorded in RISK_AND_LIMITATIONS as the general "Studio not headless"
constraint).

**Alternatives considered:** auto-sourcing audio (generate/upload) — rejected: licensing + ToS risk,
and the brief bars fabricated/unlicensed assets. Raw `DataStoreService` as the default — kept a profile
library recommendation instead for session-locking safety.

<!-- Add new decisions above this line. -->
