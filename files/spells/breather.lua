local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local part = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
if not (proj and part) then return end
local lifetime = ComponentGetValue2(proj, "lifetime")
local player = ComponentGetValue2(proj, "mWhoShot")
if player and player > 0 and ComponentGetValue2(this, "mTimesExecuted") == 0 then
	local hearts = EntityGetWithTag("heart")
	local entity1 = LoadGameEffectEntityTo(player, "mods/noiting_simulator/files/spells/breather_zap.xml")
	local game1 = EntityGetFirstComponentIncludingDisabled(entity1, "GameEffectComponent")
	if game1 then
		ComponentSetValue2(game1, "frames", lifetime)
	end
	for i = 1, #hearts do
		local entity2 = LoadGameEffectEntityTo(hearts[i], "mods/noiting_simulator/files/spells/breather_zap.xml")
		local game2 = EntityGetFirstComponentIncludingDisabled(entity2, "GameEffectComponent")
		if game2 then
			ComponentSetValue2(game2, "frames", lifetime)
		end
	end
end
local radius, _ = ComponentGetValue2(part, "area_circle_radius")
radius = math.min(300, radius + 12)
ComponentSetValue2(part, "area_circle_radius", radius, radius)
ComponentSetValue2(part, "count_min", radius * 0.75)
ComponentSetValue2(part, "count_max", radius * 0.75)