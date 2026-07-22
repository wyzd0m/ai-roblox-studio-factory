# Architecture — {{GAME_NAME}}

Follows the factory's [Game Architecture](../../ai-roblox-studio-factory/docs/GAME_ARCHITECTURE.md)
standard (three realms, server authority, code as source of truth). Document game-specific choices
below.

## Realms
- **client/** — controllers: HUD/input/camera. Trusts only server-sent state.
- **server/** — services: authoritative gameplay + persistence.
- **shared/** — `Net` (remote contract), `Config` (server-trusted tunables), `Types`, `util`.

## Remote contract
_List each remote from `shared/Net.luau`, its direction, payload, and server validation._

| Remote | Direction | Payload | Server validation |
| ------ | --------- | ------- | ----------------- |
| RequestCoreAction | client→server | {} | rate-limit only |
| StateChanged | server→client | { score } | n/a (server-authored) |

## Persistence
_Library, keys, and what is stored. Note session-locking and retry policy._

## Game-specific deviations from the standard
_Record any deviation here and in the game's decision log._
