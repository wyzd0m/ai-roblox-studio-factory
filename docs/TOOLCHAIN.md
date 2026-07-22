# Toolchain

Every game pins its tools so builds are reproducible across machines and CI. No "latest".

## Manager: Rokit
[Rokit](https://github.com/rojo-rbx/rokit) is the successor to Aftman/Foreman and manages tool
versions from a `rokit.toml` committed in each game. Install tools with `rokit install`.

> If you prefer Aftman, the template's `rokit.toml` maps 1:1 to an `aftman.toml`; keep one, not
> both, and record the choice in the game's decision log.

## Pinned tools (defaults in the template)

| Tool | Purpose | Notes |
| ---- | ------- | ----- |
| **Rojo** | Sync `src/` ↔ Studio; build `.rbxl` | `rojo serve` during dev, `rojo build` in CI |
| **Selene** | Luau linter | `selene src/`; config in `selene.toml` |
| **StyLua** | Formatter | `stylua src/` / `stylua --check src/` in CI |
| **Wally** | Package manager | deps in `wally.toml`; `Packages/` gitignored |
| **Lune** (optional) | Headless Luau runtime | run unit tests in CI without Studio |

Pin exact versions in `rokit.toml`. Bumping a version is a `chore:` commit with a note in the
changelog, and CI must stay green across the bump.

## Standard commands (from a game repo)

```bash
rokit install          # install pinned tools
wally install          # fetch packages (if wally.toml has deps)
rojo serve             # start sync server; connect from Studio's Rojo plugin
rojo build -o build.rbxl   # produce a place file (CI artifact / local test)
stylua src/            # format
selene src/            # lint
lune run tests         # run headless unit tests (if configured)
```

## Editor
VS Code with the **Rojo**, **Luau LSP**, **Selene**, and **StyLua** extensions. The template ships
`.vscode/extensions.json` recommending them and `settings.json` wiring format-on-save to StyLua.

## CI
GitHub Actions installs Rokit, then runs format-check, lint, tests, and `rojo build`. The workflow
ships in the template at `.github/workflows/ci.yml`. Publishing is **not** part of CI.
