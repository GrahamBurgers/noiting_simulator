local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local root = EntityGetRootEntity(me)
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local controls = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "item_identified")
local uses_remaining = item and ComponentGetValue2(item, "uses_remaining")
if item and controls and sprite and ComponentGetValue2(controls, "mButtonFrameThrow") == GameGetFrameNum() and uses_remaining ~= 0 then
	dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
	local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
	local dir = math.atan2(dy or 0, -dx or 0)
	print("dir; " .. tostring(dir))

	Shoot({file = "mods/noiting_simulator/files/spells/breeze.xml", whoshot = root, target = dir})
	if uses_remaining > 0 then
		ComponentSetValue2(item, "uses_remaining", uses_remaining - 1)
		if uses_remaining == 1 then
			GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y)
			local p = EntityAddComponent2(me, "SpriteParticleEmitterComponent", {
				_tags="remove_me_please",
				sprite_file=ComponentGetValue2(sprite, "image_file"),
				sprite_centered=true,
				count_min=1,
				count_max=1,
				emission_interval_min_frames=9999,
				emission_interval_max_frames=9999,
				lifetime=2,
			})
			ComponentSetValue2(p, "color_change", 0, 0, 0, -1)
			ComponentSetValue2(p, "randomize_position", 0, -6, 0, -6)
			ComponentSetValue2(p, "velocity", 0, -40)
			ComponentSetValue2(p, "gravity", 0, 15)
		end
	end
end