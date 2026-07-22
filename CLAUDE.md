# Instructions for Claude — AI Roblox Studio Factory

This repository is the **factory**, not a game. Its job is to make producing each new
Roblox game faster, safer, and more consistent than the last. Treat this file as the
permanent engineering contract for the factory itself.

Read this before doing anything. When a request conflicts with it, name the conflict
instead of silently choosing.

## What this repo is

A reusable system — templates, standards, prompts, automation, and docs — that turns a
one-line game idea into a professional, well-documented, version-controlled Roblox project.
Individual games live in their **own repositories**, scaffolded from `templates/game-repo/`.
This repo never contains a shippable game; it contains the machinery that produces them.

## Honest scope (read `docs/RISK_AND_LIMITATIONS.md`)

The original brief asked for a "fully autonomous" pipeline where the human only supplies an
idea. That is not fully achievable today, and pretending otherwise would produce broken
games. Be truthful about the seams:

- **Roblox Studio is not headless.** Placing/adjusting parts, building GUIs, tuning physics,
  and — critically — **playtesting** require a human in Studio. Claude authors code that Rojo
  syncs *into* Studio; Claude cannot press Play and observe the result.
- **Publishing requires human action.** Publishing a place, uploading assets, and uploading
  YouTube videos involve credentials and platform Terms of Service. These are **always**
  human-gated. Claude prepares everything up to the publish button and stops.
- **"No obvious script errors" is verifiable; "the game is fun" is not.** Automated checks
  (lint, format, type-adjacent analysis, unit tests) gate the mechanical quality bar. A human
  playtest gates the experience bar. Both are required for "done."

So the real target is **high-automation, human-gated**, not "fully autonomous." Every place a
human is required is documented in `docs/HUMAN_IN_THE_LOOP.md`. Do not silently automate past
those gates.

## The pipeline (idea → released repo)

1. **Idea → Spec.** Expand the one-line idea into a filled `templates/GAME_SPEC_TEMPLATE.md`.
   Stop for human review of the spec — this is the cheapest place to correct direction.
2. **Spec → Scaffold.** Run `scripts/new-game.mjs` to create the game repo from the template
   with the game's name, slug, and metadata substituted in.
3. **Scaffold → Systems.** Implement the game following `docs/GAME_ARCHITECTURE.md`, in small
   commits (`docs/DEVELOPMENT_WORKFLOW.md`).
4. **Systems → Green.** Lint (Selene), format (StyLua), and tests must pass in CI before a
   human opens Studio.
5. **Green → Playtest.** Human syncs with Rojo, plays, records notes. Claude fixes.
6. **Playtest → Release.** Complete `standards/RELEASE_CHECKLIST.md`. Human publishes.

Do not skip step 1's review gate or step 5's playtest. They are the two points where
automation cannot substitute for a human.

## Engineering standards (enforced on every generated game)

- **Luau, strict where practical.** `--!strict` on new ModuleScripts; downgrade to `--!nonstrict`
  only with a comment explaining why.
- **Rojo project layout.** `default.project.json` maps `src/` into the DataModel. Never hand-edit
  the place file as the source of truth — code is the source of truth.
- **Clean architecture.** Separate `client/`, `server/`, and `shared/`. Gameplay logic lives in
  reusable ModuleScripts; Scripts/LocalScripts are thin entry points. See `docs/GAME_ARCHITECTURE.md`.
- **Pinned toolchain.** Every game pins tool versions via Rokit (`rokit.toml`). No "latest".
- **Deterministic scaffolding.** The scaffolder is idempotent and templated — no bespoke
  per-game boilerplate written by hand.
- **Small commits, conventional messages.** See `docs/DEVELOPMENT_WORKFLOW.md`.
- **Docs are generated alongside code, not after.** README, CHANGELOG, and `docs/` stay current
  in the same PR as the change.
- **AI disclosure is mandatory** in every game README.

## Safety and Terms of Service

- Never enter credentials, publish, or upload on the user's behalf. Prepare and stop.
- Respect Roblox and YouTube Terms of Service and content policies. If a requested game concept
  or asset appears to violate them, say so before building.
- Use only assets the game is licensed to use: procedurally generated placeholders, Roblox
  primitives, or clearly-licensed sources. Record provenance in the game's `docs/`.
- GitHub automation uses the `gh` CLI or a PAT the user supplies. Never hardcode or commit a
  token. Confirm before creating remote repositories or pushing.

## Working method

- Work in the phases in `docs/DEVELOPMENT_WORKFLOW.md`. Do not generate a whole game in one pass.
- At the end of each phase: run the relevant checks, report exactly what changed, report
  warnings and unsupported assumptions, update `docs/DECISION_LOG.md` if architecture changed,
  and stop for review before the next major phase.
- Prefer improving the factory (templates/standards/automation) over hand-fixing one game, when
  a problem will recur. Continuous improvement is part of the job — see the README's "Continuous
  improvement" section.

## Source of truth

Before implementing, consult, in order:

- `docs/GAME_ARCHITECTURE.md` — how a generated game is structured.
- `docs/DEVELOPMENT_WORKFLOW.md` — the phase gates and git flow.
- `docs/CODING_STANDARDS.md` — Luau conventions.
- `docs/TOOLCHAIN.md` — pinned tools and how they run.
- `docs/HUMAN_IN_THE_LOOP.md` — where humans are required.
- `standards/PROJECT_CHECKLIST.md` and `standards/RELEASE_CHECKLIST.md` — done criteria.

When documents conflict, identify the conflict instead of silently choosing one.
