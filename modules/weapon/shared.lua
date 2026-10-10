-- Héritage RP (PRODUCTION-SERVER#208): pure rules about the weapon ox_inventory believes equipped, tested in
-- tests/lua/weapon_state_spec.lua. No natives here.

local WeaponState = {}

--- Whether `weapon` (client.lua's currentWeapon) is only a leftover: every item the player uses while it is set is
--- refused with "cannot_perform" unless it has allowArmed, so a leftover blocks items with no weapon in hand.
--- @param weapon table|nil currentWeapon
--- @param selectedHash number|nil GetSelectedPedWeapon of the player's ped
--- @param count number|nil how many of that weapon item the inventory still holds
--- @return boolean
function WeaponState.isPhantom(weapon, selectedHash, count)
    if not weapon then return false end
    -- Weapon.Disarm clears the timer: a currentWeapon without one was disarmed but never cleared
    if weapon.timer == nil then return true end
    -- The weapon item left the inventory
    if count ~= nil and count < 1 then return true end
    -- Not in the ped's hands any more, and not in the middle of a shot (timer > 0 while firing / meleeing)
    return selectedHash ~= nil and selectedHash ~= weapon.hash and weapon.timer == 0
end

return WeaponState
