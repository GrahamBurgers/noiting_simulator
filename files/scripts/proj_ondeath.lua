local comedic_hurt_factor = tonumber(GlobalsGetValue("COMEDIC_HURT_FACTOR", "0"))

local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and vel) then return end
local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
local var2 = EntityGetComponentIncludingDisabled(me, "VariableStorageComponent", "proj_cooldown") or {}

local do_explosion = ComponentObjectGetValue2(proj, "config_explosion", "physics_throw_enabled")
local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
local whoshot = ComponentGetValue2(proj, "mWhoShot")
local radius = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
local search_radius = 128
local heart = EntityGetInRadiusWithTag(x, y, search_radius, "hittable") or {}
for i = 1, #heart do
	local no_cooldown = true
    for j = 1, #var2 do
        if ComponentGetValue2(var2[j], "value_int") == heart[i] then
            no_cooldown = false
        end
    end
    if do_explosion and EntityGetHerdRelation(me, heart[i]) < 50 and touchinghitbox(radius, heart[i]) and no_cooldown then
        local x2, y2 = EntityGetTransform(heart[i])
        local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
        local multiplier = math.min(1, 2 * (1 - (distance / radius)))
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
            local knockback = (ComponentGetValue2(vel2, "mass") / ComponentGetValue2(vel, "mass")) * ComponentGetValue2(proj, "knockback_force") * multiplier * 0.33
			-- print("MASS!: " .. tostring(ComponentGetValue2(vel2, "mass")) .. " OVER " .. tostring(ComponentGetValue2(vel, "mass")))
			-- print("KB!: " .. tostring(knockback))
            local vx, vy = ComponentGetValue2(vel2, "mVelocity")
            vx = vx + knockback * -math.cos(direction) * (cdc and 3 or 1) * (isproj and 50 or 1)
            vy = vy + knockback * math.sin(direction) * (cdc and 2 or 1) * (isproj and 50 or 1)

            ComponentSetValue2(vel2, "mVelocity", vx, vy)

            if isproj and proj2 then
                -- add explosion's damage to boosted projectiles
				q.add_mult(me, "boom", 0.5, "dmg_mult_collision,dmg_mult_explosion")
            end
        end
    end
end

if not EntityHasTag(me, "comedic_nohurt") then
    local dmg_comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice") * q.get_mult_collision(me) * comedic_hurt_factor
    local dmg = EntityGetFirstComponent(whoshot, "DamageModelComponent")
    if whoshot and whoshot > 0 and dmg_comedic > 0 and dmg then
        EntityInflictDamage(whoshot, math.min(dmg_comedic, ComponentGetValue2(dmg, "hp") - 0.04), "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NONE", 0, 0, whoshot)
    end
end