# Release Checklist (per game)

Everything below "Human-only" is prepared by Claude and executed by a human. Publishing is never
automated.

## Code & quality (automated-verifiable)
- [ ] `rojo build` produces a place file.
- [ ] `stylua --check src/` clean.
- [ ] `selene src/` zero errors.
- [ ] Unit tests pass.
- [ ] No runtime errors in a smoke session.
- [ ] Server validates all Remote inputs; no obvious 10-minute exploit.

## Documentation (portfolio quality)
- [ ] README complete incl. **AI disclosure** and screenshots section.
- [ ] `docs/` Architecture, GameDesign, DevelopmentLog, FutureIdeas present.
- [ ] CHANGELOG updated; version tagged (e.g. v0.1.0).
- [ ] Asset provenance recorded; no unlicensed assets.
- [ ] YouTube metadata generated in `video/`.
- [ ] Game added/updated in `games/REGISTRY.md`.

## Git
- [ ] Clean, conventional commit history.
- [ ] Repo pushed to GitHub (confirmed by human; token never committed).

## Human-only (do NOT automate)
- [ ] Human playtest sign-off recorded in `docs/DevelopmentLog.md`.
- [ ] Human publishes the place / uploads assets in Studio.
- [ ] Human uploads the YouTube video (if applicable).
- [ ] Repo visibility set intentionally (private → public) by the human.
