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
    ComponentObjectSetValue2(proj, "damage_by_type", "healing", 0)
    ComponentSetValue2(proj, "damage", 0)

    ComponentSetValue2(proj, "ragdoll_force_multiplier", ComponentGetValue2(vel, "gravity_x"))
    ComponentSetValue2(proj, "hit_particle_force_multiplier", ComponentGetValue2(vel, "gravity_y"))
    ComponentSetValue2(vel, "gravity_x", 0)
    ComponentSetValue2(vel, "gravity_y", 0)

    local bouncy = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "last_bounces")
    if bouncy then ComponentSetValue2(bouncy, "value_int", ComponentGetValue2(proj, "bounces_left")) end

    EntitySetComponentsWithTagEnabled(me, "proj_enable", true)
    EntitySetComponentsWithTagEnabled(me, "proj_disable", false)
    ComponentSetValue2(vel, "updates_velocity", true)
    ComponentSetValue2(proj, "collide_with_world", true)
    EntityAddTag(me, "projectile")
    EntityAddTag(me, "hittable")
end

-- gravity (here to work even in walls)
local gravity_x = ComponentGetValue2(proj, "ragdoll_force_multiplier")
local gravity_y = ComponentGetValue2(proj, "hit_particle_force_multiplier")
local vx, vy = ComponentGetValue2(vel, "mVelocity")
vx = vx + gravity_x / 60
vy = vy + gravity_y / 60
ComponentSetValue2(vel, "mVelocity", vx, vy)

-- COLLISION DETECTION
if EntityHasTag(me, "nohit") then return end
local whoshot = ComponentGetValue2(proj, "mWhoShot")
local px, py = EntityGetTransform(me)
local hittable = EntityGetInRadiusWithTag(px, py, 64, "hittable")
for i = 1, #hittable do
    local hitbox = EntityGetFirstComponent(hittable[i], "VariableStorageComponent", "heart_hitbox")
    local vel2 = EntityGetFirstComponent(hittable[i], "VelocityComponent")
    if hitbox and vel2 and whoshot ~= hittable[i] and me ~= hittable[i] then
        local x, y = EntityGetTransform(hittable[i])
        local distance = math.sqrt((x - px)^2 + (y - py)^2)
        local hitboxsize = ComponentGetValue2(hitbox, "value_float")
        local hitboxboost = ComponentGetValue2(proj, "blood_count_multiplier")
        if distance <= hitboxsize + hitboxboost then
            EntityAddTag(me, "comedic_nohurt")
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
                Damage(me, proj, hittable[i], multiplier, px, py, whoshot)
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