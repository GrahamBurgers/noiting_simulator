local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local x, y = EntityGetTransform(me)
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent", "base_component")
local heart = EntityGetClosestWithTag(x, y, "heart")
if not (vel and proj and sprite and heart > 0) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local sprites = EntityGetComponent(me, "SpriteComponent", "pusher_corner") or {}
local size = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame") / 1000
-- projectile logic
local max = (ComponentObjectGetValue2(proj, "damage_by_type", "melee") * 50) + 1
local projs = EntityGetInRadiusWithTag(x, y, size * math.sqrt(2), "pushable") or {}
local on = false
local lifetime = ComponentGetValue2(proj, "lifetime")
local owner = ComponentGetValue2(proj, "mWhoShot")
--[[
GameCreateParticle("spark_red",  x - size, y, 2, 0, 0, true, false, false)
GameCreateParticle("spark_blue", x + size, y, 2, 0, 0, true, false, false)
GameCreateParticle("spark_red",  x, y - size, 2, 0, 0, true, false, false)
GameCreateParticle("spark_blue", x, y + size, 2, 0, 0, true, false, false)
]]--
local damage_reducer = math.max(1, #projs * 0.9)
for i = 1, #projs do
    local proj2 = EntityGetFirstComponent(projs[i], "ProjectileComponent")
    local vel2 = EntityGetFirstComponent(projs[i], "VelocityComponent")
    local x3, y3 = EntityGetTransform(projs[i])
    if proj2 and vel2 and (x3 > x - size and x3 < x + size and y3 > y - size and y3 < y + size) and owner == ComponentGetValue2(proj2, "mWhoShot") then -- enforce square boundaries
		if i % 3 == 0 and lifetime > 2 then lifetime = lifetime - 1 end
		on = true
        local slow = 0.8
        local vx2, vy2 = ComponentGetValue2(vel2, "mVelocity")
        ComponentSetValue2(vel2, "mVelocity", vx2 * slow, vy2 * slow)
        ComponentSetValue2(proj2, "ragdoll_force_multiplier", ComponentGetValue2(proj2, "ragdoll_force_multiplier") * slow) -- gravity x
        ComponentSetValue2(proj2, "hit_particle_force_multiplier", ComponentGetValue2(proj2, "hit_particle_force_multiplier") * slow) -- gravity y
        ComponentSetValue2(vel2, "air_friction", ComponentGetValue2(vel2, "air_friction") * slow)
        ComponentSetValue2(proj2, "lifetime", ComponentGetValue2(proj2, "lifetime") + 1)
        if lifetime == 1 then
            -- LAUNCH
            EntityRemoveTag(projs[i], "pushable")
            local x2, y2 = EntityGetTransform(heart)
            local angle = (math.pi - math.atan2((y2 - y3), (x2 - x3)))
    		local distance = math.sqrt((x2 - x3)^2 + (y2 - y3)^2)
            local length = math.random(200, 400) + distance
            vx2 = vx2 * 0.2 + 0.8 * (-math.cos( angle ) * length)
            vy2 = vy2 * 0.2 + 0.8 * (math.sin( angle ) * length)

            ComponentSetValue2(vel2, "mVelocity", vx2, vy2)
            ComponentSetValue2(vel2, "air_friction", ComponentGetValue2(vel2, "air_friction") * 0.5)
            ComponentSetValue2(proj2, "lifetime", ComponentGetValue2(proj2, "lifetime") * 2.5)
            ComponentSetValue2(proj2, "knockback_force", ComponentGetValue2(proj2, "knockback_force") * 0.5)
            -- add damage
            ComponentObjectSetValue2(proj2, "damage_by_type", "melee", ComponentObjectGetValue2(proj2, "damage_by_type", "melee") + ComponentObjectGetValue2(proj, "damage_by_type", "melee") / damage_reducer)
            ComponentObjectSetValue2(proj2, "damage_by_type", "slice", ComponentObjectGetValue2(proj2, "damage_by_type", "slice") + ComponentObjectGetValue2(proj, "damage_by_type", "slice") / damage_reducer)
            ComponentObjectSetValue2(proj2, "damage_by_type", "fire", ComponentObjectGetValue2(proj2, "damage_by_type", "fire") + ComponentObjectGetValue2(proj, "damage_by_type", "fire") / damage_reducer)
            ComponentObjectSetValue2(proj2, "damage_by_type", "ice", ComponentObjectGetValue2(proj2, "damage_by_type", "ice") + ComponentObjectGetValue2(proj, "damage_by_type", "ice") / damage_reducer)

            local fire = EntityGetFirstComponent(me, "VariableStorageComponent", "fire")
            if fire then
                dofile_once("mods/noiting_simulator/files/scripts/burn_projectile.lua")
                local type = ComponentGetValue2(fire, "value_string")
                local amount = ComponentGetValue2(fire, "value_float")
                Add_burn(projs[i], type, amount / damage_reducer)
            end

        end
    end
end
ComponentSetValue2(proj, "lifetime", lifetime)
local stress_threshold = 60
if #projs > stress_threshold then max = max - 0.16 end
ComponentObjectSetValue2(proj, "damage_by_type", "melee", (max - 1) / 50)
ComponentSetValue2(sprite, "rect_animation", (not on and "closed") or (lifetime <= 14 and "go") or (#projs > stress_threshold and "stressed") or "open")
size = size + (max - size) / 20

ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", size * 1000)
local start = ComponentGetValue2(proj, "mStartingLifetime") / 14
lifetime = lifetime / 14
local bar_mult = (size * 2) / start
for i = 1, #sprites do
    if i <= 4 then -- corners
        local xs = (i == 2 or i == 4) and size or -size
        local ys = (i == 3 or i == 4) and size or -size
        ComponentSetValue2(sprites[i], "offset_x", xs + 2)
        ComponentSetValue2(sprites[i], "offset_y", ys + 2)
        ComponentSetValue2(sprites[i], "alpha", on and 0.75 or 0.5)
    elseif i == 5 then -- back
        ComponentSetValue2(sprites[i], "special_scale_x", (size + 2) * 2)
        ComponentSetValue2(sprites[i], "special_scale_y", (size + 2) * 2)
        ComponentSetValue2(sprites[i], "alpha", on and 1 or 0.5)
    elseif i == 6 then
        ComponentSetValue2(sprites[i], "special_scale_x", start * bar_mult)
        ComponentSetValue2(sprites[i], "offset_y", size * 0.8)
        ComponentSetValue2(sprites[i], "alpha", 0.5)
    elseif i == 7 then
        ComponentSetValue2(sprites[i], "special_scale_x", lifetime * bar_mult)
        ComponentSetValue2(sprites[i], "offset_y", size * 0.8)
    end
end
-- wall collision
local yes
local nx, ny = x, y
-- right
yes = RaytracePlatforms(x - size, y, x - size, y)
local hit, hx, hy = RaytracePlatforms(x, y, x + size, y)
if hit and not yes then
    nx = hx - size
    ComponentSetValue2(vel, "mVelocity", 0, vy)
end
-- left
yes = RaytracePlatforms(x + size, y, x + size, y)
hit, hx, hy = RaytracePlatforms(x, y, x - size, y)
if hit and not yes then
    nx = hx + size
    ComponentSetValue2(vel, "mVelocity", 0, vy)
end
-- up
yes = RaytracePlatforms(x, y + size, x, y + size)
hit, hx, hy = RaytracePlatforms(x, y, x, y - size)
if hit and not yes then
    ny = hy + size
    ComponentSetValue2(vel, "mVelocity", vx, 0)
end
-- down
yes = RaytracePlatforms(x, y - size, x, y - size)
hit, hx, hy = RaytracePlatforms(x, y, x, y + size)
if hit and not yes then
    ny = hy - size
    ComponentSetValue2(vel, "mVelocity", vx, 0)
end
EntitySetTransform(me, nx, ny)