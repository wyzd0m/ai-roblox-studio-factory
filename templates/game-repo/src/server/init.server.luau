--!strict
-- Server bootstrap: thin entry point. Builds Remotes, then two-phase-starts every service.
-- No gameplay logic lives here.
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net)
local services = ServerScriptService.Server.services

Net.build() -- create Remote instances before services wire to them

local loaded = {}
for _, module in services:GetChildren() do
    if module:IsA("ModuleScript") then
        loaded[module.Name] = require(module)
    end
end

-- Two-phase start: init() everything, then start() everything (avoids ordering bugs).
for _, service in loaded do
    if type(service) == "table" and type(service.init) == "function" then
        service.init()
    end
end
for _, service in loaded do
    if type(service) == "table" and type(service.start) == "function" then
        service.start()
    end
end

print("[{{GAME_NAME}}] server started")
