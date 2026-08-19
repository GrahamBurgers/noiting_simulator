local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local p = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "nolla")
if not (proj and p) then return end
local inverted = ComponentGetValue2(GetUpdatedComponentID(), "script_material_area_checker_success") == "itstrueforsure"
local lifetime = ComponentGetValue2(proj, "lifetime")

local particle_mult = 14
local amount = 1
local damage_div = 140
local potential_damage = lifetime / damage_div
amount = math.min(lifetime, amount)
if inverted then amount = -amount end
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "melee")

if (inverted and dmg > 0) or amount > 0 then
	lifetime = lifetime - amount
	ComponentSetValue2(proj, "lifetime", lifetime)
	ComponentSetValue2(p, "area_circle_radius", potential_damage * particle_mult, potential_damage * particle_mult)
	ComponentObjectSetValue2(proj, "damage_by_type", "melee", dmg + amount / damage_div)
	EntitySetComponentIsEnabled(me, p, true)
	ComponentSetValue2(p, "emitted_material_name", "magic_gas_polymorph")
else
	ComponentSetValue2(p, "emitted_material_name", "concrete_static")
end