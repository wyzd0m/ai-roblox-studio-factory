# Project Checklist (per game)

Track a game from scaffold to release-ready. Copy into the game's `docs/` or a GitHub issue.

## Phase 0 — Spec
- [ ] Idea captured (one sentence).
- [ ] `GAME_SPEC_TEMPLATE.md` filled.
- [ ] **Human approved the spec; scope frozen.**

## Phase 1 — Scaffold
- [ ] `new-game.mjs` run; repo created with correct name/slug.
- [ ] `rokit install` succeeds; `rojo build` builds empty place.
- [ ] Initial commit pushed (repo private by default).

## Phase 2 — Architecture
- [ ] `docs/Architecture.md` + `docs/GameDesign.md` filled.
- [ ] `Net` / `Config` / `Types` contracts defined and reviewed.

## Phase 3 — Core loop
- [ ] Core loop implemented server-authoritative.
- [ ] Unit tests for pure logic pass; lint/format clean.
- [ ] Playtest handoff generated (`docs/PlaytestChecklist.md` from the template).
- [ ] **First human playtest of the core loop done.**

## Phase 4 — Systems
- [ ] Remaining v1 systems implemented (economy/save/UI/progression as specced).
- [ ] CI green throughout; small conventional commits.

## Phase 5 — Polish
- [ ] Placeholder → procedural assets improved.
- [ ] Fresh playtest handoff generated; tuned from its recorded notes.

## Phase 6 — Release-ready
- [ ] `DEFINITION_OF_DONE.md` mechanical + experience gates pass.
- [ ] `RELEASE_CHECKLIST.md` complete.
- [ ] Registered in `games/REGISTRY.md`.
