--!strict
-- Example unit test for pure logic (runs headless via Lune in CI — no Studio needed).
-- Pattern: test the pure helpers in shared/util. DataModel-dependent code is covered by playtest.
--
-- This uses a tiny assert-based harness so it runs under `lune run tests` without extra deps.
-- Swap for TestEZ/Jest-Lua if a game prefers a full framework (record in the decision log).

local Guard = require("../src/shared/util/Guard")

local passed, failed = 0, 0
local function check(name: string, cond: boolean)
    if cond then
        passed += 1
    else
        failed += 1
        print(`  FAIL: {name}`)
    end
end

check("isNumber accepts 1", Guard.isNumber(1))
check("isNumber rejects string", not Guard.isNumber("1"))
check("isNumber rejects NaN", not Guard.isNumber(0 / 0))
check("isFiniteNumber rejects inf", not Guard.isFiniteNumber(math.huge))
check("isString accepts text", Guard.isString("hi"))
check("inRange within bounds", Guard.inRange(5, 0, 10))
check("inRange rejects out of bounds", not Guard.inRange(11, 0, 10))

print(`Guard.spec: {passed} passed, {failed} failed`)
if failed > 0 then
    error("tests failed")
end
