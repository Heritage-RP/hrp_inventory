--[[
Items declared by other resources (Heritage-RP, PRODUCTION-SERVER#464).

`data/items.lua` keeps the base items only. A resource that brings its own items lists them in a JSON file of its
own and names that file in its fxmanifest:

    hrp_inventory_items 'items.json'
    files { 'items.json', 'static/items/*.png' }   -- the client reads the file and shows the images

    {
      "images": "static/items",
      "items": {
        "wood": { "label": "Wood", "weight": 500, "client": { "export": "hrp-survival.useWood" } }
      }
    }

Each entry takes the fields of `data/items.lua` (label, weight, stack, close, consume, description, degrade,
allowArmed, client, server, any extra field such as `satiety`), with three JSON spellings:

- `client.prop` / `client.propTwo`: `model` is a model name (hashed here), `pos` and `rot` are `[x, y, z]`;
- `buttons`: `{ "label": "…", "export": "resource.function", "group"?: "…" }` calls that export with the slot;
- `client.image`: with `images`, a file name is read from that folder of the resource and an item without an image
  shows `<images>/<name>.png`; without `images`, a file name is one of the inventory's own images (`web/images`).

This file has no FiveM call: shared.lua reads the resources and hands their decoded files to `convert`.
]]

local Declared = {}

--- fxmanifest metadata naming the declaration file(s) of a resource.
Declared.METADATA = 'hrp_inventory_items'

local ITEM_NAME = '^[%w_]+$'
local EXPORT = '^([^%.]+)%.([^%.]+)$'
local BOOLEAN_FIELDS = { 'stack', 'close', 'allowArmed' }

local function hasScheme(path)
    return path:match('^[%w]+://') ~= nil
end

--- `images` must stay inside the resource: no leading slash, no `..`, no scheme.
local function validFolder(folder)
    return type(folder) == 'string' and folder ~= '' and not folder:find('^/') and not folder:find('%.%.')
        and not hasScheme(folder)
end

local function toVector(value, vec3)
    if type(value) ~= 'table' then return nil end
    local x, y, z = value[1] or value.x, value[2] or value.y, value[3] or value.z
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then return nil end
    return vec3(x, y, z)
end

local function convertProp(prop, env, where, problems)
    if prop == nil then return nil end
    if type(prop) ~= 'table' or type(prop.model) ~= 'string' or prop.model == '' then
        problems[#problems + 1] = where .. ': `model` must be a model name'
        return nil
    end
    local converted = {}
    for key, value in pairs(prop) do converted[key] = value end
    converted.model = env.joaat(prop.model)
    for _, key in ipairs({ 'pos', 'rot' }) do
        if prop[key] ~= nil then
            converted[key] = toVector(prop[key], env.vec3)
            if not converted[key] then problems[#problems + 1] = ('%s: `%s` must be [x, y, z]'):format(where, key) end
        end
    end
    return converted
end

local function checkExport(value, where, problems)
    if value == nil then return end
    if type(value) ~= 'string' or not value:match(EXPORT) then
        problems[#problems + 1] = where .. ' must be "resource.function"'
    end
end

local function convertButtons(buttons, env, where, problems)
    if buttons == nil then return nil end
    if type(buttons) ~= 'table' then
        problems[#problems + 1] = where .. ' must be a list'
        return nil
    end
    local converted = {}
    for i, button in ipairs(buttons) do
        local at = ('%s[%d]'):format(where, i)
        if type(button) ~= 'table' or type(button.label) ~= 'string' or button.label == '' then
            problems[#problems + 1] = at .. ': `label` is required'
        else
            local resource, fn = tostring(button.export or ''):match(EXPORT)
            if not resource then
                problems[#problems + 1] = at .. ': `export` must be "resource.function"'
            else
                converted[#converted + 1] = {
                    label = button.label,
                    group = button.group,
                    action = function(slot) return env.exports[resource][fn](nil, slot) end,
                }
            end
        end
    end
    return converted
end

local function imageOf(resource, folder, name, image)
    if not folder then return image end
    if image == nil then return ('nui://%s/%s/%s.png'):format(resource, folder, name) end
    if hasScheme(image) then return image end
    return ('nui://%s/%s/%s'):format(resource, folder, image)
end

local function convertItem(resource, folder, name, item, env, problems)
    local where = ('%s: item "%s"'):format(resource, name)
    local before = #problems
    if type(name) ~= 'string' or not name:match(ITEM_NAME) then
        problems[#problems + 1] = ('%s: "%s" is not an item name (letters, digits, _)'):format(resource, tostring(name))
        return nil
    end
    if type(item) ~= 'table' then
        problems[#problems + 1] = where .. ' must be an object'
        return nil
    end
    if type(item.label) ~= 'string' or item.label == '' then problems[#problems + 1] = where .. ': `label` is required' end
    if item.weight ~= nil and (type(item.weight) ~= 'number' or item.weight < 0) then
        problems[#problems + 1] = where .. ': `weight` must be a number >= 0'
    end
    if item.consume ~= nil and (type(item.consume) ~= 'number' or item.consume < 0) then
        problems[#problems + 1] = where .. ': `consume` must be a number >= 0'
    end
    for _, key in ipairs(BOOLEAN_FIELDS) do
        if item[key] ~= nil and type(item[key]) ~= 'boolean' then
            problems[#problems + 1] = ('%s: `%s` must be true or false'):format(where, key)
        end
    end
    for _, side in ipairs({ 'client', 'server' }) do
        if item[side] ~= nil and type(item[side]) ~= 'table' then
            problems[#problems + 1] = ('%s: `%s` must be an object'):format(where, side)
        end
    end

    local converted = {}
    for key, value in pairs(item) do converted[key] = value end

    local client = type(item.client) == 'table' and item.client or nil
    if client or folder then
        local side = {}
        for key, value in pairs(client or {}) do side[key] = value end
        checkExport(side.export, where .. ': `client.export`', problems)
        if side.image ~= nil and type(side.image) ~= 'string' then
            problems[#problems + 1] = where .. ': `client.image` must be a file name'
        else
            side.image = imageOf(resource, folder, name, side.image)
        end
        side.prop = convertProp(side.prop, env, where .. ': `client.prop`', problems)
        side.propTwo = convertProp(side.propTwo, env, where .. ': `client.propTwo`', problems)
        converted.client = side
    end
    if type(item.server) == 'table' then
        checkExport(item.server.export, where .. ': `server.export`', problems)
    end
    converted.buttons = convertButtons(item.buttons, env, where .. ': `buttons`', problems)

    if #problems > before then return nil end
    return converted
end

--- Items of one decoded declaration file: `items` (name → item, ready for shared.lua's newItem) and the problems of
--- the entries left out. An invalid file gives no item at all.
---@param resource string
---@param decoded any
---@param env { vec3: fun(x: number, y: number, z: number): any, joaat: fun(name: string): number, exports: table }
---@return table<string, table> items, string[] problems
function Declared.convert(resource, decoded, env)
    local items, problems = {}, {}
    if type(decoded) ~= 'table' or type(decoded.items) ~= 'table' then
        return items, { resource .. ': the file must be { "items": { "<name>": { … } } }' }
    end
    local folder = decoded.images
    if folder ~= nil and not validFolder(folder) then
        return items, { resource .. ': `images` must be a folder of the resource (e.g. "static/items")' }
    end
    if folder then folder = folder:gsub('/+$', '') end
    for name, item in pairs(decoded.items) do
        local converted = convertItem(resource, folder, name, item, env, problems)
        if converted then items[name] = converted end
    end
    return items, problems
end

--- Whether `resource` may define `name`: a base item (no owner) or another resource's item is never replaced; the
--- same resource may (its restart reloads its file).
---@param owners table<string, string> item name → declaring resource
---@param exists boolean the item is already in the item list
---@return boolean allowed, string? reason
function Declared.claim(owners, exists, resource, name)
    local owner = owners[name]
    if owner == resource then return true end
    if owner then return false, ('%s: item "%s" is already declared by %s'):format(resource, name, owner) end
    if exists then return false, ('%s: item "%s" is a base item of data/items.lua'):format(resource, name) end
    return true
end

return Declared
