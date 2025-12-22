local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local x, y = EntityGetTransform(me)
if not proj then return end
local force = ComponentGetValue2(proj, "knockback_force") * -5
local poof = EntityLoad("mods/noiting_simulator/files/spells/entice_poof.xml", x, y)
local radius = (ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius") * 1.5) + 15
local particle = EntityGetFirstComponent(poof, "ParticleEmitterComponent", "entice")
if particle then
	ComponentSetValue2(particle, "area_circle_radius", radius + 2, radius - 2)
	ComponentSetValue2(particle, "count_min", radius / 4)
	ComponentSetValue2(particle, "count_max", radius / 4)
	ComponentSetValue2(particle, "lifetime_min", radius / 20)
	ComponentSetValue2(particle, "lifetime_max", radius / 20)
	ComponentSetValue2(particle, "velocity_always_away_from_center", force)
end