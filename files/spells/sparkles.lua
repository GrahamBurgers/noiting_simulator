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

        local how_many = 12
        local angle_inc = (2 * math.pi) / how_many
        local theta = Random(math.pi * -100, math.pi * 100) / 100

        for q = 1, how_many do
            local speed = Random(20, 200)
            local vel_x = math.cos(theta) * speed
            local vel_y = math.sin(theta) * speed
            theta = theta + angle_inc
            shoot_projectile_from_projectile(me, "mods/noiting_simulator/files/spells/sparkle.xml", x + vel_x / 120, y + vel_y / 120, vel_x, vel_y)
        end
    end
end