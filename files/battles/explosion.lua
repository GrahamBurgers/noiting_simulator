local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and vel) then return end
local radius = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
local heart = EntityGetInRadiusWithTag(x, y, radius, "hittable")
local whoshot = ComponentGetValue2(proj, "mWhoShot")
for i = 1, #heart do
    if EntityGetRootEntity(heart[i]) == heart[i] then
        local x2, y2 = EntityGetTransform(heart[i])
        local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
        local multiplier = math.min(1, 2 * (1 - (distance / radius))) + (ComponentGetValue2(proj, "damage_scale_max_speed") - 1)
        if (heart[i] ~= whoshot) or (ComponentGetValue2(proj, "explosion_dont_damage_shooter") == false) then
            dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
            Damage(me, proj, heart[i], multiplier, x, y, whoshot)
        end

        local vel2 = EntityGetFirstComponentIncludingDisabled(heart[i], "VelocityComponent")
        local cdc = EntityGetFirstComponentIncludingDisabled(heart[i], "CharacterDataComponent")
        local isproj = EntityHasTag(heart[i], "projectile")
        local proj2 = EntityGetFirstComponentIncludingDisabled(heart[i], "ProjectileComponent")
        vel2 = cdc or vel2
        if vel2 then
            local direction = math.pi - math.atan2((y2 - y), (x2 - x))
            local knockback = (ComponentGetValue2(vel2, "mass") / ComponentGetValue2(vel, "mass")) * ComponentGetValue2(proj, "knockback_force") * multiplier * 0.5
            local vx, vy = ComponentGetValue2(vel2, "mVelocity")
            vx = vx + knockback * -math.cos(direction) * (cdc and 3 or 1) * (isproj and 50 or 1)
            vy = vy + knockback * math.sin(direction) * (cdc and 2 or 1) * (isproj and 50 or 1)

            ComponentSetValue2(vel2, "mVelocity", vx, vy)

            if isproj and proj2 then
                -- add explosion's damage to boosted projectiles
                ComponentObjectSetValue2(proj2, "damage_by_type", "melee", ComponentObjectGetValue2(proj2, "damage_by_type", "melee") + ComponentObjectGetValue2(proj, "damage_by_type", "melee"))
                ComponentObjectSetValue2(proj2, "damage_by_type", "slice", ComponentObjectGetValue2(proj2, "damage_by_type", "slice") + ComponentObjectGetValue2(proj, "damage_by_type", "slice"))
                ComponentObjectSetValue2(proj2, "damage_by_type", "fire", ComponentObjectGetValue2(proj2, "damage_by_type", "fire") + ComponentObjectGetValue2(proj, "damage_by_type", "fire"))
                ComponentObjectSetValue2(proj2, "damage_by_type", "ice", ComponentObjectGetValue2(proj2, "damage_by_type", "ice") + ComponentObjectGetValue2(proj, "damage_by_type", "ice"))
            end
        end
    end
end