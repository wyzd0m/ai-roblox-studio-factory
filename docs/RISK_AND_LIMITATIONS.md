# Risks & Limitations — reading the brief honestly

The original brief aims for a "fully autonomous workflow where Claude generates complete Roblox
games from a single prompt." That ambition is the right North Star, but taken literally it would
produce broken or non-shippable games. This document lists the weaknesses in the naive reading and
the design decisions that address each one. It is the single most important doc to internalize.

## 1. Roblox Studio is not headless

**Problem.** There is no supported way for an external process (or Claude) to open Studio, place
parts, build GUIs, tune physics, press Play, and observe the result. Rojo syncs *code* into a
running Studio session; it does not drive the editor or the play session.

**Consequence.** "Generate a complete game from a prompt with zero human involvement" is not
achievable end-to-end today.

**Decision.** The factory is **high-automation, human-gated**. Claude authors everything that can
be expressed as code and configuration (systems, data, UI built from code, procedural geometry).
A human performs the irreducibly-in-Studio steps: opening Studio, syncing, any manual scene work
that can't be code-generated, and **playtesting**. These points are enumerated in
[`HUMAN_IN_THE_LOOP.md`](HUMAN_IN_THE_LOOP.md).

## 2. "Fun" and "works" are different bars, and only one is machine-checkable

**Problem.** Success criteria in the brief ("gameplay loop functional", "no obvious script errors")
mix a mechanical bar with an experiential one. Automation can verify the first, not the second.

**Decision.** Two explicit gates in [`DEFINITION_OF_DONE.md`](DEFINITION_OF_DONE.md):
- **Mechanical gate (automated):** Selene lint clean, StyLua formatted, unit tests pass, Rojo
  builds, no runtime errors in a smoke session.
- **Experience gate (human):** a playtest against the spec's core loop, recorded as notes.
Never mark a game "done" on the mechanical gate alone.

## 3. Publishing and uploading are credential + Terms-of-Service actions

**Problem.** Publishing a place, uploading decals/audio/models, and uploading YouTube videos all
require authenticated sessions and are governed by platform policy. Automating them is both a
security risk and a ToS risk.

**Decision.** These are **always** human actions. Claude prepares the artifacts (built place,
asset list with provenance, video metadata) and stops at the publish button. See the release flow
in [`../standards/RELEASE_CHECKLIST.md`](../standards/RELEASE_CHECKLIST.md).

## 4. Repo sprawl ("dozens or hundreds of repositories")

**Problem.** One repo per game scales the count of repos linearly with no shared home, making the
portfolio hard to navigate and standards hard to keep consistent.

**Decision.**
- A **single source of standards** (this factory) that every game inherits via the scaffold.
- A **registry** ([`../games/REGISTRY.md`](../games/REGISTRY.md)) indexing every game with links
  and status, so the collection is navigable.
- Strict **naming convention** (`Claude-<PascalGameName>`) enforced by the scaffolder.
- Standards live in *one* place; games get a copy at scaffold time and a note pointing back here.

## 5. Undefined "complete game"

**Problem.** Without a concrete spec, "complete" is subjective and un-testable.

**Decision.** Every game starts from a filled [`../templates/GAME_SPEC_TEMPLATE.md`](../templates/GAME_SPEC_TEMPLATE.md)
that defines the core loop, systems, win/lose conditions, and scope boundaries. "Complete" means
"the spec's core loop is implemented and passes both gates." Scope is fixed at spec time to prevent
endless expansion.

## 6. Reproducibility / "latest" drift

**Problem.** Unpinned tools (Rojo, Selene, StyLua) mean a game that built last month may not build
today, and CI may disagree with local.

**Decision.** Pin every tool via **Rokit** (`rokit.toml`) per game. CI uses the same manifest. See
[`TOOLCHAIN.md`](TOOLCHAIN.md).

## 7. Security of automation (git push, repo creation, tokens)

**Problem.** Automating GitHub operations needs credentials; mishandling leaks them.

**Decision.** Use the `gh` CLI or a user-supplied PAT held in the environment, never committed.
Creating remote repos and pushing are confirmed with the user, not done silently. See
[`AUTOMATION_GUIDE.md`](AUTOMATION_GUIDE.md).

## 8. Content, legal, and asset provenance

**Problem.** AI-generated games can inadvertently use assets or concepts that violate Roblox/YouTube
policy or third-party rights.

**Decision.** Placeholder-first asset policy (Roblox primitives, procedural geometry, or clearly
licensed sources), AI disclosure in every README, and a provenance note in each game's `docs/`.
If a requested concept appears to violate platform policy, say so before building.

## 9. Playtest feedback has no automatic loop

**Problem.** The brief wants continuous improvement but defines no measurable signal.

**Decision.** Each game records: CI pass/fail, lint warning count, and playtest notes in
`docs/DevelopmentLog.md`. Recurring problems are fixed **in the factory template**, not just in the
one game — so the fix compounds.

## 10. Committed-map syncback is human-verified, not headless-testable

**Problem.** M1 makes the map a committed `map/Map.rbxmx` that a human can hand-tune in Studio and
capture back with `rojo syncback`. Claude can verify the *forward* direction headlessly (the map
builds and mounts at `Workspace/Map` via `rojo build`/`sourcemap`), but the *round-trip* — edit in
Studio → save place → `syncback` writes only `map/Map.rbxmx` — depends on a running Studio session
and cannot be confirmed without a human.

**Decision.** Ship the mechanism with `syncbackRules` scoped to protect `src/`/`tests/`, document the
loop in [`DEVELOPMENT_WORKFLOW.md`](DEVELOPMENT_WORKFLOW.md), and treat the first syncback in a new
game as a **human gate**: confirm the diff touches only the map before committing, and refine
`syncbackRules` if needed. Requires Rojo ≥ 7.7.0 (pinned).

## What this means in practice

You (the human) still only need to supply the idea and do the two things machines can't: **playtest**
and **publish**. Everything between is automated or Claude-authored. That is a dramatically smaller
manual footprint than building by hand — just not literally zero.
