# Coding Standards (Luau)

Applies to every game. Enforced by Selene (lint) and StyLua (format) in CI; the rest is convention
reviewed in PRs.

## Types & strictness
- Start new ModuleScripts with `--!strict`. Use `--!nonstrict` only with a comment saying why.
- Define shared types in `shared/Types.luau`; import rather than re-declaring shapes.
- Prefer explicit return types on public functions.

## Naming
- `PascalCase` — ModuleScripts, classes/singletons, types.
- `camelCase` — locals, function names, parameters.
- `SCREAMING_SNAKE_CASE` — true constants in `Config`.
- Remotes: `PascalCase` verb-noun, defined only in `shared/Net.luau`.
- Files match the module they return (`DataService.luau` returns `DataService`).

## Structure
- One module = one responsibility. If a file exceeds ~200 lines, consider splitting.
- Scripts/LocalScripts only bootstrap; no gameplay logic in them.
- Pure helpers (no side effects, no DataModel access) go in `shared/util/` and are unit-tested.
- No global state; pass dependencies explicitly or require modules.

## Safety
- Wrap all `DataStore`, `HttpService`, and `MarketplaceService` calls in `pcall` with handling.
- Validate every Remote argument on the server (type and range) before use.
- Never `loadstring` or `require` untrusted/client-supplied code.
- No secrets in source. No `game:GetService("Players").LocalPlayer` on the server.

## Comments & docs
- Document every public function with a one-line purpose and non-obvious params.
- Comment *why*, not *what*, for tricky logic. Match surrounding comment density.
- Keep `docs/DevelopmentLog.md` updated as systems land.

## Errors
- Fail loudly in development (`assert`, `error` with context) rather than swallowing.
- Never hide gameplay errors behind visual effects or empty `pcall`s.

## Formatting (StyLua, non-negotiable in CI)
- 4-space indent, 100-column soft wrap (see `stylua.toml` in the template).
- Run `stylua src/` before committing; CI runs `stylua --check`.

## Lint (Selene)
- Zero Selene errors to merge. Warnings are triaged, not ignored; suppress only with a comment.
