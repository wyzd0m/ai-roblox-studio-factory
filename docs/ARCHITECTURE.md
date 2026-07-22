# Factory Architecture

How the factory itself is organized (for the shape of a *game*, see `GAME_ARCHITECTURE.md`).

## Components

```
┌─────────────────────────────────────────────────────────────┐
│                     AI Roblox Studio Factory                 │
│                                                              │
│  prompts/         templates/            standards/           │
│  idea→spec        game-repo/ (scaffold) project/release      │
│  spec→arch        GAME_SPEC_TEMPLATE    checklists           │
│  implement        PROMPT/README         (definition of done) │
│  review           youtube/                                   │
│        \              |                     /                │
│         \             v                    /                 │
│          →   scripts/new-game.mjs   ←──────                  │
│                     |                                        │
│                     v                                        │
│         ../Claude-<Game>/  (a new game repo)                 │
│                     |                                        │
│                     v                                        │
│              games/REGISTRY.md (index of all games)          │
│                                                              │
│  docs/  = the knowledge base every game inherits            │
└─────────────────────────────────────────────────────────────┘
```

## Data flow (one game)
1. `prompts/00-idea-to-spec.md` turns an idea into a filled `GAME_SPEC_TEMPLATE.md`.
2. `scripts/new-game.mjs` reads name/kind, copies `templates/game-repo/`, substitutes placeholders,
   emits `../Claude-<Game>/`.
3. Implementation follows `docs/GAME_ARCHITECTURE.md` + `docs/DEVELOPMENT_WORKFLOW.md`.
4. Quality gates (`docs/DEFINITION_OF_DONE.md`) run; human playtests and publishes.
5. The game is registered in `games/REGISTRY.md`.

## Why this shape
- **Separation:** factory logic (templates/standards/automation) is isolated from any single game,
  so improving the factory improves all future games without touching existing ones.
- **Determinism:** scaffolding is a pure copy+substitute, not hand-written boilerplate.
- **Inheritance:** standards live once; games get a snapshot at scaffold time plus a pointer back.

## Evolving the factory
Prefer changing a template/standard/prompt over patching a single game when a problem recurs.
Record architectural changes in `DECISION_LOG.md` and bump the factory `CHANGELOG.md`.
