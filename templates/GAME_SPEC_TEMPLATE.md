# Game Spec — {{GAME_NAME}}

> Fill this from the one-line idea **before** scaffolding. This is the review gate: correcting
> direction here is free; correcting it after implementation is expensive. Freeze scope when
> approved. One filled copy lives in the game repo at `docs/GameSpec.md`.

## 1. One-liner
_A single sentence: what the player does and why it's fun._

## 2. Genre / kind
`{{GAME_KIND}}` (obby | tycoon | simulator | horror | tower-defense | racing | …)

## 3. Core loop (the one thing that must work)
_The 15–60 second cycle the player repeats. Be concrete._
1.
2.
3.

## 4. Win / lose / progression
- **Goal:**
- **Failure:**
- **Progression:** _(levels, currency, unlocks — or "session-based, no persistence")_

## 5. Systems (scoped list — this bounds the build)
| System | In v1? | Notes |
| ------ | ------ | ----- |
| Core loop mechanic | ✅ | |
| Currency / economy | | |
| Save / load (persistence) | | |
| UI / HUD | | |
| Progression / unlocks | | |
| Multiplayer specifics | | |

_Anything not listed here is explicitly out of scope for v1._

## 6. Server-authoritative state
_What must the server own and validate? (currency, progress, inventory…)_

## 7. Controls
_Inputs (keyboard/mobile/gamepad) and what they do._

## 8. Art & audio direction
_Placeholder-first: primitives / procedural geometry. Note any licensed assets + their source._

## 9. Non-goals (v1)
_Explicitly list what you are NOT building, to prevent scope creep._

## 10. Success criteria (maps to Definition of Done)
- Core loop playable end to end.
- Server-authoritative state can't be forged by the client.
- Mechanical gate (lint/format/tests/build) green.
- Portfolio gate (README/docs/changelog) complete.

## 11. Risks / unknowns
_Anything that might not work; the riskiest thing to prototype first._

---
_Approved by: __________  Date: {{DATE}}  — scope frozen at approval._
