local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local part = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
if not (proj and part) then return end
local player = ComponentGetValue2(proj, "mWhoShot")
if player and player > 0 and ComponentGetValue2(this, "mTimesExecuted") == 0 then
	local hearts = EntityGetWithTag("heart")
	LoadGameEffectEntityTo(player, "mods/noiting_simulator/files/spells/breather_zap.xml")
	for i = 1, #hearts do
		LoadGameEffectEntityTo(hearts[i], "mods/noiting_simulator/files/spells/breather_zap.xml")
	end
end
local radius, _ = ComponentGetValue2(part, "area_circle_radius")
radius = math.min(300, radius + 12)
ComponentSetValue2(part, "area_circle_radius", radius, radius)
ComponentSetValue2(part, "count_min", radius * 0.75)
ComponentSetValue2(part, "count_max", radius * 0.75)