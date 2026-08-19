local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local p = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "gutbuster")
if not (proj and p) then return end
local inverted = ComponentGetValue2(GetUpdatedComponentID(), "script_material_area_checker_success") == "itstrueforsure"
local kb = ComponentGetValue2(proj, "knockback_force")

local particle_mult = 14
local amount = 0.3
local damage_div = 35
local potential_damage = kb / damage_div
amount = math.min(kb, amount)
if inverted then amount = -amount end
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "ice")

if (inverted and dmg > 0) or amount > 0 then
	kb = kb - amount
	ComponentSetValue2(proj, "knockback_force", kb)
	ComponentSetValue2(p, "area_circle_radius", potential_damage * particle_mult, potential_damage * particle_mult)
	ComponentObjectSetValue2(proj, "damage_by_type", "ice", dmg + amount / damage_div)
	EntitySetComponentIsEnabled(me, p, true)
	ComponentSetValue2(p, "emitted_material_name", "spark_green")
else
	ComponentSetValue2(p, "emitted_material_name", "concrete_static")
end