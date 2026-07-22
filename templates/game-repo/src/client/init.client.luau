--!strict
-- Client bootstrap: thin entry point. Two-phase-starts every controller. No gameplay logic here.
local Players = game:GetService("Players")

local controllers = Players.LocalPlayer:WaitForChild("PlayerScripts").Client.controllers

local loaded = {}
for _, module in controllers:GetChildren() do
    if module:IsA("ModuleScript") then
        loaded[module.Name] = require(module)
    end
end

for _, controller in loaded do
    if type(controller) == "table" and type(controller.init) == "function" then
        controller.init()
    end
end
for _, controller in loaded do
    if type(controller) == "table" and type(controller.start) == "function" then
        controller.start()
    end
end
