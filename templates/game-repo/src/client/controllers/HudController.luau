--!strict
-- Reference client controller: listens for authoritative StateChanged and reflects it in a
-- minimal HUD. Sends RequestCoreAction on input. Trusts NOTHING it computes locally about score.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Shared.Net)

local HudController = {}

local scoreLabel: TextLabel

local function buildHud()
    local gui = Instance.new("ScreenGui")
    gui.Name = "Hud"
    gui.ResetOnSpawn = false

    scoreLabel = Instance.new("TextLabel")
    scoreLabel.Size = UDim2.fromOffset(200, 40)
    scoreLabel.Position = UDim2.fromOffset(16, 16)
    scoreLabel.BackgroundTransparency = 0.4
    scoreLabel.Text = "Score: 0"
    scoreLabel.Parent = gui

    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function HudController.init()
    buildHud()
end

function HudController.start()
    Net.event(Net.Events.StateChanged).OnClientEvent:Connect(function(payload)
        if type(payload) == "table" and type(payload.score) == "number" then
            scoreLabel.Text = `Score: {payload.score}`
        end
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end
        if input.KeyCode == Enum.KeyCode.E then
            Net.event(Net.Events.RequestCoreAction):FireServer()
        end
    end)
end

return HudController
