local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
SetRandomSeed(me + GameGetFrameNum() + x, y + 130450)

local size = 4
if not (RaytracePlatforms(x - size, y - size, x + size, y + size) or RaytracePlatforms(x + size, y - size, x - size, y + size)) then return end
local adder = tonumber(GlobalsGetValue("SPELL_CARVER_COUNT", "0")) or 0
local chance = math.max(1, 500 - adder)
if Random(1, chance) > 1 then
	GlobalsSetValue("SPELL_CARVER_COUNT", tostring(adder + 10))
	return
end
GlobalsSetValue("SPELL_CARVER_COUNT", "0")
-- draw an X, see if wall
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
EntityLoad("mods/noiting_simulator/files/spells/carver_touch.xml", x, y)
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
Shoot({file = "mods/noiting_simulator/files/spells/carver_bullet.xml", whoshot = owner, target = "HEART"})