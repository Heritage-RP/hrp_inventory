-- Héritage RP — searchable bins and dumpsters (PRODUCTION-SERVER#400). Pure Lua (no natives): loaded by the client
-- (ox_target models, keybind) and the server (inventory key, checks), tested by tests/lua/dumpsters_spec.lua.
--
-- Players call every bin « poubelle »: upstream only listed the 6 big dumpsters. And map props are not networked, so
-- the upstream `'dumpster' .. netId` key was `dumpster0` and the server refused it without a word: a bin is now keyed
-- by its rounded coordinates (what `inventory:networkdumpsters` did, without its linear scan).

local Dumpsters = {}

-- Models searchable with « Fouiller la poubelle ». A name GTA does not know only yields a hash no entity has.
Dumpsters.MODELS = {
    -- big dumpsters (upstream ox_inventory list: 218085040, 666561306, -58485588, -206690185, 1511880420, 682791951)
    'prop_dumpster_01a', 'prop_dumpster_02a', 'prop_dumpster_02b', 'prop_dumpster_3a', 'prop_dumpster_4a',
    'prop_dumpster_4b', 'prop_cs_dumpster_01a', 'p_dumpster_t', 'prop_snow_dumpster_01',
    -- street and park bins
    'prop_bin_01a', 'prop_bin_02a', 'prop_bin_03a', 'prop_bin_04a', 'prop_bin_05a', 'prop_bin_06a', 'prop_bin_07a',
    'prop_bin_07b', 'prop_bin_07c', 'prop_bin_07d', 'prop_bin_08a', 'prop_bin_08open', 'prop_bin_09a', 'prop_bin_10a',
    'prop_bin_10b', 'prop_bin_11a', 'prop_bin_11b', 'prop_bin_12a', 'prop_bin_13a', 'prop_bin_14a', 'prop_bin_14b',
    'prop_bin_beach_01a', 'prop_bin_beach_01d', 'prop_bin_delpiero', 'prop_bin_delpiero_b',
    'prop_cs_bin_01', 'prop_cs_bin_01_skinned', 'prop_cs_bin_02', 'prop_cs_bin_03',
    -- recycling bins
    'prop_recyclebin_01a', 'prop_recyclebin_02a', 'prop_recyclebin_02b', 'prop_recyclebin_02_c', 'prop_recyclebin_02_d',
    'prop_recyclebin_03_a', 'prop_recyclebin_04_a', 'prop_recyclebin_04_b', 'prop_recyclebin_05_a',
    -- construction skips
    'prop_skip_01a', 'prop_skip_02a', 'prop_skip_03', 'prop_skip_04', 'prop_skip_05a', 'prop_skip_05b', 'prop_skip_06a',
    'prop_skip_08a', 'prop_skip_08b', 'prop_skip_10a',
}

-- Farthest a player may stand from the bin's origin (ox_target reaches 2 m from the hit point; a big dumpster is ~2 m wide).
Dumpsters.MAX_DISTANCE = 4.0
-- Time between two bins searched for the first time by one player: coordinates come from the client (map props are
-- unknown to the server), so a modified client could otherwise make up a fresh bin — fresh loot — at every call.
Dumpsters.CREATE_COOLDOWN_MS = 2000
-- Beyond any GTA map (Cayo Perico included): rejects absurd coordinates before they become an inventory id.
local WORLD_LIMIT = 10000.0

---@param hash integer
---@return integer hash as a signed 32-bit integer, as GetEntityModel and CfxLua backtick hashes return it
function Dumpsters.signed(hash)
    hash = hash & 0xFFFFFFFF
    return hash >= 0x80000000 and hash - 0x100000000 or hash
end

---Jenkins one-at-a-time, the GTA model hash (same value as GetHashKey / `name`), lower-cased.
---@param name string
---@return integer
function Dumpsters.joaat(name)
    local hash = 0

    for i = 1, #name do
        hash = (hash + name:lower():byte(i)) & 0xFFFFFFFF
        hash = (hash + (hash << 10)) & 0xFFFFFFFF
        hash = hash ~ (hash >> 6)
    end

    hash = (hash + (hash << 3)) & 0xFFFFFFFF
    hash = hash ~ (hash >> 11)
    hash = (hash + (hash << 15)) & 0xFFFFFFFF

    return Dumpsters.signed(hash)
end

---@type integer[]
Dumpsters.hashes = {}
local names = {}

for i = 1, #Dumpsters.MODELS do
    local hash = Dumpsters.joaat(Dumpsters.MODELS[i])
    Dumpsters.hashes[i] = hash
    names[hash] = Dumpsters.MODELS[i]
end

---@param model any entity model hash
---@return string? name of the searchable model, nil when it is not one
function Dumpsters.name(model)
    model = math.tointeger(tonumber(model))
    return model and names[Dumpsters.signed(model)]
end

---@param model any entity model hash
---@return boolean
function Dumpsters.isDumpster(model)
    return Dumpsters.name(model) ~= nil
end

---@param value any
---@return number?
local function coordinate(value)
    -- NaN fails both comparisons, ±inf the bound
    if type(value) == 'number' and value >= -WORLD_LIMIT and value <= WORLD_LIMIT then return value end
end

---Reads the open payload: `{ coords = vector3, model = hash }` from the client, or a bare vector3 (upstream
---`inventory:networkdumpsters` call, other resources).
---@param data any
---@return number? x, number? y, number? z, integer? model hash when it is a searchable model
function Dumpsters.parse(data)
    local coords, model = data, nil
    local kind = type(data)

    -- a CfxLua vector3 is not a table: never index it with `.coords`
    if kind == 'table' and data.coords ~= nil then
        coords = data.coords
        model = Dumpsters.isDumpster(data.model) and Dumpsters.signed(math.tointeger(tonumber(data.model))) or nil
    elseif kind ~= 'table' and kind ~= 'vector3' then
        return
    end

    kind = type(coords)
    if kind ~= 'table' and kind ~= 'vector3' then return end

    local x, y, z = coordinate(coords.x), coordinate(coords.y), coordinate(coords.z)
    if not (x and y and z) then return end

    return x, y, z, model
end

---Inventory id of the bin at these coordinates: same bin → same id on every client (to the metre).
---@param x number
---@param y number
---@param z number
---@return string
function Dumpsters.key(x, y, z)
    return ('dumpster:%d:%d:%d'):format(math.floor(x + 0.5), math.floor(y + 0.5), math.floor(z + 0.5))
end

---@param last number? GetGameTimer() of the player's last new bin
---@param now number
---@return boolean
function Dumpsters.canCreate(last, now)
    return last == nil or now - last >= Dumpsters.CREATE_COOLDOWN_MS
end

return Dumpsters
