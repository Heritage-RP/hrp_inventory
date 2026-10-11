-- Héritage RP checks (PRODUCTION-SERVER#400: « Impossible de fouiller les poubelles »). Run from the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/dumpsters_spec.lua

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

local function read(path)
    local file = assert(io.open(path))
    local text = file:read('a')
    file:close()
    return text
end

local chunk, err = loadfile('modules/dumpsters/shared.lua')
check('modules/dumpsters/shared.lua compiles' .. (err and (': ' .. err) or ''), chunk ~= nil)
local Dumpsters = chunk and chunk() or {}

-- Model list: the hashes are computed from the names (same algorithm as GetHashKey)
local upstream = { 218085040, 666561306, -58485588, -206690185, 1511880420, 682791951 }
for _, hash in ipairs(upstream) do
    check('upstream dumpster ' .. hash .. ' is still searchable', Dumpsters.isDumpster(hash))
end
check('joaat matches GetHashKey (prop_dumpster_02b = -58485588)', Dumpsters.joaat('prop_dumpster_02b') == -58485588)
check('joaat ignores case', Dumpsters.joaat('PROP_DUMPSTER_01A') == 218085040)

for _, name in ipairs({ 'prop_bin_01a', 'prop_bin_05a', 'prop_bin_07b', 'prop_bin_08open', 'prop_bin_14b', 'prop_cs_bin_01',
    'prop_recyclebin_03_a', 'prop_bin_beach_01a', 'prop_skip_01a' }) do
    check(name .. ' (street bin) is searchable', Dumpsters.isDumpster(Dumpsters.joaat(name)))
    check(name .. ' is named back', Dumpsters.name(Dumpsters.joaat(name)) == name)
end
check('an unsigned model hash is recognised too', Dumpsters.isDumpster(-58485588 & 0xFFFFFFFF))
check('a car is not a bin', not Dumpsters.isDumpster(Dumpsters.joaat('adder')))
check('garbage input is not a bin', not Dumpsters.isDumpster(nil) and not Dumpsters.isDumpster('x') and not Dumpsters.isDumpster({}))
check('the hash list matches the name list', #Dumpsters.hashes == #Dumpsters.MODELS)

local seen, duplicate = {}, false
for _, hash in ipairs(Dumpsters.hashes) do
    if seen[hash] then duplicate = true end
    seen[hash] = true
end
check('no model is listed twice', not duplicate)

-- Key: rounded coordinates, so every client finds the same inventory for one bin
check('key of the reported bin (-359.2, -641.9, 31.7)', Dumpsters.key(-359.2, -641.9, 31.7) == 'dumpster:-359:-642:32')
check('float noise keeps the key', Dumpsters.key(-359.24, -641.88, 31.71) == Dumpsters.key(-359.2, -641.9, 31.7))
check('two bins 2 m apart get two keys', Dumpsters.key(10, 10, 30) ~= Dumpsters.key(12, 10, 30))

-- Payload sent by the client: { coords = vector3, model = hash } (a vector3 is a table here)
local x, y, z, model = Dumpsters.parse({ coords = { x = -359.2, y = -641.9, z = 31.7 }, model = 218085040 })
check('client payload parsed', x == -359.2 and y == -641.9 and z == 31.7 and model == 218085040)
x, y, z, model = Dumpsters.parse({ x = 1.0, y = 2.0, z = 3.0 })
check('bare vector3 parsed (networkdumpsters / other resources)', x == 1.0 and y == 2.0 and z == 3.0 and model == nil)
x, y, z, model = Dumpsters.parse({ coords = { x = 1.0, y = 2.0, z = 3.0 }, model = Dumpsters.joaat('adder') })
check('a model that is not a bin is dropped, not trusted', x == 1.0 and model == nil)
check('netId 0 key is not a coords payload', Dumpsters.parse('dumpster0') == nil)
check('nil rejected', Dumpsters.parse(nil) == nil)
check('number rejected', Dumpsters.parse(12) == nil)
check('missing coordinate rejected', Dumpsters.parse({ coords = { x = 1.0, y = 2.0 } }) == nil)
check('string coordinate rejected', Dumpsters.parse({ x = '1', y = 2.0, z = 3.0 }) == nil)
check('NaN rejected', Dumpsters.parse({ x = 0 / 0, y = 2.0, z = 3.0 }) == nil)
check('infinity rejected', Dumpsters.parse({ x = math.huge, y = 2.0, z = 3.0 }) == nil)
check('outside the map rejected', Dumpsters.parse({ x = 1e6, y = 2.0, z = 3.0 }) == nil)
check('non-vector coords rejected', Dumpsters.parse({ coords = 'here' }) == nil)

-- One new bin per player every CREATE_COOLDOWN_MS
check('first bin allowed', Dumpsters.canCreate(nil, 1000))
check('second bin right after refused', not Dumpsters.canCreate(1000, 1000 + Dumpsters.CREATE_COOLDOWN_MS - 1))
check('second bin after the cooldown allowed', Dumpsters.canCreate(1000, 1000 + Dumpsters.CREATE_COOLDOWN_MS))

-- Wiring (regressions of #400)
local client = read('modules/inventory/client.lua')
local openDumpster = client:match('function Inventory%.OpenDumpster%(entity%)(.-)\nend\n') or ''
check('client OpenDumpster found', openDumpster ~= '')
check('client no longer opens by network id (netId 0 on map props)', not openDumpster:find('NetworkGetNetworkIdFromEntity', 1, true))
check('client sends coords and model', client:find("client.openInventory('dumpster', { coords = GetEntityCoords(entity), model = GetEntityModel(entity) })", 1, true) ~= nil)
check('ox_target lists the shared models', client:find('Dumpsters.hashes', 1, true) ~= nil)
local server = read('server.lua')
local dumpsterBranch = server:find("elseif invType == 'dumpster' then", 1, true)
local tableBranch = server:find('elseif isDataTable then', 1, true)
check('server routes dumpsters before the table branch (else the table payload is dropped)',
    dumpsterBranch and tableBranch and dumpsterBranch < tableBranch)
check('server logs searches and failures', server:find("HrpLog.business.info('dumpster searched'", 1, true) ~= nil
    and server:find("'dumpster search failed'", 1, true) ~= nil)
check('fxmanifest loads HrpLog on the server', read('fxmanifest.lua'):find("'@hrp-metrics/lib/log.lua'", 1, true) ~= nil)
check('fxmanifest ships modules/**/shared.lua to clients', read('fxmanifest.lua'):find("'modules/**/shared.lua'", 1, true) ~= nil)
for _, lang in ipairs({ 'en', 'fr' }) do
    check(lang .. ' locale has dumpster_cooldown', read('locales/' .. lang .. '.json'):find('"dumpster_cooldown"', 1, true) ~= nil)
end

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
