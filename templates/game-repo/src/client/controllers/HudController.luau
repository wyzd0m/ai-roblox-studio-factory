--!strict
-- Reference HUD, built from the roblox-modern-lowpoly UI kit. Reflects the authoritative
-- StateChanged into a currency pill. Trusts NOTHING it computes locally about score.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Shared.Net)
local Style = require(ReplicatedStorage.Shared.Style)
local Kit = require(script.Parent.Parent.ui.Kit)

local HudController = {}

local amountLabel: TextLabel

local function buildHud()
    local gui = Instance.new("ScreenGui")
    gui.Name = "Hud"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    -- Currency pill, top-left.
    local pill, label = Kit.currencyPill("$", 0)
    pill.AnchorPoint = Vector2.new(0, 0)
    pill.Position = UDim2.new(0, 16, 0, 16)
    pill.Parent = gui
    amountLabel = label

    -- Side rail of chunky icon buttons (shop / pets / settings) — a native-feeling menu rail.
    local rail = Instance.new("Frame")
    rail.Name = "SideRail"
    rail.BackgroundTransparency = 1
    rail.AnchorPoint = Vector2.new(0, 0.5)
    rail.Position = UDim2.new(0, 16, 0.5, 0)
    rail.Size = UDim2.fromOffset(52, 200)
    rail.Parent = gui

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, Style.pad.sm)
    layout.Parent = rail

    Kit.sideRailButton("S", Style.color.orange).Parent = rail
    Kit.sideRailButton("P", Style.color.purple).Parent = rail
    Kit.sideRailButton("=", Style.color.blue).Parent = rail

    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function HudController.init()
    buildHud()
end

function HudController.start()
    Net.event(Net.Events.StateChanged).OnClientEvent:Connect(function(payload)
        if type(payload) == "table" and type(payload.score) == "number" then
            amountLabel.Text = tostring(payload.score)
        end
    end)
end

return HudController
