# AI Roblox Studio Factory

A reusable system for producing professional Roblox games with heavy AI assistance and minimal
manual work — while being honest about the places a human is still required.

> **This repo is the factory, not a game.** Each game is scaffolded into its own repository from
> `templates/game-repo/`. Here you'll find the standards, templates, prompts, and automation that
> make the *second* game far cheaper to build than the first.

## Why a factory instead of one-off games

Building each game from scratch means re-deciding architecture, re-writing config, and
re-inventing docs every time. The factory front-loads those decisions once so that per-game work
is: fill a spec → scaffold → implement systems → playtest → release.

```
AI Roblox Studio Factory
├── templates/     scaffold + spec/prompt/readme/youtube templates
├── docs/          how games are built (architecture, workflow, standards, limits)
├── prompts/       the idea→spec→architecture→review prompt pipeline
├── standards/     project + release checklists (definition of done)
├── scripts/       automation (new-game scaffolder, etc.)
├── games/         local registry/index of games produced
└── CLAUDE.md      the engineering contract
```

## The honest version of "fully autonomous"

The goal is **you provide the idea; the factory does as much as it safely can.** But a few steps
genuinely require a human, and the factory is designed around them rather than pretending they
don't exist:

| Step | Automated? | Why |
| --- | --- | --- |
| Idea → spec | ✅ (with review gate) | Cheap to get direction right early |
| Repo scaffold | ✅ | Fully templated |
| Writing Luau systems | ✅ | Code is the source of truth, synced by Rojo |
| Lint / format / tests | ✅ (CI) | Mechanical quality bar |
| Building parts/GUI in Studio | ⚠️ human | Studio is not headless |
| **Playtesting** | ❌ human | Claude can't press Play or judge fun |
| Publishing place / uploading assets | ❌ human | Credentials + Terms of Service |
| YouTube upload | ❌ human | Credentials + content policy |

See [`docs/RISK_AND_LIMITATIONS.md`](docs/RISK_AND_LIMITATIONS.md) and
[`docs/HUMAN_IN_THE_LOOP.md`](docs/HUMAN_IN_THE_LOOP.md).

## Quick start (producing a game)

1. Copy `templates/GAME_SPEC_TEMPLATE.md`, fill it from your idea (or let Claude expand it via
   `prompts/00-idea-to-spec.md`). **Review it.**
2. Scaffold the repo:
   ```bash
   node scripts/new-game.mjs --name "Claude Obby" --kind obby
   ```
   This creates `../Claude-Obby/` from the template with names substituted.
3. Install the toolchain (`rokit install`) and implement systems per
   [`docs/GAME_ARCHITECTURE.md`](docs/GAME_ARCHITECTURE.md).
4. Get CI green (Selene + StyLua + tests).
5. Sync with Rojo, **playtest in Studio**, fix notes.
6. Complete [`standards/RELEASE_CHECKLIST.md`](standards/RELEASE_CHECKLIST.md) and publish.

## Toolchain

Rojo · Luau · Rokit (toolchain manager) · Selene (lint) · StyLua (format) · Wally (packages) ·
Git/GitHub · GitHub Actions. Versions are pinned per game — see
[`docs/TOOLCHAIN.md`](docs/TOOLCHAIN.md).

## Continuous improvement

The factory is expected to evolve. When you find a better workflow, prompt, or standard, improve
the **template/standard/prompt here** rather than patching a single game — so every future game
inherits the fix. Record architectural decisions in [`docs/DECISION_LOG.md`](docs/DECISION_LOG.md).

## AI disclosure

Games produced here are built with heavy AI assistance (Claude). Each generated repo carries an
explicit AI-disclosure section in its README. This factory itself was designed with Claude.

## License

MIT — see [LICENSE](LICENSE). Generated games default to MIT unless a game's spec overrides it.
