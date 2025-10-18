local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end
local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
local total = tonumber(ComponentGetValue2(GetUpdatedComponentID(), "script_polymorphing_to")) or 0
if current ~= last then
    ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", current)
    if current < last and total < 2 then
        ComponentSetValue2(GetUpdatedComponentID(), "script_polymorphing_to", tostring(total + 1))
        local x, y = EntityGetTransform(me)
        dofile_once("data/scripts/lib/utilities.lua")
        SetRandomSeed(me + proj + GetUpdatedComponentID(), current + GameGetFrameNum())

        local how_many = Random(8, 16)
        local angle_inc = (2 * math.pi) / how_many
        local theta = Random(math.pi * -100, math.pi * 100) / 100

        for q = 1, how_many do
            local speed = Random(20, 200)
            local add = Random(-410, 410) / 100
            local vel_x = math.cos(theta + add) * speed
            local vel_y = math.sin(theta + add) * speed
            theta = theta + angle_inc
            shoot_projectile_from_projectile(me, "mods/noiting_simulator/files/spells/sparkle.xml", x + vel_x / 120, y + vel_y / 120, vel_x, vel_y)
        end
    end
end