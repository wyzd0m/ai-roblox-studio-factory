# Factory Roadmap — "Author-time artifacts, human-tunable output"

This roadmap tracks the next evolution of the AI Roblox Studio Factory. It exists to fix a set of
problems observed while building real games with the factory, where the output was technically
correct but not **editable, native-looking, or high-fidelity** enough for a human to finish and ship.

It follows the factory's existing phased method (see [`CLAUDE.md`](CLAUDE.md)): each milestone lands
as small, reviewable changes, keeps lint/format/tests/`rojo build` green, and **stops at a human gate**
before the next milestone. Update [`docs/DECISION_LOG.md`](docs/DECISION_LOG.md) when a milestone
changes architecture, and reflect new limits in [`docs/RISK_AND_LIMITATIONS.md`](docs/RISK_AND_LIMITATIONS.md).

## The unifying principle

Every problem below is one root cause wearing a different hat:

> The factory authors maps, models, and UI as **code that runs at play-time**. But the things a human
> needs to hand-tune are exactly the things that should be authored as **Studio artifacts committed to
> the repo** — editable in Studio, diffable in git, and stable across runs.

The fix, repeated across milestones, is to move hand-tunable content from *runtime generation* to
*committed, Studio-editable artifacts* (`.rbxmx` models, design-token modules, imported meshes), while
Claude still produces the first pass. Runtime code stays for behaviour, not for geometry/art a human
must touch.

## Design philosophy: Claude authors, Studio is an escape hatch

The goal is **not** to push work into Roblox Studio — Studio is a limiting authoring surface and the
whole point of the factory is to use Claude to its full potential. So across every milestone:

- **Claude authors the artifact end-to-end.** Claude writes `.rbxmx` map/model XML directly, generates
  Blender `bpy` scripts, and produces rich geometry/UI as committed files — it does ~95% of the work.
- **Studio-editability is an escape hatch, not the workflow.** The reason artifacts are committed as
  editable `.rbxmx` (rather than baked at runtime) is so a human *can* nudge a wall or re-space props in
  five seconds when they want to — not because they're expected to build in Studio. The primary path is
  always "Claude regenerates/edits the file," with Studio tweaks captured back via `rojo syncback`.
- **Minimize mandatory manual steps.** Anything that forces the human into Studio or Blender is a cost;
  prefer solutions where Claude produces the finished artifact and the human only reviews/playtests.

## Settings model (the knobs these milestones introduce)

A per-game manifest read by the scaffold and by Claude at build time. Proposed home: `factory.json`
at each game's repo root (mirrored defaults live in `templates/game-repo/`).

| Setting | Values | Default | Milestone |
| --- | --- | --- | --- |
| `map.authoring` | `studio-editable` \| `procedural` | `studio-editable` | M1 |
| `style.preset` | `roblox-modern-lowpoly` \| `flat-minimal` \| `custom` | `roblox-modern-lowpoly` | M2 |
| `input.targets` | list of `desktop` \| `mobile` \| `console` | `[desktop, mobile]` | M2 |
| `art.blenderPipeline` | `enabled` \| `disabled` | `disabled` | M3 |
| `audio.source` | `human-sourced` \| `none` | `human-sourced` | M4 |
| `persistence.datastore` | `enabled` \| `disabled` | `disabled` | M4 |

---

## Milestone 1 — Studio-editable maps (fixes Problem #1 + determinism flaw)

**Problem.** Maps are generated purely in Luau at play-time, so a human can't fix simple spatial
issues (an aisle too narrow, props too close) in Studio — and runtime generation can drift from what
was tested.

**Approach.** Claude authors the map as a committed `.rbxmx` model (XML — the version-control-friendly
format with solid Rojo support; binary `.rbxm` support is still buggy) mounted into `Workspace`. Claude
produces the full first pass *and* handles subsequent map changes by editing the file directly — this is
the primary path. Studio editing is the **escape hatch**: when the human wants a quick spatial nudge, they
do it in Studio and capture it back with the one-shot **`rojo syncback`** command. *(Note: Rojo's live
two-way sync is still experimental and script-only — we deliberately do not depend on it for geometry.)*

