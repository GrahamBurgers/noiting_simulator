local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local root = EntityGetRootEntity(me)
local _, _, _, flip = EntityGetTransform(root)
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local controls = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "item_identified")
local uses_remaining = item and ComponentGetValue2(item, "uses_remaining")
if item and controls and sprite and ComponentGetValue2(controls, "mButtonFrameThrow") == GameGetFrameNum() and uses_remaining ~= 0 then
	dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
	local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
	local dir = math.atan2(dy or 0, -dx or 0)

	local worked = false
	local entity_to_load = ComponentGetValue2(this, "script_material_area_checker_failed")
	if ModDoesFileExist(entity_to_load) --[[and EntityGetWithName(entity_to_load) == 0]] then
		-- shoot the thing
		local displace_px = 0
		local inv2comp = EntityGetFirstComponentIncludingDisabled(root, "Inventory2Component")
		local activeitem = inv2comp and ComponentGetValue2(inv2comp, "mActiveItem")
		local hotspot = activeitem and activeitem > 0 and EntityGetFirstComponentIncludingDisabled(activeitem, "HotspotComponent")
		local wx, wy = nil, nil
		if hotspot then
			wx, wy = EntityGetTransform(activeitem)
			local ox, oy = ComponentGetValue2(hotspot, "offset")
			displace_px = ox
		end
		local proj = Shoot({file = entity_to_load, whoshot = root, target = dir, do_muzzle_flash = true, displace_px = displace_px, x = wx, y = wy})
		if ComponentGetValue2(this, "script_material_area_checker_success") == "1" then
			EntityAddChild(root, proj[1])
		end
		local proj2 = EntityGetFirstComponentIncludingDisabled(proj[1], "ProjectileComponent")
		if proj2 then ComponentSetValue2(proj2, "mEntityThatShot", me) end
		EntitySetName(proj[1], entity_to_load)

		worked = true
	else
		-- custom func?
	end
	if uses_remaining > 0 and worked then
		if EntityGetWithName("dummy") == 0 then uses_remaining = uses_remaining - 1 end
		ComponentSetValue2(item, "uses_remaining", uses_remaining)
		if uses_remaining == 0 then
			GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y)
			local p = EntityAddComponent2(me, "SpriteParticleEmitterComponent", {
				_tags="remove_me_please",
				sprite_file=ComponentGetValue2(sprite, "image_file"),
				sprite_centered=true,
				count_min=1,
				count_max=1,
				emission_interval_min_frames=9999,
				emission_interval_max_frames=9999,
				use_rotation_from_entity=false,
				lifetime=2,
			})
			ComponentSetValue2(p, "color_change", 0, 0, 0, -1)
			ComponentSetValue2(p, "randomize_position", 0, -6, 0, -6)
			ComponentSetValue2(p, "velocity", 0, -40)
			ComponentSetValue2(p, "gravity", 0, 15)
		else
			uses_remaining = tostring(uses_remaining)
			local len = string.len(uses_remaining)
			local offset = -1 * len
			for i = 1, len do
				local num = string.sub(uses_remaining, i, i)
				local p = EntityAddComponent2(me, "SpriteParticleEmitterComponent", {
					_tags="remove_me_please",
					sprite_file="mods/noiting_simulator/files/gui/num_" .. num .. ".png",
					sprite_centered=true,
					count_min=1,
					count_max=1,
					emission_interval_min_frames=9999,
					emission_interval_max_frames=9999,
					use_rotation_from_entity=false,
					lifetime=2,
				})
				ComponentSetValue2(p, "color_change", 0, 0, 0, -1)
				if flip == -1 then
					ComponentSetValue2(p, "randomize_position", -offset, -6, -offset, -6)
				else
					ComponentSetValue2(p, "randomize_position", offset, -6, offset, -6)
				end
				ComponentSetValue2(p, "velocity", 0, -40)
				ComponentSetValue2(p, "gravity", 0, 15)
				offset = offset + 4.5
			end
		end
	end
end