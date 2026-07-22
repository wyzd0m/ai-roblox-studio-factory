--!strict
-- Pure input-validation helpers. No side effects, no DataModel access — unit-testable.
-- Server handlers use these to reject malformed/forged Remote payloads before acting.
local Guard = {}

function Guard.isNumber(value: unknown): boolean
    return type(value) == "number" and value == value -- rejects NaN
end

function Guard.isFiniteNumber(value: unknown): boolean
    return Guard.isNumber(value) and value ~= math.huge and value ~= -math.huge
end

function Guard.isString(value: unknown): boolean
    return type(value) == "string"
end

function Guard.inRange(value: number, min: number, max: number): boolean
    return value >= min and value <= max
end

return Guard
