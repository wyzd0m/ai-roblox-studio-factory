# {{GAME_NAME}}

> {{ONE_LINER}}

A Roblox game built with the [AI Roblox Studio Factory](https://github.com/) conventions.
Kind: **{{GAME_KIND}}**.

## Features
- <core loop feature>
- <system 2>
- <system 3>

## Technologies
- **Luau** — game logic (strict typing where practical)
- **Rojo** — source ↔ Studio sync; code is the source of truth
- **Rokit** — pinned toolchain
- **Selene** / **StyLua** — lint / format
- **Wally** — packages
- **GitHub Actions** — CI (lint, format-check, tests, `rojo build`)

## Folder structure
```
src/
├── client/     # StarterPlayerScripts — controllers (input, UI, camera)
├── server/     # ServerScriptService — services (data, gameplay); authoritative
└── shared/     # ReplicatedStorage/Shared — Net, Config, Types, util
docs/           # Architecture, GameDesign, DevelopmentLog, FutureIdeas
assets/         # asset provenance + code-built geometry references
video/          # YouTube metadata
```

## Installation
```bash
git clone <repo-url> {{GAME_SLUG}} && cd {{GAME_SLUG}}
rokit install        # install pinned tools
wally install        # fetch packages (if any)
```

## Sync with Rojo
```bash
rojo serve
```
Then in Roblox Studio: open the place, install the **Rojo** plugin, and click **Connect**. Edits to
`src/` sync live. To produce a place file: `rojo build -o build.rbxl`.

## Screenshots
_Add screenshots/GIFs of the core loop here after playtesting._

## Future improvements
- <from docs/FutureIdeas.md>

## Credits
- Design & code: Nick, with heavy AI assistance.
- Built with the AI Roblox Studio Factory.

## AI Disclosure
This game was developed with substantial assistance from Claude (Anthropic). AI generated source
code, documentation, and procedural geometry; a human reviewed, playtested, and published it. Assets
are procedural/primitive placeholders or clearly-licensed sources listed in `assets/`.

## License
MIT — see [LICENSE](LICENSE).
