-- Every item of the inventory shows an image (PRODUCTION-SERVER#242). Run from the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/item_images_spec.lua
-- An item shows client.image, or web/images/<name>.png without one (modules/items/shared.lua): that file must exist.

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

function vec3(x, y, z) return { x = x, y = y, z = z } end -- FXServer global used by a few items
function locale(key) return 'locale:' .. key end -- ox_lib global (fxmanifest ox_libs 'locale')

local function loadData(path)
    local file = assert(io.open(path))
    local source = file:read('a'):gsub('`([^`]*)`', '"%1"')
    file:close()
    local chunk, err = load(source, '@' .. path)
    check(path .. ' compiles' .. (err and (': ' .. err) or ''), chunk ~= nil)
    local ok, data = pcall(chunk or function() end)
    check(path .. ' returns a table', ok and type(data) == 'table')
    return type(data) == 'table' and data or {}
end

local function exists(path)
    local file = io.open(path, 'rb')
    if file then file:close() end
    return file ~= nil
end

local function checkImage(name, item)
    local image = type(item.client) == 'table' and item.client.image or nil
    if image and image:match('^[%w]+://') then return end
    image = image or (name .. '.png')
    check(('%s shows web/images/%s'):format(name, image), exists('web/images/' .. image))
end

for name, item in pairs(loadData('data/items.lua')) do checkImage(name, item) end
for kind, list in pairs(loadData('data/weapons.lua')) do
    -- WEAPON_SNOWBALL is listed again as the ammo of the snowball launcher
    for name, item in pairs(list) do if kind ~= 'Tints' then checkImage(name, item) end end
end

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
