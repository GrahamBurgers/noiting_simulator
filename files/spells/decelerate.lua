local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local p = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "decelerate")
if not (proj and vel and p) then return end
local inverted = ComponentGetValue2(GetUpdatedComponentID(), "script_material_area_checker_success") == "itstrueforsure"
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local max_vel = ComponentGetValue2(vel, "terminal_velocity")
local magnitude = math.min(max_vel, math.sqrt(vx^2 + vy^2))
local direction = math.pi - math.atan2(vy, vx)

local particle_mult = 14
local amount = 5
local damage_div = 85 * amount
local potential_damage = magnitude / damage_div
amount = math.min(magnitude, amount)
if inverted then amount = -amount end
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "fire")

if (inverted and dmg > 0 and magnitude > 0) or (not inverted and amount > 0) then
	magnitude = magnitude - amount
	if not inverted then ComponentSetValue2(vel, "terminal_velocity", math.min(max_vel * 0.96, magnitude * 1.5)) end
	ComponentSetValue2(vel, "mVelocity", -math.cos(direction) * magnitude, math.sin(direction) * magnitude)
	ComponentSetValue2(p, "area_circle_radius", potential_damage * particle_mult, potential_damage * particle_mult)
	ComponentObjectSetValue2(proj, "damage_by_type", "fire", dmg + amount / damage_div)
	EntitySetComponentIsEnabled(me, p, true)
	ComponentSetValue2(p, "emitted_material_name", "spark_blue")
else
	ComponentSetValue2(p, "emitted_material_name", "concrete_static")
end