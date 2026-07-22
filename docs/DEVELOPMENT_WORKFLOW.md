# Development Workflow

How a single game moves from idea to release. Phased, with a review gate between major phases. Do
not generate a whole game in one uncontrolled pass — each phase ends with checks, a report, and a
stop for review.

## Phases

### Phase 0 — Idea → Spec
- Input: one-line idea.
- Expand with `prompts/00-idea-to-spec.md` into a filled `GAME_SPEC_TEMPLATE.md`.
- **Gate:** human reviews and approves the spec. Scope is frozen here.

### Phase 1 — Scaffold
- Run `scripts/new-game.mjs --name "<Name>" --kind <kind>`.
- Verify the repo builds empty (`rojo build`) and CI config is present.
- Commit: `chore: scaffold <Name> from factory template`.

### Phase 2 — Architecture
- Fill `docs/Architecture.md` and `docs/GameDesign.md` in the game from the spec.
- Define `shared/Net.luau`, `shared/Config.luau`, `shared/Types.luau` (the contracts) before logic.
- **Gate:** review the contracts. Cheap to change now, expensive later.

### Phase 3 — Core loop
- Implement the spec's single most important loop end-to-end (server-authoritative), plus the
  minimal client feedback to observe it.
- Tests for pure logic. Lint + format clean.
- **Gate:** first human playtest of the core loop.

### Phase 4 — Systems
- Add remaining systems (economy, save, UI, progression) in small commits, each self-contained.
- Keep CI green continuously.

### Phase 5 — Polish & content
- Placeholder → better procedural assets, tuning from playtest notes, UI polish.

### Phase 6 — Release
- Complete `standards/RELEASE_CHECKLIST.md`. Human publishes. Update README/CHANGELOG/registry.

At each phase end: run relevant checks, report exactly what changed, list warnings/unsupported
assumptions, update the game's decision log if architecture changed, and stop for review.

## Git flow

- **Trunk-based**, small commits. Branch per phase/feature (`feat/core-loop`), PR into `main`.
- **Conventional Commits** for message hygiene and auto-changelog:
  - `feat:` new player-facing capability
  - `fix:` bug fix
  - `refactor:` no behavior change
  - `chore:` tooling/scaffold/config
  - `docs:` documentation only
  - `test:` tests only
- Commit **frequently** and keep each commit buildable. Avoid giant commits.
- Every PR: CI green (lint + format-check + tests + `rojo build`) before merge.

Example commit sequence (matches the brief's intent, but incremental):
```
chore: scaffold Claude-Obby from factory template
feat: player checkpoint + respawn system
feat: kill-brick and lava hazards
feat: stage progression and win condition
feat: leaderstats + save best time
fix: respawn double-trigger on touched
docs: architecture + development log
chore: release v0.1.0
```

## Definition of "phase complete"

A phase is complete only when: its checks pass, its changes are committed, its docs are updated, and
the review gate (if any) is cleared. Half-finished phases are not carried silently into the next.
