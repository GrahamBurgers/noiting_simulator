local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local p = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "fourth")
if not (proj and p) then return end
local inverted = ComponentGetValue2(GetUpdatedComponentID(), "script_material_area_checker_success") == "itstrueforsure"
local size = math.max(ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius"), ComponentGetValue2(proj, "blood_count_multiplier"))

local particle_mult = 14
local amount = 0.3
local damage_div = 80 * amount
local potential_damage = size / damage_div
amount = math.min(size, amount)
if inverted then amount = -amount end
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "slice")

if (inverted and dmg > 0) or amount > 0 then
	size = size - amount
	ComponentSetValue2(proj, "blood_count_multiplier", ComponentGetValue2(proj, "blood_count_multiplier") - amount)
	ComponentObjectSetValue2(proj, "config_explosion", "explosion_radius", ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius") - amount)
	ComponentSetValue2(p, "area_circle_radius", potential_damage * particle_mult, potential_damage * particle_mult)
	ComponentObjectSetValue2(proj, "damage_by_type", "slice", dmg + amount / damage_div)
	EntitySetComponentIsEnabled(me, p, true)
	ComponentSetValue2(p, "emitted_material_name", "spark_yellow")
else
	ComponentSetValue2(p, "emitted_material_name", "concrete_static")
end