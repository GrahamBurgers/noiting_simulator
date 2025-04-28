local me = GetUpdatedEntityID()
local c = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and vel) then return end
if c <= ComponentGetValue2(proj, "collide_with_shooter_frames") then
    return -- things work weird when hitting too soon
elseif c == ComponentGetValue2(proj, "collide_with_shooter_frames") + 1 then
    ComponentSetValue2(proj, "lifetime", ComponentObjectGetValue2(proj, "damage_by_type", "healing") * 25)
    ComponentSetValue2(proj, "mStartingLifetime", ComponentGetValue2(proj, "lifetime"))
    ComponentObjectSetValue2(proj, "damage_by_type", "healing", 0)
    ComponentObjectSetValue2(proj, "damage_by_type", "holy", 0)
    ComponentObjectSetValue2(proj, "damage_by_type", "curse", 0)

    EntitySetComponentsWithTagEnabled(me, "proj_enable", true)
    EntitySetComponentsWithTagEnabled(me, "proj_disable", false)
    ComponentSetValue2(vel, "updates_velocity", true)
    EntityAddTag(me, "projectile")
    EntityAddTag(me, "hittable")
elseif c == ComponentGetValue2(proj, "collide_with_shooter_frames") + 2 then
    ComponentSetValue2(proj, "collide_with_world", true)
end

if EntityHasTag(me, "nohit") then return end
-- COLLISION DETECTION
local whoshot = ComponentGetValue2(proj, "mWhoShot")
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local px, py = EntityGetTransform(me)
local hittable = EntityGetInRadiusWithTag(px, py, 64, "hittable")
for i = 1, #hittable do
    local hitbox = EntityGetFirstComponent(hittable[i], "HitboxComponent")
    local vel2 = EntityGetFirstComponent(hittable[i], "VelocityComponent")
    if hitbox and vel2 and whoshot ~= hittable[i] and me ~= hittable[i] then
        local x, y = EntityGetTransform(hittable[i])
        local x1, x2, y1, y2 = ComponentGetValue2(hitbox, "aabb_min_x"), ComponentGetValue2(hitbox, "aabb_max_x"), ComponentGetValue2(hitbox, "aabb_min_y"), ComponentGetValue2(hitbox, "aabb_max_y")
        if (px >= x + x1 and px <= x + x2 and py >= y + y1 and py <= y + y2) then
            EntityAddTag(me, "has_hit")
            if ComponentGetValue2(proj, "play_damage_sounds") then
                local multiplier = ComponentGetValue2(proj, "damage_scale_max_speed")
                -- deal knockback
                local knockback = (ComponentGetValue2(vel, "mass") / ComponentGetValue2(vel2, "mass")) * ComponentGetValue2(proj, "knockback_force") * multiplier
                if knockback ~= 0 then
                    local vx2, vy2 = ComponentGetValue2(vel2, "mVelocity")
                    vx2 = vx2 + (vx * knockback)
                    vy2 = vy2 + (vy * knockback)
                    ComponentSetValue2(vel2, "mVelocity", vx2, vy2)
                end

                -- deal damage
                dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
                Damage(proj, hittable[i], multiplier, px, py, whoshot)
            end

            -- kill projectile
            if ComponentGetValue2(proj, "on_collision_die") then
                EntityAddTag(me, "nohit")
                EntityKill(me)
                break
            end
        end
    end
end