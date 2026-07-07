local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")

if not proj then return end
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")

local all_of_them = EntityGetComponent(me, "LuaComponent", "shooter_shooter") or {}
if all_of_them[1] ~= this then return end

local ticks = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if ticks == 0 then return end
local divider = math.ceil((math.min(20, ComponentGetValue2(proj, "mStartingLifetime")) / #all_of_them))

if ((ticks % divider) > ((ticks + 1) % divider)) then -- USE THIS MORE OFTEN!
	Shoot({file = "mods/noiting_simulator/files/spells/shooter_bubble.xml", target = "HEART", whoshot = owner, do_muzzle_flash = true, only_if_line_of_sight = true})
	EntityAddTag(me, "ult_cute")
end