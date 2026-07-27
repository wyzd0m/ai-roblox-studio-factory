# Factory Settings (`factory.json`)

Each generated game carries a `factory.json` at its repo root — the per-game control surface for how
the factory builds it. The scaffolder ships it with safe defaults; Claude reads it at build time.

**Honesty rule:** only settings marked **enforced** below actually change behaviour today. Others are
**reserved** — declared here as the roadmap target so the manifest is discoverable, but they are added
to `factory.json` (and take effect) only when their milestone lands. Do not assume a reserved setting
does anything yet.

## Current file

```json
{
  "schemaVersion": 1,
  "map": {
    "authoring": "studio-editable"
  },
  "style": {
    "preset": "roblox-modern-lowpoly"
  },
  "input": {
    "targets": ["desktop", "mobile"]
  },
  "art": {
    "blenderPipeline": "disabled"
  },
  "audio": {
    "source": "human-sourced"
  },
  "persistence": {
    "datastore": "disabled"
  }
}
```

## Settings

| Key | Values | Default | Status | Milestone |
| --- | --- | --- | --- | --- |
| `map.authoring` | `studio-editable` \| `procedural` | `studio-editable` | **enforced** | M1 |
| `style.preset` | `roblox-modern-lowpoly` \| `flat-minimal` \| `custom` | `roblox-modern-lowpoly` | **enforced** | M2 |
| `input.targets` | list of `desktop` \| `mobile` \| `console` | `[desktop, mobile]` | **enforced** | M2 |
| `art.blenderPipeline` | `enabled` \| `disabled` | `disabled` | **enforced** | M3 |
| `audio.source` | `human-sourced` \| `none` | `human-sourced` | **enforced** | M4 |
| `persistence.datastore` | `enabled` \| `disabled` | `disabled` | **enforced** | M4 |

## `map.authoring` (enforced, M1)

- **`studio-editable`** (default): the world is a committed model at `map/Map.rbxmx`, mounted at
  `Workspace/Map`, editable in Studio and captured back via `rojo syncback`. See
  [`GAME_ARCHITECTURE.md`](GAME_ARCHITECTURE.md) → *Map authoring* and
  [`DEVELOPMENT_WORKFLOW.md`](DEVELOPMENT_WORKFLOW.md) → *Editing the map*.
- **`procedural`**: opt out of the committed map — remove the `Workspace/Map` mount from
  `default.project.json` and build geometry from a server module. Record the deviation in the game's
  own decision log. (The scaffolder does not yet branch on this value; procedural is a manual opt-out.)

## `style.preset` (enforced, M2)

Selects the UI/world look. Default **`roblox-modern-lowpoly`** — the "80% of Roblox games" style.

- Tokens live in `src/shared/Style.luau`; components in `src/client/ui/Kit.luau` build from them.
- World counterpart is [`../standards/ART_DIRECTION.md`](../standards/ART_DIRECTION.md); the visual
  source of truth is [`../standards/ui-reference/`](../standards/ui-reference/).
- **Never hardcode a look** — all colors/radii/strokes/fonts/spacing come from `Style.luau`.
- `flat-minimal` / `custom` are declared for future presets; today the scaffold ships the
  `roblox-modern-lowpoly` token set. A game overriding the preset records it in its decision log.

## `input.targets` (enforced, M2)

Device classes the input layer targets. Default **`[desktop, mobile]`**.

- `src/client/controllers/InputController.luau` binds actions through **ContextActionService**, which
  is device-agnostic: keyboard + gamepad bindings plus `createTouchButton = true` auto-show an
  on-screen button on phones. One binding therefore covers desktop, mobile, and console.
- Adding `console` is already covered by the gamepad binding; the setting documents intent and is the
  place to gate device-specific chrome as games grow.

## `art.blenderPipeline` (enforced, M3)

Whether this game uses the Blender model pipeline. Default **`disabled`** — it adds a Blender
dependency, and a game may deliberately keep geometry procedural.

- **`enabled`:** Claude authors `bpy` scripts in `assets/blender/scripts/` and runs Blender headless
  to export FBX; a human imports via Studio's 3D Importer and commits the mesh as
  `assets/meshes/<Prop>.rbxmx`. Full contract:
  [`../standards/BLENDER_PIPELINE.md`](../standards/BLENDER_PIPELINE.md).
- **`disabled`:** geometry stays procedural / primitive; no Blender step. Legitimate art choice, not a
  limitation (e.g. a game that wants blocky rigs on purpose).
- The `assets/blender/` convention folder ships either way (it's just files); the setting gates
  whether the pipeline is actually used for this game's models.

## `audio.source` (enforced, M4)

How audio is sourced. Default **`human-sourced`**.

- **`human-sourced`:** sounds are registered by name in `src/shared/Audio.luau` and sourced by a human
  from Roblox's free/licensed audio library, recorded in `assets/audio/PROVENANCE.md`. Claude never
  fabricates or uploads audio. This is the honest default — audio is a licensing decision.
- **`none`:** the game ships silent (Audio registry present but empty). Legitimate for a prototype.

## `persistence.datastore` (enforced, M4)

Whether the game persists player data. Default **`disabled`**.

- **`enabled`:** use a vetted profile library over raw `DataStoreService` (see
  [`GAME_ARCHITECTURE.md`](GAME_ARCHITECTURE.md) → *Persistence*). **Testing requires a human** to
  enable *Studio → Game Settings → Security → "Enable Studio Access to API Services"* and verify
  save/load across rejoin — it can't be checked headlessly. Tracked in
  [`DEFINITION_OF_DONE.md`](DEFINITION_OF_DONE.md).
- **`disabled`:** no persistence; nothing is saved between sessions.

## Adding a setting

When a milestone lands a new setting: add its key to the scaffolded `factory.json`, flip its row here
to **enforced**, document its behaviour in a section like the one above, and record the decision in
[`DECISION_LOG.md`](DECISION_LOG.md).
