--!strict
-- Device-agnostic input. Binds the core action across keyboard, gamepad, and touch via
-- ContextActionService — `createTouchButton = true` auto-shows an on-screen button on phones,
-- so a single binding covers input.targets = desktop / mobile / console. See docs/FACTORY_SETTINGS.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local Net = require(ReplicatedStorage.Shared.Net)

local InputController = {}

local ACTION = "CoreAction"

local function onAction(
    _actionName: string,
    state: Enum.UserInputState,
    _input: InputObject
): Enum.ContextActionResult
    if state == Enum.UserInputState.Begin then
        Net.event(Net.Events.RequestCoreAction):FireServer()
    end
    return Enum.ContextActionResult.Pass
end

function InputController.start()
    -- Keyboard E, gamepad R2, plus an auto on-screen touch button for mobile.
    ContextActionService:BindAction(ACTION, onAction, true, Enum.KeyCode.E, Enum.KeyCode.ButtonR2)
    ContextActionService:SetTitle(ACTION, "Action")
end

return InputController
