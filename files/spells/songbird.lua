local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local part = EntityGetFirstComponent(me, "ParticleEmitterComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if not (proj and part and sprite and vel) then return end

local effect_radius = ComponentGetValue2(proj, "blood_count_multiplier") * 2
ComponentSetValue2(part, "area_circle_radius", effect_radius, effect_radius)

local vx, vy = ComponentGetValue2(vel, "mVelocity")
ComponentSetValue2(sprite, "special_scale_x", vx < 0 and -1 or 1)

local id = "birdy" .. tostring(me)
local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
local projs = EntityGetInRadiusWithTag(x, y, effect_radius + 90, "projectile")
for i = 1, #projs do
	local valid = true
	local vars = EntityGetComponent(projs[i], "VariableStorageComponent", "search_me") or {}
	for j = 1, #vars do
		if ComponentGetValue2(vars[j], "value_string") == id then
			valid = false
			break
		end
	end

	if valid and projs[i] ~= me and EntityGetHerdRelation(me, projs[i]) < 50 and touchinghitbox(effect_radius, projs[i], false) and not EntityHasTag(projs[i], "protected") then
		SetRandomSeed(me, GameGetFrameNum())
		local img = "mods/noiting_simulator/files/spells/gfx/songbird_note" .. tostring(Random(1, 4)) .. ".png"
		EntityAddComponent2(projs[i], "VariableStorageComponent", {_tags="search_me", value_string=id})
		dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
		local notes = Shoot({file = "mods/noiting_simulator/files/spells/songbird_note.xml", target = "HEART", count = 3, deg_between = 20, speed_random_per = 30, whoshot = me})
		for j = 1, #notes do
			local spritep = EntityGetFirstComponentIncludingDisabled(notes[j], "SpriteParticleEmitterComponent")
			local sprite2 = EntityGetFirstComponentIncludingDisabled(notes[j], "SpriteComponent")
			if spritep and sprite2 then
				ComponentSetValue2(sprite2, "image_file", img)
				ComponentSetValue2(spritep, "sprite_file", img) -- gotta love how these are called different things
				ComponentSetValue2(spritep, "randomize_position", -3, -3, 3, 3)
				ComponentSetValue2(spritep, "randomize_velocity", -5, -5, 5, 5)
				EntityRefreshSprite(notes[j], sprite2)
			end
		end
		EntityKill(projs[i])
	end
end