**Deliverables**
- Add a `Workspace.Map` mount to [`templates/game-repo/default.project.json`](templates/game-repo/default.project.json)
  pointing at `map/Map.rbxmx`.
- `map/` convention + a seed `Map.rbxmx` (spawn + ground) in the game template.
- `docs/GAME_ARCHITECTURE.md`: a "Map authoring" section — how Claude produces the first pass, how the
  human edits, and the exact `rojo syncback` capture step.
- `factory.json` `map.authoring` setting; scaffold honors `procedural` for games that truly want code maps.
- Update [`docs/DEVELOPMENT_WORKFLOW.md`](docs/DEVELOPMENT_WORKFLOW.md) with the edit→syncback loop.

**Acceptance** — A scaffolded game opens in Studio with an editable map in Workspace; a human edit
survives a `rojo syncback` + commit and reloads identically.

**Human gate** — Human confirms the syncback round-trip works on their machine before M2.

---

## Milestone 2 — Native Roblox feel: UI tokens, art direction, device input (fixes Problem #2 + input flaw)

**Problem.** UI and world styling read as "programmer output," not a Roblox game — and desktop-only
input locks out the mobile majority.

**Approach.** Give Claude a design system to consume instead of free-styling each screen, and make
mobile a default target.

**Reference — the `roblox-modern-lowpoly` UI spec (the "80% of Roblox games" look).**
This is the canonical default, drawn from a real shop-menu reference (a human-supplied screenshot should
live at `standards/ui-reference/`). Concrete, non-negotiable traits:
- **Chunky rounded cards** — large `UICorner` radius; a white/light panel as the modal body.
- **Thick dark outlines** on every element via `UIStroke` (the defining "sticker" look), not subtle 1px lines.
- **Bright, saturated, glossy tiles** — each product/currency tile is its own vivid color (teal, purple,
  orange, yellow, green) with a top-lit `UIGradient` for a glossy finish, plus a soft drop shadow.
- **Bold UPPERCASE headers** on a solid accent header bar (e.g. red "SHOP" bar with an ✕ close button).
- **Currency pills** — rounded pills pairing a coin/gem icon with a number; a bottom cash bar + level
  progress bar.
- **Vertical side rail** of chunky rounded icon buttons (shop, pets, settings, rewards…).
- **Big pill buttons** with price + icon; consistent padding and radius throughout.
- Custom/stylized games may override the preset, but this is what the factory produces by default.

**Deliverables**
- `src/shared/Style.luau` — design tokens matching the reference: saturated palette, large corner radius,
  thick stroke weight, glossy gradient presets, padding scale, font (BuilderSans/Gotham). UI code consumes
  tokens; no ad-hoc values.
- Reusable UI-kit components in `HudController.luau` (card, tile, currency pill, pill button, side-rail
  icon) built from `UICorner` + `UIStroke` + `UIGradient`, all sized with **`UDim2` Scale** so they fit
  every device.
- `standards/ui-reference/` — the human's reference screenshot(s) committed as the visual source of truth.
- `standards/ART_DIRECTION.md` — world style: low-poly conventions, a consistent stud grid for maps,
  MaterialService usage, chosen lighting technology + atmosphere preset.
- `factory.json` `style.preset` seeds both `Style.luau` and the art-direction doc.
- `input.targets` + a touch/gamepad input layer (ContextActionService) wired by default when `mobile`
  or `console` is targeted.

**Acceptance** — A fresh game's HUD renders correctly on desktop **and** phone viewport; all UI values
trace to `Style.luau`; the world reads as intentional low-poly per `ART_DIRECTION.md`.

**Human gate** — Human eyeballs UI on a phone/emulator and signs off on the look.

---

## Milestone 3 — Blender asset pipeline (fixes Problem #3 + animation/rigging flaw)

**Problem.** Code-generated meshes can't express organic/props shapes; NPCs and objects look bad.

