local me = GetUpdatedEntityID()
local hitbox = EntityGetFirstComponentIncludingDisabled(me, "HitboxComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent")
if not (hitbox and vel and sprite) then return end

local x, y = EntityGetTransform(me)
local type = GlobalsGetValue("NS_BAR_TYPE", "CHARM")
local d = EntityGetFirstComponent(me, "DamageModelComponent")
if d and type == "CHARM" then
    local hp, max_hp = ComponentGetValue2(d, "hp") * 25, ComponentGetValue2(d, "max_hp") * 25
    GlobalsSetValue("NS_BAR_MAX", tostring(max_hp))
    GlobalsSetValue("NS_BAR_VALUE", tostring(max_hp - hp))
end

local vx, vy = ComponentGetValue2(vel, "mVelocity")

-- PROJECTILE COLLISION DETECTION
local x1, x2, y1, y2 = ComponentGetValue2(hitbox, "aabb_min_x"), ComponentGetValue2(hitbox, "aabb_max_x"), ComponentGetValue2(hitbox, "aabb_min_y"), ComponentGetValue2(hitbox, "aabb_max_y")
local projectiles = EntityGetInRadiusWithTag(x, y, math.max(x1, x2, y1, y2) * 2, "projectile")
for i = 1, #projectiles do
    local px, py = EntityGetTransform(projectiles[i])
    local proj2 = EntityGetFirstComponent(projectiles[i], "ProjectileComponent")
    local vel2 = EntityGetFirstComponent(projectiles[i], "VelocityComponent")
    if (px >= x + x1 and px <= x + x2 and py >= y + y1 and py <= y + y2) and proj2 and vel2 then
        -- take knockback
        local knockback = (ComponentGetValue2(vel2, "mass") / ComponentGetValue2(vel, "mass")) * ComponentGetValue2(proj2, "knockback_force")
        if knockback ~= 0 then
            local vx2, vy2 = ComponentGetValue2(vel2, "mVelocity")
            vx = vx + (vx2 * knockback)
            vy = vy + (vy2 * knockback)
            ComponentSetValue2(vel, "mVelocity", vx, vy)
        end
        -- take damage
        if ComponentGetValue2(proj2, "play_damage_sounds") then
            local shooter = ComponentGetValue2(proj2, "mWhoShot")
            local dmg_cute = ComponentObjectGetValue2(proj2, "damage_by_type", "fire")
            if dmg_cute > 0 then
                EntityInflictDamage(me, dmg_cute, "DAMAGE_FIRE", "$inventory_dmg_fire", "NORMAL", 0, 0, shooter)
            end
            local dmg_charming = ComponentObjectGetValue2(proj2, "damage_by_type", "slice")
            if dmg_charming > 0 then
                EntityInflictDamage(me, dmg_charming, "DAMAGE_SLICE", "$inventory_dmg_slice", "NORMAL", 0, 0, shooter)
            end
            local dmg_clever = ComponentObjectGetValue2(proj2, "damage_by_type", "drill")
            if dmg_clever > 0 then
                EntityInflictDamage(me, dmg_clever, "DAMAGE_DRILL", "$inventory_dmg_drill", "NORMAL", 0, 0, shooter)
            end
            local dmg_comedic = ComponentObjectGetValue2(proj2, "damage_by_type", "ice")
            if dmg_comedic > 0 then
                EntityInflictDamage(me, dmg_comedic, "DAMAGE_ICE", "$inventory_dmg_ice", "NORMAL", 0, 0, shooter)
            end
        end

        -- kill projectile
        if ComponentGetValue2(proj2, "on_collision_die") then
            EntityKill(projectiles[i])
        end
    end
end