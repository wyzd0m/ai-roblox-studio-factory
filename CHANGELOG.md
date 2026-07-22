# Changelog

All notable changes to the **factory** (not to individual games) are recorded here.
Format follows [Keep a Changelog](https://keepachangelog.com/); this project uses
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Initial factory foundation: engineering contract (`CLAUDE.md`), README, and license.
- Core docs: factory + game architecture, development workflow, coding standards, toolchain,
  automation guide, human-in-the-loop map, risk/limitations, definition of done, decision log.
- Templates: game spec, prompt, README, game-repo scaffold (Rojo project, Rokit/Selene/StyLua/
  Wally config, reference `src/` layout, CI workflow), and YouTube metadata set.
- Prompt pipeline: idea→spec→architecture→review.
- Standards: project checklist and release checklist.
- Automation: `scripts/new-game.mjs` scaffolder and games registry.

### Notes
- Scope is explicitly **high-automation, human-gated** — not "fully autonomous". See
  `docs/RISK_AND_LIMITATIONS.md`.
