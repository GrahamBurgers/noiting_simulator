local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end

local whoshot = proj and ComponentGetValue2(proj, "mWhoShot")
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
local entity = Shoot({file = "mods/noiting_simulator/files/spells/lobber_heal.xml", count = 1, whoshot = whoshot})[1]
local proj2 = entity and EntityGetFirstComponentIncludingDisabled(entity, "ProjectileComponent")
local part = entity and EntityGetFirstComponentIncludingDisabled(entity, "ParticleEmitterComponent")
if proj2 and part then
	local total_damage = ComponentGetValue2(proj, "damage")
	local explosions_more = EntityGetComponentIncludingDisabled(me, "VariableStorageComponent", "explosion_big_weeee") or {}
	local radius = math.max(ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius"), ComponentGetValue2(proj, "blood_count_multiplier"))
	radius = (radius + 5 * #explosions_more) * (1.15 ^ #explosions_more)

	local heal_lifetime = ComponentObjectGetValue2(proj2, "damage_by_type", "healing") * 5 -- idk why it's 5

	ComponentSetValue2(proj2, "blood_count_multiplier", radius)
	ComponentObjectSetValue2(proj2, "damage_by_type", "physics_hit", (total_damage / heal_lifetime)) -- undoes its own damage

	ComponentSetValue2(part, "count_min", radius)
	ComponentSetValue2(part, "count_max", radius)
	ComponentSetValue2(part, "area_circle_radius", radius - 1, radius + 1)
end