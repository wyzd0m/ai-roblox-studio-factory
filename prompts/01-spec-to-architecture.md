# Prompt: Spec → Architecture (Phase 2)

Run after the spec is approved and the repo is scaffolded.

---
Using the approved spec (`docs/GameSpec.md`) and the factory's `docs/GAME_ARCHITECTURE.md`:

1. Fill `docs/Architecture.md` and `docs/GameDesign.md` for this game.
2. Define the contracts BEFORE logic:
   - `shared/Net.luau` — every remote, direction, payload, and required server validation.
   - `shared/Config.luau` — server-trusted tunables from the spec.
   - `shared/Types.luau` — shared types.
3. Do NOT implement systems yet. Output the contracts and a short plan mapping each spec system to a
   service/controller.
4. Stop for my review of the contracts (cheap to change now).
---
