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
  }
}
```

## Settings

| Key | Values | Default | Status | Milestone |
| --- | --- | --- | --- | --- |
| `map.authoring` | `studio-editable` \| `procedural` | `studio-editable` | **enforced** | M1 |
| `style.preset` | `roblox-modern-lowpoly` \| `flat-minimal` \| `custom` | `roblox-modern-lowpoly` | reserved | M2 |
| `input.targets` | list of `desktop` \| `mobile` \| `console` | `[desktop, mobile]` | reserved | M2 |
| `art.blenderPipeline` | `enabled` \| `disabled` | `disabled` | reserved | M3 |
| `audio.source` | `human-sourced` \| `none` | `human-sourced` | reserved | M4 |
| `persistence.datastore` | `enabled` \| `disabled` | `disabled` | reserved | M4 |

## `map.authoring` (enforced, M1)

- **`studio-editable`** (default): the world is a committed model at `map/Map.rbxmx`, mounted at
  `Workspace/Map`, editable in Studio and captured back via `rojo syncback`. See
  [`GAME_ARCHITECTURE.md`](GAME_ARCHITECTURE.md) → *Map authoring* and
  [`DEVELOPMENT_WORKFLOW.md`](DEVELOPMENT_WORKFLOW.md) → *Editing the map*.
- **`procedural`**: opt out of the committed map — remove the `Workspace/Map` mount from
  `default.project.json` and build geometry from a server module. Record the deviation in the game's
  own decision log. (The scaffolder does not yet branch on this value; procedural is a manual opt-out.)

## Adding a setting

When a milestone lands a new setting: add its key to the scaffolded `factory.json`, flip its row here
to **enforced**, document its behaviour in a section like the one above, and record the decision in
[`DECISION_LOG.md`](DECISION_LOG.md).
