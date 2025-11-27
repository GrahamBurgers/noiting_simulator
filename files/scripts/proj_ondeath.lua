local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local px, py = x, y
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and vel) then return end
local function touchinghitbox(circle_size, target_entity)
    local ex, ey = EntityGetTransform(target_entity)
    local distance = math.sqrt((ex - x)^2 + (ey - y)^2)
    local direction = math.pi - math.atan2((ey - y), (ex - x))
    local circle_hitbox = EntityGetFirstComponent(target_entity, "VariableStorageComponent", "hitbox")
    if circle_hitbox then
        circle_size = circle_size * (1 / 1.5) -- DANGEROUS!!!
        local rx = px + -math.cos(direction) * circle_size
        local ry = py + math.sin(direction) * circle_size
        local size = ComponentGetValue2(circle_hitbox, "value_float")
        return distance <= circle_size + size and not RaytracePlatforms(px, py, rx, ry)
    end
    local rectangle_hitbox = EntityGetFirstComponent(target_entity, "HitboxComponent")
    if rectangle_hitbox then
        local min_x = x + ComponentGetValue2(rectangle_hitbox, "aabb_min_x")
        local max_x = x + ComponentGetValue2(rectangle_hitbox, "aabb_max_x")
        local min_y = y + ComponentGetValue2(rectangle_hitbox, "aabb_min_y")
        local max_y = y + ComponentGetValue2(rectangle_hitbox, "aabb_max_y")
        local magnitude = math.min(circle_size, distance)
        local rx = px + -math.cos(direction) * magnitude
        local ry = py + math.sin(direction) * magnitude
        return (rx >= min_x and rx <= max_x and ry >= min_y and ry <= max_y) and not RaytracePlatforms(px, py, rx, ry)
    end
end

local do_explosion = ComponentObjectGetValue2(proj, "config_explosion", "physics_throw_enabled")
local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
local whoshot = ComponentGetValue2(proj, "mWhoShot")
local radius = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
local search_radius = 128
local heart = EntityGetInRadiusWithTag(x, y, search_radius, "hittable") or {}
for i = 1, #heart do
    if EntityGetRootEntity(heart[i]) == heart[i] and do_explosion and touchinghitbox(radius, heart[i]) then
        local x2, y2 = EntityGetTransform(heart[i])
        local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
        local multiplier = math.min(1, 2 * (1 - (distance / radius)))
        print("multiplier: " .. tostring(multiplier))
        multiplier = multiplier * q.get_mult_explosion(me)
        if (heart[i] ~= ComponentGetValue2(proj, "mWhoShot")) or (ComponentGetValue2(proj, "explosion_dont_damage_shooter") == false) then
            dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
            ProjHit(me, proj, heart[i], multiplier, x, y, whoshot)
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
                local mult = 0.5
                ComponentObjectSetValue2(proj2, "damage_by_type", "melee", ComponentObjectGetValue2(proj2, "damage_by_type", "melee") + ComponentObjectGetValue2(proj, "damage_by_type", "melee") * mult)
                ComponentObjectSetValue2(proj2, "damage_by_type", "slice", ComponentObjectGetValue2(proj2, "damage_by_type", "slice") + ComponentObjectGetValue2(proj, "damage_by_type", "slice") * mult)
                ComponentObjectSetValue2(proj2, "damage_by_type", "fire", ComponentObjectGetValue2(proj2, "damage_by_type", "fire") + ComponentObjectGetValue2(proj, "damage_by_type", "fire") * mult)
                ComponentObjectSetValue2(proj2, "damage_by_type", "ice", ComponentObjectGetValue2(proj2, "damage_by_type", "ice") + ComponentObjectGetValue2(proj, "damage_by_type", "ice") * mult)
            end
        end
    end
end

if proj and not EntityHasTag(me, "comedic_nohurt") then
    local dmg_comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice") * q.get_mult_collision(me)
    local dmg = EntityGetFirstComponent(whoshot, "DamageModelComponent")
    if whoshot and whoshot > 0 and dmg_comedic > 0 and dmg then
        EntityInflictDamage(whoshot, math.min(dmg_comedic, ComponentGetValue2(dmg, "hp") - 0.04), "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NONE", 0, 0, whoshot)
    end
end