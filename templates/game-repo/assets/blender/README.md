# `assets/blender/` — the model pipeline workspace

Where Blender-authored meshes are built for this game. Enabled per-game via
`art.blenderPipeline` in `factory.json`. Full contract:
[`standards/BLENDER_PIPELINE.md`](../../../standards/BLENDER_PIPELINE.md) in the factory.

```
assets/blender/
├── refs/        # drop reference images here (screenshots, concept art) — improves accuracy
├── scripts/     # bpy build scripts (Claude authors these); example_prop.py is a starting point
├── presets/     # notes/overrides for export settings
└── out/         # generated .fbx (git-ignored build artifacts — import these into Studio)
```

## The loop

1. (Optional) Drop reference images into `refs/`. Claude uses them to shape the `bpy` script —
   important for organic/creature meshes.
2. Claude authors a build script in `scripts/` and **runs Blender headless** to export an FBX:
   ```bash
   blender -b --python assets/blender/scripts/example_prop.py -- --out assets/blender/out/crate.fbx
   ```
3. **Human step (not headless):** import `out/*.fbx` via Studio's **3D Importer**, confirm scale +
   orientation, then commit the resulting MeshPart as an `.rbxmx` and record it in
   `assets/PROVENANCE.md`.
4. To iterate: edit the script, re-export, and use Studio's **Reimport** (keeps colors/welds/anchor).

Generated FBX in `out/` is a build artifact and is git-ignored — the committed `.rbxmx` MeshPart is
the source of truth.
