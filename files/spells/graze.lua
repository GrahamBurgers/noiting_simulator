local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetRootEntity(me)
local parent = EntityGetParent(me)
local dmg = EntityGetFirstComponent(player, "DamageModelComponent")
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent", "graze_area")
if not (dmg and particle) then return end
local siblings = EntityGetAllChildren(parent, "graze_area") or {}

local count = (#siblings - 1)
local mana_add = 20
local health_add = 2
local rad = 14 * (1.25 ^ count)
local rad2 = rad + 2
ComponentSetValue2(particle, "area_circle_radius", rad, rad)
if me ~= siblings[1] then return end

local proj = EntityGetInRadiusWithTag(x, y, rad, "projectile")
local graze_area = EntityGetInRadiusWithTag(x, y, rad * 2, "graze_projectile")
for i = 1, #proj do
	local p = EntityGetFirstComponent(proj[i], "ProjectileComponent")
	if (not EntityHasTag(proj[i], "graze_projectile") and p and (ComponentGetValue2(p, "mWhoShot") ~= player)) and ComponentGetValue2(p, "play_damage_sounds") and not EntityHasTag(proj[i], "pierces") then
		EntityAddTag(proj[i], "graze_projectile")
		EntityAddComponent2(proj[i], "SpriteComponent", {
			image_file="mods/noiting_simulator/files/spells/graze_field.png",
			offset_x=6,
			offset_y=6,
			additive=true,
			update_transform_rotation=false
		})
	end
end
for i = 1, #graze_area do
	local x2, y2 = EntityGetTransform(graze_area[i])
	local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
	if distance > rad2 then
		EntityKill(graze_area[i])
		local mana = tonumber(GlobalsGetValue("INHERENT_MANA")) or 0
		local mana_max = tonumber(GlobalsGetValue("MANA_MAX_FINAL")) or 0
		GlobalsSetValue("INHERENT_MANA", tostring(math.min(mana_max, mana + mana_add)))

		ComponentSetValue2(dmg, "hp", math.min(ComponentGetValue2(dmg, "max_hp"), ComponentGetValue2(dmg, "hp") + health_add / 25))
		EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x, y)
		GameCreateCosmeticParticle("spark_blue", x2, y2, 60, 40, 40, 0, 0.2, 0.5, true, true, false, true, 0, 0)
	end
end