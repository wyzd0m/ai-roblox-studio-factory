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

<!-- Add new decisions above this line. -->
