# Blender Pipeline — Claude-authored meshes for Roblox

Code-built geometry (Roblox primitives) can't express organic or detailed shapes, so NPCs and props
often look bad. This pipeline lets **Claude author a real mesh end-to-end** and leaves the human only
the one step that isn't headless: importing into Studio.

Enabled per-game with `art.blenderPipeline` in `factory.json` (default `disabled` — it adds a Blender
dependency). A game whose spec deliberately keeps geometry procedural (blocky rigs on purpose) should
leave it disabled; that's a legitimate art choice, not a limitation.

## Who does what

- **Claude (headless, ~all of it):** writes a `bpy` build script in `assets/blender/scripts/`, runs
  Blender in background mode to export an FBX. No GUI, no manual modelling.
  ```bash
  blender -b --python assets/blender/scripts/<prop>.py -- --out assets/blender/out/<prop>.fbx
  ```
- **Human (the one manual step):** imports `out/<prop>.fbx` via Studio's **3D Importer**, confirms
  scale + orientation, commits the resulting MeshPart as `assets/meshes/<Prop>.rbxmx`, and records it
  in `assets/PROVENANCE.md`.

Reference images make organic shapes far more accurate — drop front/side views into
`assets/blender/refs/` before asking Claude to build, and Claude will shape the script to match.

## Export contract (the settings that matter)

Set in `bpy.ops.export_scene.fbx(...)` (see `assets/blender/scripts/example_prop.py`), following
Roblox's published export requirements:

| Setting | Value | Why |
| --- | --- | --- |
| Apply Scalings | **FBX Unit Scale** (`apply_scale_options="FBX_SCALE_UNITS"`) | consistent unit handling |
| Global scale | **0.01** | 1 Blender metre → 1 stud |
| Forward / Up | **-Z forward / Y up** | maps Blender axes to Roblox |
| Add Leaf Bones | **off** | the importer dislikes leaf bones |
| Bake Animation | **off** for static props | static geometry carries no anim |
| Path Mode / Embed Textures | **Copy + Embed** | textures travel with the FBX |
| Triangles per mesh | **≤ 20,000** | the 3D Importer's hard cap |

**Scale and orientation are confirmed at import** — Studio's importer has a scale field and you can
rotate on import. This is the one thing the headless export can't verify (see below).

## Iterating & animation

- **Reimport:** after editing the script and re-exporting, use Studio's **Reimport** on the existing
  MeshPart — it preserves mesh-part colors, welds, anchoring, and hinges.
- **Animation:** default Roblox animations are a fine baseline and need none of this. For *custom*
  animation, use the maintained **Roblox Animations Importer/Exporter** Blender extension; animations
  are imported artifacts, never code.

## What's verified vs. human-gated

- **Verified headlessly:** the build script runs in Blender background mode and produces a valid FBX.
  (Confirmed on Blender 3.2 — the example exports a ~13 KB crate FBX.)
- **Human gate (needs Studio):** import scale, orientation, shading, and whether the mesh actually
  *looks* right. Claude cannot open the 3D Importer or see the result.

## Provenance

Every imported mesh is recorded in `assets/PROVENANCE.md`: what it is, that it was
Claude-authored/Blender-exported, and any textures used. Keeps the AI-disclosure and asset-licensing
posture honest (see [`../docs/RISK_AND_LIMITATIONS.md`](../docs/RISK_AND_LIMITATIONS.md) §8).
