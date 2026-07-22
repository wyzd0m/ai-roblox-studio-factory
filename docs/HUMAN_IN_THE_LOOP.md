# Human-in-the-Loop Map

The factory automates aggressively but stops at a small number of gates where a human is required.
This is the authoritative list. Do not automate past these without an explicit, per-instance
decision by the user.

## Legend
- 🟢 **Automated** — Claude/scripts do it end to end.
- 🟡 **Assisted** — Claude prepares; a human performs a mechanical step (usually inside Studio).
- 🔴 **Human-only** — requires judgment, credentials, or platform ToS compliance.

## The gates

| # | Step | Owner | Notes |
| - | ---- | ----- | ----- |
| 1 | Provide the game idea | 🔴 Human | The one input the factory always needs. |
| 2 | Expand idea → spec | 🟢 Automated | Via `prompts/00-idea-to-spec.md`. |
| 3 | **Review & approve spec** | 🔴 Human | Cheapest place to correct direction. Required gate. |
| 4 | Scaffold game repo | 🟢 Automated | `scripts/new-game.mjs`. |
| 5 | Install toolchain (`rokit install`) | 🟡 Assisted | One command; can be scripted locally. |
| 6 | Implement Luau systems | 🟢 Automated | Code is source of truth; Rojo syncs it. |
| 7 | Build parts/GUI that can't be code-generated | 🟡 Assisted | Studio editor work. Prefer code/procedural geometry to shrink this. |
| 8 | Lint / format / unit tests | 🟢 Automated | CI + local. |
| 9 | Open Studio & sync with Rojo | 🟡 Assisted | Human action; Studio is not headless. |
| 10 | **Playtest against the spec's core loop** | 🔴 Human | Claude cannot press Play or judge fun. Required gate. |
| 11 | Fix playtest notes | 🟢 Automated | Claude edits code from recorded notes. |
| 12 | Complete release checklist | 🟡 Assisted | Claude fills what it can; human verifies. |
| 13 | Publish place / upload assets | 🔴 Human | Credentials + Roblox ToS. |
| 14 | Create/push GitHub repo | 🟡 Assisted | Confirm before remote creation/push; token never committed. |
| 15 | Produce YouTube metadata | 🟢 Automated | Templated. |
| 16 | Upload YouTube video | 🔴 Human | Credentials + content policy. |

## Design principle: shrink the yellow, respect the red

- **Shrink 🟡:** Anything a human does in Studio that *could* be expressed as code should migrate to
  code over time (procedural geometry, GUI-from-code, `Instance`-building ModuleScripts). Every such
  migration reduces manual work on all future games — record it as a factory improvement.
- **Respect 🔴:** The red rows involve judgment or credentials. Never route around them, even if the
  user says "just do it" — instead prepare everything and hand off at the gate.

## What the human actually has to do per game

In the steady state, a human's required footprint is: **supply the idea (1), approve the spec (3),
playtest (10), and publish (13/16).** Everything else is automated or one-command assisted.
