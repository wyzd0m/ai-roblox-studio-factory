"""
example_prop.py — reference Blender build script for the factory pipeline.

Builds a low-poly grocery crate and exports an FBX ready for the Roblox 3D Importer. Copy this as a
starting point for a real prop; feed reference images (see ../refs/) for organic shapes.

Run headless (no GUI) — this is how Claude authors a mesh end-to-end:

    blender -b --python assets/blender/scripts/example_prop.py -- --out assets/blender/out/crate.fbx

Then a human imports the FBX via Studio's 3D Importer and commits the resulting MeshPart as an
.rbxmx. See standards/BLENDER_PIPELINE.md for the full contract; the export settings below follow
Roblox's published export requirements. Scale and orientation are always confirmed at import
(Studio's importer has a scale field) — that step cannot be verified headlessly.
"""

import bpy
import sys
import os


def clear_scene() -> None:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete()
    for mesh in list(bpy.data.meshes):
        bpy.data.meshes.remove(mesh)


def build_crate() -> "bpy.types.Object":
    bpy.ops.mesh.primitive_cube_add(size=1.0)
    obj = bpy.context.active_object
    obj.name = "GroceryCrate"
    obj.scale = (0.6, 0.6, 0.5)
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    # A single-segment bevel keeps the silhouette friendly while staying low-poly.
    bevel = obj.modifiers.new(name="Bevel", type="BEVEL")
    bevel.width = 0.02
    bevel.segments = 1
    bpy.ops.object.modifier_apply(modifier=bevel.name)
    return obj


def parse_out(default: str = "crate.fbx") -> str:
    argv = sys.argv
    argv = argv[argv.index("--") + 1 :] if "--" in argv else []
    if "--out" in argv:
        default = argv[argv.index("--out") + 1]
    return os.path.abspath(default)


def export_fbx(out_path: str) -> None:
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    bpy.ops.object.select_all(action="SELECT")
    # Roblox export contract (see standards/BLENDER_PIPELINE.md):
    bpy.ops.export_scene.fbx(
        filepath=out_path,
        use_selection=True,
        apply_unit_scale=True,
        apply_scale_options="FBX_SCALE_UNITS",  # "Apply Scalings = FBX Unit Scale"
        global_scale=0.01,  # 1 Blender metre -> 1 stud
        axis_forward="-Z",
        axis_up="Y",
        mesh_smooth_type="FACE",
        add_leaf_bones=False,  # Roblox importer dislikes leaf bones
        bake_anim=False,  # static prop: no animation baked
        path_mode="COPY",
        embed_textures=True,
    )


def main() -> None:
    clear_scene()
    build_crate()
    out_path = parse_out()
    export_fbx(out_path)
    # Sentinel the caller (and CI/verification) can grep for.
    print("EXPORTED:", out_path)


main()
