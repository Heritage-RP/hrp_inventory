-- Héritage RP checks (PRODUCTION-SERVER#208). Run from the resource folder:
--   docker run --rm -v "$PWD":/w -w /w nickblah/lua:5.4 lua tests/lua/weapon_state_spec.lua

local failures = 0
local function check(name, cond)
    if cond then io.write('ok   ', name, '\n') else failures = failures + 1; io.write('FAIL ', name, '\n') end
end

local WeaponState = dofile('modules/weapon/shared.lua')
local RIFLE, UNARMED = 0x83BF0278, 0xA2719263
local equipped = function(timer) return { name = 'WEAPON_CARBINERIFLE', hash = RIFLE, timer = timer } end

-- 1. A weapon really in hand blocks items (ox_inventory's own rule)
check('no weapon: nothing to clear', WeaponState.isPhantom(nil, UNARMED, 0) == false)
check('weapon in hand is real', WeaponState.isPhantom(equipped(0), RIFLE, 1) == false)
check('weapon in hand mid-shot is real', WeaponState.isPhantom(equipped(123456), RIFLE, 1) == false)
check('weapon swapped mid-shot is kept (the tick handles it)', WeaponState.isPhantom(equipped(123456), UNARMED, 1) == false)

-- 2. Leftovers that refused every item with "cannot_perform" and no weapon in hand
check('disarmed but never cleared (timer nil) is a leftover', WeaponState.isPhantom(equipped(nil), RIFLE, 1) == true)
check('weapon item no longer in the inventory is a leftover', WeaponState.isPhantom(equipped(0), RIFLE, 0) == true)
check('weapon no longer in the hands is a leftover', WeaponState.isPhantom(equipped(0), UNARMED, 1) == true)
check('unknown count does not decide alone', WeaponState.isPhantom(equipped(0), RIFLE, nil) == false)

-- 3. client.lua wiring: clearWeapons clears currentWeapon, both refusal paths clear a leftover first
do
    local f = assert(io.open('client.lua', 'r'))
    local client = f:read('a')
    f:close()
    check('clearWeapons resets currentWeapon',
        client:find("RegisterNetEvent%('ox_inventory:clearWeapons', function%(%)%s+Weapon.ClearAll%(currentWeapon%).-currentWeapon = nil%s+end%)") ~= nil)
    local useItem = client:match('local function useItem%(data, cb, noAnim%)(.-)\nend\n')
    check('useItem clears a leftover before refusing',
        useItem and useItem:find('dropPhantomWeapon%(%)') and useItem:find('dropPhantomWeapon%(%)') < useItem:find('cannot_perform'))
    local useSlot = client:match('local function useSlot%(slot, noAnim%)(.-)\nend\n')
    check('useSlot clears a leftover before choosing the armed branch',
        useSlot and useSlot:find('dropPhantomWeapon%(%)') and useSlot:find('dropPhantomWeapon%(%)') < useSlot:find('elseif currentWeapon then'))
end

-- 4. Items used without an ox_inventory animation while a weapon may be in hand
do
    -- CfxLua compile-time hashes (`name`) are not Lua 5.4: replaced by a number to load the table
    local f = assert(io.open('data/items.lua', 'r'))
    local source = f:read('a'):gsub('`[^`\n]*`', '0')
    f:close()
    _G.vec3 = function(x, y, z) return { x = x, y = y, z = z } end
    local items = assert(load(source, '=data/items.lua'))()
    for _, name in ipairs({ 'blank_sheet', 'blank_book', 'lore_document', 'animal_bait' }) do
        check(name .. ' has allowArmed', items[name] and items[name].allowArmed == true)
    end
end

if failures > 0 then
    io.write(failures, ' failure(s)\n')
    os.exit(1)
end
io.write('all passed\n')
