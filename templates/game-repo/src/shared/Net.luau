--!strict
-- The ONLY place RemoteEvents/Functions are named. Neither realm creates Remotes inline.
-- Each entry documents direction and payload; server handlers MUST validate every field.
--
-- Convention: a bootstrap creates a folder `ReplicatedStorage/Remotes` and one RemoteEvent per
-- key below. `Net.event(name)` resolves it on either realm.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = {}

-- Registry of remote names. Add new remotes here, nowhere else.
Net.Events = {
    -- client -> server: player asks to do the core action; server validates & applies.
    RequestCoreAction = "RequestCoreAction", -- payload: {} (extend per game)
    -- server -> client: authoritative HUD/state update.
    StateChanged = "StateChanged", -- payload: { score: number }
}

local FOLDER_NAME = "Remotes"

-- Server calls this once at boot to create the RemoteEvent instances.
function Net.build(): Folder
    local folder = Instance.new("Folder")
    folder.Name = FOLDER_NAME
    for _, remoteName in Net.Events do
        local remote = Instance.new("RemoteEvent")
        remote.Name = remoteName
        remote.Parent = folder
    end
    folder.Parent = ReplicatedStorage
    return folder
end

-- Either realm resolves a remote by its registered name.
function Net.event(name: string): RemoteEvent
    local folder = ReplicatedStorage:WaitForChild(FOLDER_NAME)
    return folder:WaitForChild(name) :: RemoteEvent
end

return Net
