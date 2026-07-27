# UI Reference — `roblox-modern-lowpoly`

The visual source of truth for the factory's default UI. `src/shared/Style.luau` encodes these
values as tokens; `src/client/ui/Kit.luau` builds components from them. When in doubt, match the
reference screenshot(s) in this folder.

## Drop the reference screenshot here

Add the shop-menu screenshot (and any other target screens) to this folder as e.g.
`shop-example.png`, and link it below. It is the literal target the kit is tuned against — keep it
committed so reviewers and future Claude sessions can see the goal.

> _Add: `![Shop reference](shop-example.png)` once the image is committed._

## The look (the "80% of Roblox games" style)

Non-negotiable traits, all produced by the kit:

- **Chunky rounded cards** — large `UICorner` radius; a white/light panel as the modal body
  (`Style.radius.card`, `Style.color.panel`).
- **Thick dark outlines** on every element via `UIStroke` — the defining "sticker" look, not subtle
  1px lines (`Style.stroke.thick`, `Style.color.outline`).
- **Bright, saturated, glossy tiles** — each tile its own vivid color (teal / purple / blue / orange /
  yellow / green) with a top-lit `UIGradient` gloss + soft shadow (`Kit.tile`, `Style.gloss`).
- **Bold UPPERCASE headers** on a solid accent bar (e.g. red "SHOP" bar) (`Kit.header`,
  `Style.color.accent`, `Style.font.heading`).
- **Currency pills** — rounded pills pairing a coin/gem icon with a number (`Kit.currencyPill`).
- **Vertical side rail** of chunky rounded icon buttons (`Kit.sideRailButton`).
- **Big pill buttons** with consistent padding + radius (`Kit.pillButton`).

## Rules

- **Never hardcode a look.** All colors, radii, strokes, fonts, and spacing come from `Style.luau`.
  If a value is missing, add a token — don't inline a literal.
- **Scale, not pixels.** Size with `UDim2` Scale (and `TextScaled`) so UI fits phone, tablet, and
  console. Fixed offsets only for small fixed-size chrome (pills, rail buttons).
- **Consistent radius + padding** across a screen; reach for `Style.radius.*` and `Style.pad.*`.
- Custom/stylized games may override `style.preset`, but this is the default.
