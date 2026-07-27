# Art Direction — `roblox-modern-lowpoly`

The factory's default look. Two halves — **UI** and **world** — that must read as one game. UI tokens
live in `src/shared/Style.luau` and are documented in [`ui-reference/`](ui-reference/); this file
governs the **world**. A game may override the preset (`style.preset` in `factory.json`), recorded in
its own decision log, but this is the default the factory produces.

## Principles

- **Clean low-poly, not realism.** Simple silhouettes, flat or lightly shaded materials, generous
  scale. Readability over detail.
- **One coherent palette.** World accent colors come from the same family as the UI tokens in
  `Style.luau` (teal / purple / blue / orange / yellow / green over neutral greys). Don't introduce a
  second, clashing palette in the world.
- **Chunky and friendly.** Rounded, slightly oversized props echo the "sticker" UI. Avoid thin,
  fragile, or hyper-detailed geometry.

## The stud grid

- Build the map on a consistent **4-stud grid** (position and size in multiples of 4). This keeps
  aisles walkable, snapping predictable, and hand-tuning in Studio fast.
- Standard clearances: **walkways ≥ 8 studs**, doorways ≥ 7 studs tall, player-facing counters ~4
  studs. These prevent the "aisle too narrow" problems that motivated M1.
- Floors/props are anchored. The map is the committed `map/Map.rbxmx` (see
  [`../docs/GAME_ARCHITECTURE.md`](../docs/GAME_ARCHITECTURE.md) → *Map authoring*).

## Materials

- Prefer a small set of **MaterialService**-consistent materials (SmoothPlastic / Plastic for props,
  Concrete/Slate for ground). Keep the count low so the scene reads as one style.
- Color via `BrickColor`/`Color3` from the shared palette, not per-part improvisation.
- Reserve **Neon** for genuine light sources / accents only — never as a default fill (the brief bars
  excessive glow).

## Lighting & atmosphere

- **Lighting.Technology = Future** for soft, modern shadows.
- Soft, restrained setup: one clear key direction, gentle ambient, no blown-out bloom.
- A light **Atmosphere** for depth (low density) and a subtle **DepthOfField**/**ColorCorrection** are
  optional and must stay understated — the brief bars excessive bloom/particles and any effect that
  implies activity that isn't happening.
- Keep it legible: effects never hide errors or fake progress (see
  [`../docs/RISK_AND_LIMITATIONS.md`](../docs/RISK_AND_LIMITATIONS.md)).

## Checklist for a world pass

- [ ] Geometry on the 4-stud grid; walkways ≥ 8 studs.
- [ ] Palette drawn from the shared `Style.luau` family.
- [ ] Small, consistent material set; Neon only for real accents.
- [ ] `Lighting.Technology = Future`; soft key + gentle ambient; no heavy bloom.
- [ ] Clear silhouettes; no thin/fragile detail; anchored props.
