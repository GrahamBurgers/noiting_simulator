local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local sparkles = EntityGetComponent(me, "LuaComponent", "sparkles") or {}
if not proj then return end
local offset = 0
for i = 1, #sparkles do
    if sparkles[i] == GetUpdatedComponentID() then
        offset = 2 * (i - 1)
        break
    end
end
local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
local total = tonumber(ComponentGetValue2(GetUpdatedComponentID(), "script_polymorphing_to")) or 0
if current ~= last then
    ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", current)
    ComponentSetValue2(GetUpdatedComponentID(), "script_polymorphing_to", tostring(total + 1))
    if current < last and (total < 2 + offset) and total >= offset then
        local x, y = EntityGetTransform(me)
        dofile_once("data/scripts/lib/utilities.lua")
        SetRandomSeed(me + proj + GetUpdatedComponentID(), current + GameGetFrameNum())

		local whoshot = proj and ComponentGetValue2(proj, "mWhoShot")
		dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
		Shoot({file = "mods/noiting_simulator/files/spells/sparkle.xml", deg_random = 360, count = 12, deg_between = 30, speed_random_per = 20, whoshot = whoshot, comedic_multiplier = 0})
    end
end