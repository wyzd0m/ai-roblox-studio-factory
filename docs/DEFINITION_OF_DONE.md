# Definition of Done

A game is **done** only when both gates below pass. The mechanical gate is automated; the experience
gate is a human playtest. Neither substitutes for the other.

## Mechanical gate (automated — CI + local)
- [ ] `rojo build` succeeds and produces a place file.
- [ ] `stylua --check src/` clean (formatted).
- [ ] `selene src/` has zero errors; warnings triaged.
- [ ] Unit tests pass (pure logic in `shared/util` and service helpers).
- [ ] No runtime errors in a smoke session (join, core loop once, leave).
- [ ] `--!strict` on new modules; no unexplained `--!nonstrict`.
- [ ] All Remotes defined in `shared/Net.luau`; server validates every argument.

## Experience gate (human playtest)
- [ ] The spec's **core loop** is playable start to finish.
- [ ] Win/lose (or progression) conditions from the spec trigger correctly.
- [ ] Save/load persists across rejoin (if the game has persistence).
- [ ] No exploit obvious in 10 minutes (client can't grant itself currency/progress).
- [ ] Playtest notes recorded in `docs/DevelopmentLog.md`; blocking notes fixed.

## Repository gate (portfolio quality)
- [ ] README complete: overview, features, tech, structure, install, Rojo sync, screenshots
      section, future improvements, credits, **AI disclosure**.
- [ ] `docs/` has Architecture, GameDesign, DevelopmentLog, FutureIdeas.
- [ ] CHANGELOG updated; commits clean and conventional.
- [ ] Asset provenance recorded; no unlicensed assets.
- [ ] YouTube metadata set generated (titles, thumbnail ideas, description, summary, future ideas).
- [ ] Game added to `games/REGISTRY.md`.

## Release gate (human)
- [ ] `standards/RELEASE_CHECKLIST.md` complete.
- [ ] Human has published the place / uploaded assets (never automated).

Only when all four gates are satisfied is the game "complete" and ready for publishing.
