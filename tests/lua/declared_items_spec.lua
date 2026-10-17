-- Items declared by other resources (PRODUCTION-SERVER#464): modules/items/declared.lua and the base items. Run from
-- the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/declared_items_spec.lua

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

local Declared = dofile('modules/items/declared.lua')
local called = {}
local env = {
    vec3 = function(x, y, z) return { x = x, y = y, z = z } end,
    joaat = function(name) return 'hash:' .. name end,
    exports = setmetatable({}, {
        __index = function(_, resource)
            return setmetatable({}, {
                __index = function(_, fn)
                    return function(_, slot) called[#called + 1] = { resource = resource, fn = fn, slot = slot } end
                end,
            })
        end,
    }),
}

local function has(problems, text)
    for _, problem in ipairs(problems) do
        if problem:find(text, 1, true) then return true end
    end
    return false
end

-- a valid file
local items, problems = Declared.convert('hrp-demo', {
    images = 'static/items/',
    items = {
        wood = { label = 'Wood', weight = 500, close = true, satiety = { hunger = 5 }, client = { export = 'hrp-demo.useWood' } },
        mug = {
            label = 'Mug',
            client = { image = 'cup.png', prop = { model = 'prop_mug', pos = { 0.1, 0.2, 0.3 }, rot = { x = 1, y = 2, z = 3 } } },
            server = { export = 'hrp-demo.drink' },
            buttons = { { label = 'Break', export = 'hrp-demo.breakMug', group = 'misc' } },
        },
        flag = { label = 'Flag', client = { image = 'https://example.org/flag.png' } },
    },
}, env)
check('a valid file gives every item', items.wood and items.mug and items.flag and #problems == 0)
check('extra fields (satiety) are kept', items.wood.satiety.hunger == 5 and items.wood.close == true)
check('an item without image shows <images>/<name>.png of its resource', items.wood.client.image == 'nui://hrp-demo/static/items/wood.png')
check('a file name is read from the images folder', items.mug.client.image == 'nui://hrp-demo/static/items/cup.png')
check('a URL image is kept', items.flag.client.image == 'https://example.org/flag.png')
check('prop model is hashed, pos and rot become vectors',
    items.mug.client.prop.model == 'hash:prop_mug' and items.mug.client.prop.pos.y == 0.2 and items.mug.client.prop.rot.z == 3)
check('exports stay strings for newItem', items.wood.client.export == 'hrp-demo.useWood' and items.mug.server.export == 'hrp-demo.drink')
local button = items.mug.buttons[1]
button.action(7)
check('a button calls its export with the slot',
    button.label == 'Break' and button.group == 'misc' and #called == 1 and called[1].resource == 'hrp-demo'
    and called[1].fn == 'breakMug' and called[1].slot == 7)

-- without images: file names are the inventory's own images, no client table is invented
items, problems = Declared.convert('hrp-demo', { items = {
    pill = { label = 'Pill', client = { image = 'medikit.png' } },
    rock = { label = 'Rock' },
} }, env)
check('without images, a file name stays relative (web/images of the inventory)', items.pill.client.image == 'medikit.png')
check('without images, an item without client gets none', items.rock.client == nil and #problems == 0)

-- invalid files and entries
items, problems = Declared.convert('hrp-demo', { wood = { label = 'Wood' } }, env)
check('a file without "items" is refused', next(items) == nil and has(problems, 'the file must be'))
items, problems = Declared.convert('hrp-demo', 'oops', env)
check('a non-object file is refused', next(items) == nil and #problems == 1)
items, problems = Declared.convert('hrp-demo', { images = '../other', items = { a = { label = 'A' } } }, env)
check('images outside the resource are refused', next(items) == nil and has(problems, '`images`'))

items, problems = Declared.convert('hrp-demo', { items = {
    ok = { label = 'Ok' },
    nolabel = { weight = 1 },
    heavy = { label = 'Heavy', weight = -1 },
    ['Bad Name'] = { label = 'Bad' },
    badexport = { label = 'X', server = { export = 'noDot' } },
    badclientexport = { label = 'X', client = { export = 'a.b.c' } },
    badprop = { label = 'X', client = { prop = { model = 'm', pos = { 1, 2 } } } },
    badbutton = { label = 'X', buttons = { { label = 'B' } } },
    badbool = { label = 'X', stack = 'no' },
    badside = { label = 'X', server = 'x' },
} }, env)
check('valid entries of a file with bad ones still load', items.ok ~= nil)
local refused = 0
for name in pairs({ nolabel = 1, heavy = 1, ['Bad Name'] = 1, badexport = 1, badclientexport = 1, badprop = 1, badbutton = 1, badbool = 1, badside = 1 }) do
    if items[name] == nil then refused = refused + 1 end
end
check('every bad entry is left out', refused == 9)
check('each problem names the resource and the item', has(problems, 'hrp-demo: item "nolabel": `label` is required')
    and has(problems, '"heavy": `weight`') and has(problems, '"Bad Name" is not an item name')
    and has(problems, '"badexport": `server.export`') and has(problems, '"badclientexport": `client.export`')
    and has(problems, '"badprop": `client.prop`: `pos`') and has(problems, '"badbutton": `buttons`[1]: `export`')
    and has(problems, '"badbool": `stack`') and has(problems, '"badside": `server`'))

-- claims: base items and other resources' items are never replaced, a restart replaces its own
local owners = { wood = 'hrp-demo' }
check('a new item can be claimed', Declared.claim(owners, false, 'hrp-demo', 'mug'))
check('a resource replaces its own item (restart)', Declared.claim(owners, true, 'hrp-demo', 'wood'))
local allowed, reason = Declared.claim(owners, true, 'hrp-other', 'wood')
check('another resource cannot take it', not allowed and reason:find('already declared by hrp-demo', 1, true))
allowed, reason = Declared.claim(owners, true, 'hrp-other', 'water')
check('a base item cannot be redefined', not allowed and reason:find('base item', 1, true))

-- the base items: no export or button of data/items.lua names a resource outside this short list of core resources
local CORE = { ['hrp-item-clothes'] = true, ['hrp-lore'] = true }
local file = assert(io.open('data/items.lua'))
local source = file:read('a'):gsub('`([^`]*)`', '"%1"')
file:close()
local named = {}
for resource in source:gmatch("export = '([^%.']+)%.") do named[resource] = true end
for resource in source:gmatch("exports%['([^']+)'%]") do named[resource] = true end
for resource in source:gmatch("[^%w_]hrp%-[%w%-]+") do named[resource:sub(2)] = true end
local outside = {}
for resource in pairs(named) do
    if not CORE[resource] and resource ~= 'hrp-life-and-death' then outside[#outside + 1] = resource end
end
table.sort(outside)
check('data/items.lua names core resources only' .. (#outside > 0 and (': ' .. table.concat(outside, ', ')) or ''), #outside == 0)

local manifest = assert(io.open('fxmanifest.lua')):read('a')
check('the client can read declared.lua (fxmanifest files)', manifest:find("'modules/items/declared.lua'", 1, true) ~= nil)

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
io.write('all declared items checks passed\n')
