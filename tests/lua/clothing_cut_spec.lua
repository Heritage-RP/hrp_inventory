-- Héritage RP checks (PRODUCTION-SERVER#43, refinement R11). Run from the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/clothing_cut_spec.lua

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

local cut = {}
function vec3(x, y, z) return { x = x, y = y, z = z } end -- FXServer global used by a few items
exports = setmetatable({}, {
    __index = function(_, resource)
        return { cutClothing = function(_, slot) cut[#cut + 1] = { resource = resource, slot = slot } end }
    end,
})

-- CfxLua backtick hashes (`WEAPON_PISTOL`) are not plain Lua: read them as strings
local file = assert(io.open('data/items.lua'))
local source = file:read('a'):gsub('`([^`]*)`', '"%1"')
file:close()
local chunk, err = load(source, '@data/items.lua')
check('data/items.lua compiles' .. (err and (': ' .. err) or ''), chunk ~= nil)
local ok, items = pcall(chunk or function() end)
check('data/items.lua returns a table', ok and type(items) == 'table')
items = type(items) == 'table' and items or {}

local clothes = 0
for name, item in pairs(items) do
    if item.server and item.server.export == 'hrp-item-clothes.useClothingItem' then
        clothes = clothes + 1
        local button = item.buttons and item.buttons[1]
        check(name .. ' has a « Découper » button', button and button.label == 'Découper' and type(button.action) == 'function')
        if button and type(button.action) == 'function' then
            cut = {}
            button.action(7)
            check(name .. ' cuts through hrp-item-clothes with its slot',
                #cut == 1 and cut[1].resource == 'hrp-item-clothes' and cut[1].slot == 7)
        end
    end
end
check('the 14 clothing items are covered', clothes == 14)

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
