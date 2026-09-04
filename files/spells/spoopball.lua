local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y, rot = EntityGetTransform(me)
Last_x = Last_x or x

rot = rot + (Last_x - x) / -10

EntitySetTransform(me, x, y, rot)
Last_x = x

local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local sprites = EntityGetComponent(me, "SpriteComponent", "spoopball") or {}
local spritepart = EntityGetFirstComponent(me, "SpriteParticleEmitterComponent")
if not (proj and vel and #sprites > 1 and spritepart) then return end

local initial_bounces = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if initial_bounces < -99 then
	initial_bounces = ComponentGetValue2(proj, "bounces_left")
	ComponentSetValue2(this, "limit_how_many_times_per_frame", initial_bounces)
end
local size = ComponentGetValue2(proj, "blood_count_multiplier")
local simulated_size = ComponentGetValue2(this, "limit_to_every_n_frame")
if simulated_size < -99 then
	simulated_size = size
end
simulated_size = simulated_size + (size - simulated_size) / 4
ComponentSetValue2(this, "limit_to_every_n_frame", simulated_size)

local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
local sprite_size = simulated_size / 4
ComponentSetValue2(sprites[1], "special_scale_x", sprite_size)
ComponentSetValue2(sprites[1], "special_scale_y", sprite_size)
ComponentSetValue2(sprites[2], "special_scale_x", sprite_size)
ComponentSetValue2(sprites[2], "special_scale_y", sprite_size)
ComponentSetValue2(spritepart, "scale", sprite_size, sprite_size)
local projs = EntityGetInRadiusWithTag(x, y, size + 90, "projectile")
for i = 1, #projs do
	local is_piercing = EntityHasTag(projs[i], "pierces")
	local vel2 = EntityGetFirstComponent(projs[i], "VelocityComponent")
	local multiplier = is_piercing and 0.15 or 1
	if projs[i] ~= me and EntityGetHerdRelation(me, projs[i]) > 50 and touchinghitbox(size + 2, projs[i], false) and vel2 then
		local vx, vy = ComponentGetValue2(vel2, "mVelocity")
		ComponentSetValue2(vel, "mVelocity", vx * 0.9, vy * 0.9)
		ComponentSetValue2(proj, "blood_count_multiplier", size + 2 * multiplier)
		local starting_lifetime = ComponentGetValue2(proj, "mStartingLifetime")
		ComponentSetValue2(proj, "lifetime", math.max(ComponentGetValue2(proj, "lifetime"), starting_lifetime))
		ComponentSetValue2(proj, "mStartingLifetime", starting_lifetime - 10 * multiplier)
		ComponentSetValue2(proj, "bounces_left", initial_bounces)
		local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")

		local hurt = EntityGetFirstComponentIncludingDisabled(projs[i], "VariableStorageComponent", "comedic_hurt_multiplier") or
			EntityAddComponent2(projs[i], "VariableStorageComponent", {_tags="comedic_hurt_multiplier"})
			ComponentSetValue2(hurt, "value_float", 0)
		q.add_mult(me, "ballllllz", 0.5 * multiplier, "dmg_mult_collision,dmg_mult_explosion")
		if not is_piercing then
			EntityKill(projs[i])
		end
	end
end