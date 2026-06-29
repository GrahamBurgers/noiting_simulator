local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")

local owner = proj and ComponentGetValue2(proj, "mWhoShot")
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")

local ticks = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if ticks > 0 and ticks % 20 == 0 then
	Shoot({file = "mods/noiting_simulator/files/spells/shooter_bubble.xml", target = "HEART", whoshot = owner, do_muzzle_flash = true, only_if_line_of_sight = true})
	EntityAddTag(me, "ult_cute")
end