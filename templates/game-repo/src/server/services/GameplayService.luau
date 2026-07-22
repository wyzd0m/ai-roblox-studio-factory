--!strict
-- Authoritative core-loop service. Owns per-player score; validates and rate-limits every
-- client request. This is the reference for "server decides, client asks".
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net)
local Config = require(ReplicatedStorage.Shared.Config)
local Guard = require(ReplicatedStorage.Shared.util.Guard)
local Types = require(ReplicatedStorage.Shared.Types)

local GameplayService = {}

local states: { [Player]: Types.PlayerState } = {}

local function onPlayerAdded(player: Player)
    states[player] = { score = Config.STARTING_SCORE, lastActionAt = 0 }
end

local function onPlayerRemoving(player: Player)
    states[player] = nil
end

-- Handles RequestCoreAction. Rejects if rate-limited; otherwise applies and broadcasts new state.
local function onCoreAction(player: Player)
    local state = states[player]
    if not state then
        return
    end

    local now = os.clock()
    if now - state.lastActionAt < Config.CORE_ACTION_COOLDOWN then
        return -- rate limited; silently drop (client cannot spam the server)
    end
    state.lastActionAt = now

    -- Core loop effect — replace with the game's real rule. Server owns the number.
    local nextScore = state.score + 1
    if Guard.inRange(nextScore, 0, Config.MAX_SCORE) then
        state.score = nextScore
    end

    Net.event(Net.Events.StateChanged):FireClient(player, { score = state.score })
end

function GameplayService.init()
    for _, player in Players:GetPlayers() do
        onPlayerAdded(player)
    end
    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(onPlayerRemoving)
end

function GameplayService.start()
    Net.event(Net.Events.RequestCoreAction).OnServerEvent:Connect(function(player)
        onCoreAction(player)
    end)
end

return GameplayService
