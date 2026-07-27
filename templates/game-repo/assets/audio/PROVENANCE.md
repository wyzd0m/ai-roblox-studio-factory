# Audio Provenance

Every sound in this game, its source, and its license. **Audio is human-sourced** — Claude never
fabricates or uploads audio. Use Roblox's free/licensed Creator Store audio library (or another
clearly-licensed source). Register names in [`../../src/shared/Audio.luau`](../../src/shared/Audio.luau)
and list them here.

| Name (Audio.luau) | SoundId | Source | License |
| --- | --- | --- | --- |
| UiClick | `rbxassetid://…` | Roblox Creator Store audio | Roblox-licensed |
| TaskComplete | | | |

## Drop-your-audio step (human)

1. Find a sound in the Roblox Creator Store audio library (or a clearly-licensed source).
2. Paste its `rbxassetid://<id>` into the matching entry in `src/shared/Audio.luau`.
3. Add/complete its row above with the source and license.

Never commit or reference unlicensed audio. Anything without a clear license does not ship.
