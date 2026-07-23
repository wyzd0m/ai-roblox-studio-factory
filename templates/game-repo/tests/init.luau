-- Test entry point for `lune run tests` (Lune requires a directory to have an init file).
-- Discovers and runs every *.spec.luau in this directory; a spec signals failure via error().
local fs = require("@lune/fs")
local process = require("@lune/process")

local anyFailed = false

for _, entry in fs.readDir("tests") do
    local specName = entry:match("^(.+%.spec)%.luau$")
    if specName then
        print(`running {entry}`)
        -- Lune 0.8.x resolves this entry file's requires relative to the CWD (the repo
        -- root, both locally and in CI), so the path is prefixed with tests/.
        local ok, err = pcall(require, `./tests/{specName}`)
        if not ok then
            anyFailed = true
            print(`  ERROR in {entry}: {err}`)
        end
    end
end

if anyFailed then
    process.exit(1)
end
print("all specs passed")
