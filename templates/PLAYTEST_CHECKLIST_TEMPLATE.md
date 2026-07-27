# Playtest Checklist — <GAME_NAME>

> Generated for a specific playtest handoff. Claude fills this from the game's spec/systems, then the
> human plays it and records results. One per handoff (Phase 3 first loop, Phase 5 polish, pre-release).
> Claude cannot press Play or judge fun — this checklist is how the factory hands the game to the human
> honestly. See [`../docs/HUMAN_IN_THE_LOOP.md`](../docs/HUMAN_IN_THE_LOOP.md).

- **Build / commit:** `<git short sha>` on `<branch>`
- **What changed since last playtest:** `<1–3 lines, or "first playtest">`
- **How to run:** `rojo serve` → connect Studio (Rojo plugin) → press **Play** (or **Start** with N
  players for multiplayer). For DataStore tests, enable *Game Settings → Security → Studio Access to
  API Services* first.

## 1. Core loop — walk it end to end

> Claude fills these from the spec's core loop. Each step: **Do → Expect**.

- [ ] `<step 1: do X>` → `<expect Y>`
- [ ] `<step 2>` → `<expect>`
- [ ] `<step 3>` → `<expect>`
- [ ] The loop **repeats** and win/lose (or progression) triggers as specced.

## 2. Per-system checks

> One row per in-scope system from the spec. "Try to break it" is the exploit/edge probe.

| System | Try this | Expect | Try to break it |
| ------ | -------- | ------ | --------------- |
| `<system 1>` | `<action>` | `<result>` | `<edge/exploit to attempt>` |
| `<system 2>` | | | |
| `<system 3>` | | | |

## 3. Security / anti-exploit (server authority)

- [ ] Client cannot grant itself currency/progress (try firing remotes directly / out of range).
- [ ] Actions only succeed when the player is actually eligible (near the task, has the funds, etc.).
- [ ] Rejoin restores persisted state correctly (if `persistence.datastore = enabled`).

## 4. Feel & tuning (record numbers, don't guess)

- [ ] Character movement (`WalkSpeed`, jump) feels right for the game — note any value to change in
      `Config.luau`.
- [ ] Collision/hitboxes & interaction ranges (`ProximityPrompt` distances) feel right.
- [ ] Pacing: the loop/phase timing doesn't drag or rush — note the `Config` value to retune.
- [ ] Audio present where intended (or intentionally silent); no missing-SoundId warnings in output.

## 5. Human-only judgments — the factory does **NOT** claim these

These are yours alone; automation cannot verify them. Answer honestly — a "no" is a valid, useful
result, not a failure of the build:

- [ ] **Fun:** did the core loop actually feel good to play?
- [ ] **Feel:** does moment-to-moment interaction feel responsive and fair?
- [ ] **Balance:** is difficulty/economy/pacing in a good place?
- [ ] `<game-specific tone check — e.g. "did the 10 PM half amuse and the 4 AM half unsettle?">`

## 6. Results → feed the loop

- **Blocking issues (must fix before next handoff):** `<list>`
- **Non-blocking notes:** `<list>`
- **Verdict:** ☐ ready to progress  ☐ needs another pass
- [ ] Copied into `docs/DevelopmentLog.md` (recurring problems get fixed in the **factory template**,
      not just this game).
