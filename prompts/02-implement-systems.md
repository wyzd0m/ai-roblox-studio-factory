# Prompt: Implement Systems (Phases 3–5)

---
Implement <GAME_NAME> following `docs/GAME_ARCHITECTURE.md`, `docs/CODING_STANDARDS.md`, and the
approved contracts.

Order:
1. Core loop end-to-end, server-authoritative, with minimal client feedback. Then STOP for a
   human playtest of the core loop.
2. After the core loop is confirmed, add remaining systems in small conventional commits.

Requirements each commit:
- `--!strict` on new modules; server validates all Remote inputs.
- StyLua-formatted, Selene-clean, unit tests for pure logic, `rojo build` succeeds.
- Update `docs/DevelopmentLog.md` and `CHANGELOG.md`.

Never claim the game is playtested or fun — those are human judgments. Stop at the human gates in
`docs/HUMAN_IN_THE_LOOP.md`.
---
