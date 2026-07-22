# Automation Guide

What the factory automates, how, and — importantly — where automation deliberately stops.

## Principle
Automate anything that is deterministic and reversible. Gate anything that needs judgment,
credentials, or touches an external platform. See [`HUMAN_IN_THE_LOOP.md`](HUMAN_IN_THE_LOOP.md).

## Automated today

### Scaffolding — `scripts/new-game.mjs`
Creates a new game repo from `templates/game-repo/`, substituting placeholders:
- `{{GAME_NAME}}` → "Claude Obby"
- `{{GAME_SLUG}}` → "Claude-Obby" (repo/folder name; PascalCase, `Claude-` prefix)
- `{{GAME_KIND}}` → e.g. `obby`, `tycoon`, `simulator`
- `{{YEAR}}`, `{{DATE}}` → current year/date
Idempotent and safe: refuses to overwrite an existing target unless `--force`.
```bash
node scripts/new-game.mjs --name "Claude Obby" --kind obby
# creates ../Claude-Obby/ next to the factory
```

### Docs & metadata generation
README, CHANGELOG, and the YouTube metadata set are generated from templates + the game spec, kept
current in the same PR as the code they describe.

### Quality gates
Selene, StyLua, unit tests, and `rojo build` run locally and in CI on every push.

## Automated with confirmation (never silent)

### GitHub repo creation & push
Use the `gh` CLI when available:
```bash
gh repo create Claude-Obby --private --source ../Claude-Obby --push
```
Rules:
- **Confirm with the user** before creating a remote repo or first push.
- Auth via `gh auth login` or a PAT in the environment (`GH_TOKEN`). **Never** commit or echo a
  token; never hardcode one in a script or workflow. Prefer fine-grained PATs scoped to repo
  creation/contents.
- Default new game repos to **private** until the user opts to publish.

## Deliberately NOT automated
- Opening Studio, playtesting, judging fun.
- Publishing a place, uploading assets, uploading YouTube videos.
- Accepting any Terms of Service or granting OAuth scopes.
These are human actions; the factory prepares artifacts and stops at the gate.

## Extending automation
When you add a script, it must: be idempotent, refuse to clobber without `--force`, print exactly
what it changed, and never require a secret to be passed on the command line (read from env). Record
new automation here and in the changelog.