**Approach.** A **post-scaffold, human-gated art phase**. Claude writes Blender Python (`bpy`) build
scripts (better when fed reference images); the human runs Blender, imports via Studio's 3D Importer,
and commits the resulting mesh. Sequenced after scaffolding exactly as intended.

**Deliverables**
- `assets/blender/` convention: `refs/` (human drops reference images), `scripts/` (`bpy` generators),
  `presets/` (documented FBX export settings).
- `standards/BLENDER_PIPELINE.md` — the export contract: scale **0.01** (1 Blender m = 1 stud),
  **Z-forward / Y-up**, disable "Add Leaf Bones", disable "Bake Animation" for static props, embed
  textures (Path Mode = Copy), **≤20,000 triangles per mesh**. Document Studio 2026 **Reimport** for
  iterating (preserves colors/welds/anchoring/hinges).
- Animation/rigging note: **default Roblox animations are a fine baseline** (they worked well in prior
  factory games) — the gap is authoring *new/custom* animations. For those, use the maintained **Roblox
  Animations Importer/Exporter** Blender extension; custom animations are imported artifacts, never code.
  Prefer default/library animations first; only reach for custom rigs when a game genuinely needs them.
- `factory.json` `art.blenderPipeline` gate (off by default — this adds a Blender dependency on the human).

**Acceptance** — Following `BLENDER_PIPELINE.md`, a `bpy` script produces an FBX that imports at correct
scale/orientation and lands as a committed `.rbxmx` MeshPart.

**Human gate** — Requires human to have Blender installed and to run the import; explicitly optional.

---

## Milestone 4 — Content completeness: audio, persistence, physics tuning (fixes audio / DataStore / collision flaws)

**Problem.** No story for sound, save systems can't be fully tested pre-publish, and hitboxes/physics
are playtest-tuned but not called out.

**Deliverables**
- `assets/audio/` + `assets/audio/PROVENANCE.md` — human-sourced audio with license tracking; a
  documented "drop your audio here" step (audio is human-sourced, never fabricated).
- `docs/GAME_ARCHITECTURE.md` persistence section + a checklist item to **enable Studio API Services**
  to test DataStore; `persistence.datastore` setting.
- [`docs/DEFINITION_OF_DONE.md`](docs/DEFINITION_OF_DONE.md): explicit human-gated tuning items —
  collision (`CanCollide`, hitboxes), jump/physics values — as playtest responsibilities, not code
  guarantees.

**Acceptance** — DoD lists audio, persistence-test, and physics-tuning as explicit gates; a game with
`audio.source = human-sourced` scaffolds the audio folder + provenance stub.

**Human gate** — Human supplies audio and performs the API-Services DataStore test.

---

## Milestone 5 — Tighten the review loop (fixes "no visual review artifact" flaw)

**Problem.** Claude can't playtest or screenshot, so the loop leans entirely on the human's play
session with no structured guidance.

**Deliverables**
- A per-handoff **Playtest Checklist** generated at the natural gate (extends
  [`standards/PROJECT_CHECKLIST.md`](standards/PROJECT_CHECKLIST.md) and
  [`docs/HUMAN_IN_THE_LOOP.md`](docs/HUMAN_IN_THE_LOOP.md)): "here's exactly what to look for / try /
  break," mapped to the game's systems.
- A "known human-only judgments" reminder (fun, feel, balance) so the factory never claims these.

**Acceptance** — Every playtest handoff produces a concrete, game-specific checklist the human can walk.

**Human gate** — This *is* the human gate; the loop closes when the human decides it's ready to publish.

---

## Status legend

`planned` · `in progress` · `landed` · `deferred`

| Milestone | Status |
| --- | --- |
| M1 — Studio-editable maps | ✅ landed |
| M2 — Native Roblox feel | ✅ landed |
| M3 — Blender pipeline | ✅ landed |
| M4 — Content completeness | in progress (PR open) |
| M5 — Review loop | planned |

---

_Problems #1–#3 were raised from real factory use; the remaining items (determinism, input, animation,
audio, persistence, physics tuning, review loop) were identified in review. This roadmap is a living
document — update statuses as milestones land and record architectural changes in the decision log._
