local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end
dofile_once("data/scripts/lib/utilities.lua")
SetRandomSeed(me + proj + GetUpdatedComponentID(), GameGetFrameNum())

local whoshot = proj and ComponentGetValue2(proj, "mWhoShot")
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
Shoot({file = "mods/noiting_simulator/files/spells/sparkle.xml", deg_random = 360, count = 12, deg_between = 30, speed_random_per = 20, whoshot = whoshot, comedic_multiplier = 0})