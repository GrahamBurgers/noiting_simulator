local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent")
if not (vel and sprite and proj and particle) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local cute = ComponentObjectGetValue2(proj, "damage_by_type", "melee")
local charming = ComponentObjectGetValue2(proj, "damage_by_type", "slice")
local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") == 0 then
	dofile_once("mods/noiting_simulator/files/scripts/burn_projectile.lua")
	Add_burn(me, "CUTE",     cute,     0, -9)
	Add_burn(me, "CHARMING", charming, 0, -9)
	Add_burn(me, "CLEVER",   clever,    0, -9)
	Add_burn(me, "COMEDIC",  comedic,    0, -9)
	if vy < 0 then
		ComponentSetValue2(vel, "air_friction", ComponentGetValue2(vel, "air_friction") + 4)
		ComponentSetValue2(proj, "hit_particle_force_multiplier", 0)
		ComponentSetValue2(sprite, "rect_animation", "floaty")
	end
end
if (ComponentGetValue2(proj, "bounces_left") <= 1) then -- why does this work?
	local ground, hx, hy = RaytracePlatforms(x, y, x, y + 2)
	if ground then
		ComponentSetValue2(vel, "mVelocity", vx, 0)
		ComponentSetValue2(proj, "hit_particle_force_multiplier", 0)
		EntitySetTransform(me, x, hy)
		ComponentSetValue2(vel, "air_friction", ComponentGetValue2(vel, "air_friction") + 0.5)
	end
end
Last_boing = ComponentGetValue2(proj, "bounces_left")
local size = ComponentGetValue2(proj, "blood_count_multiplier")
ComponentSetValue2(particle, "area_circle_radius", size - 4, size)
ComponentSetValue2(particle, "count_min", size / 4)
ComponentSetValue2(particle, "count_max", size / 4)
ComponentSetValue2(particle, "velocity_always_away_from_center", 10)

local projs = EntityGetInRadiusWithTag(x, y, size, "projectile")
for i = 1, #projs do
	if EntityGetHerdRelation(me, projs[i]) > 50 and not EntityHasTag(projs[i], "flameyflame" .. tostring(me)) and not EntityHasTag(projs[i], "candle") then
		EntityAddTag(projs[i], "flameyflame" .. tostring(me))
		dofile_once("mods/noiting_simulator/files/scripts/burn_projectile.lua")
		Add_burn(projs[i], "CUTE",     cute,     0, 0, true)
		Add_burn(projs[i], "CHARMING", charming, 0, 0, true)
		Add_burn(projs[i], "CLEVER",   clever,   0, 0, true)
		Add_burn(projs[i], "COMEDIC",  comedic,  0, 0, true)
	end
end