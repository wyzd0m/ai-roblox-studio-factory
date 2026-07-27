--!strict
-- The ONLY place Sound assets are named. Reference sounds by name via Audio.get(name); never inline
-- a raw rbxassetid elsewhere. SoundIds are HUMAN-SOURCED from Roblox's free/licensed audio library
-- (Claude never fabricates or uploads audio) and recorded in assets/audio/PROVENANCE.md.
--
-- Fill an id below when you source a sound; leave "" for ones not yet sourced — Audio.get warns and
-- returns nil for an unset id so a missing asset never hard-crashes the game.
local SoundService = game:GetService("SoundService")

local Audio = {}

-- Registry of sound name -> "rbxassetid://<id>". Add new sounds here, nowhere else.
Audio.Sounds = {
    UiClick = "", -- UI button press
    TaskComplete = "", -- a core-loop task finished
} :: { [string]: string }

-- Build a Sound for a registered name, parented to SoundService. Returns nil (with a warning) if the
-- id is unset, so callers can `local s = Audio.get(...) if s then s:Play() end` safely.
function Audio.get(name: string): Sound?
    local id = Audio.Sounds[name]
    if not id or id == "" then
        warn(
            `[Audio] no SoundId set for "{name}" — add it in shared/Audio.luau + assets/audio/PROVENANCE.md`
        )
        return nil
    end
    local sound = Instance.new("Sound")
    sound.Name = name
    sound.SoundId = id
    sound.Parent = SoundService
    return sound
end

return Audio
