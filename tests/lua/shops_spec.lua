-- Héritage RP checks (PRODUCTION-SERVER#390). Run from the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/shops_spec.lua

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

-- data/shops.lua is plain Lua (no vec3 / backtick hashes left): it loads outside FXServer
local chunk, err = loadfile('data/shops.lua')
check('data/shops.lua compiles' .. (err and (': ' .. err) or ''), chunk ~= nil)

local ok, shops = pcall(chunk or function() end)
check('data/shops.lua returns a table', ok and type(shops) == 'table')
check('no vanilla shop is defined (hrp-counters replaces them)', type(shops) == 'table' and next(shops) == nil)

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
