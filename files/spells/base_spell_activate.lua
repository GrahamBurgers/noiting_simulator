local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local root = EntityGetRootEntity(me)
local _, _, _, flip = EntityGetTransform(root)
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local inworld = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "item_identified")
local controls = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "item_identified")
local uses_remaining = item and ComponentGetValue2(item, "uses_remaining")
if item and controls and sprite and inworld and ComponentGetValue2(controls, "mButtonFrameThrow") == GameGetFrameNum() and uses_remaining ~= 0 then
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
		local function thing(name, type)
			local current = ComponentGetValue2(item, "ui_sprite")
			current = current == "mods/noiting_simulator/files/spells/" .. name .. "2.png" and "mods/noiting_simulator/files/spells/" .. name .. ".png" or "mods/noiting_simulator/files/spells/" .. name .. "2.png"
			local anim = string.find(current, "2")
			local file = anim and "mods/noiting_simulator/files/spells/explosions/invert_effect2.png" or "mods/noiting_simulator/files/spells/explosions/invert_effect.png"
			ComponentSetValue2(item, "ui_sprite", current)
			ComponentSetValue2(inworld, "image_file", current)
			EntityRefreshSprite(me, inworld)

			local particle = EntityLoad("mods/noiting_simulator/files/spells/explosions/limiter.xml", x, y - 2)
			local p = EntityAddComponent2(particle, "ParticleEmitterComponent", {
				emitted_material_name=type,
				lifetime_min=0.7,
				lifetime_max=1.1,
				count_min=3,
				count_max=3,
				render_on_grid=true,
				fade_based_on_lifetime=true,
				cosmetic_force_create=true,
				custom_alpha=0.4,
				airflow_force=0,
				emission_interval_min_frames=1,
				emission_interval_max_frames=1,
				emit_cosmetic_particles=true,
				image_animation_file=file,
				image_animation_speed=30,
				image_animation_loop=false,
				image_animation_raytrace_from_center=false,
				is_emitting=true,
			})
			ComponentSetValue2(p, "gravity", 0, 0)
			ComponentSetValue2(p, "area_circle_radius", 0, 0)
		end
		-- custom func?
		if entity_to_load == "heal" then
			local dmg = EntityGetFirstComponentIncludingDisabled(root, "DamageModelComponent")
			local hp     = dmg and ComponentGetValue2(dmg, "hp")
			local max_hp = dmg and ComponentGetValue2(dmg, "max_hp")
			if dmg then
				local gain = EntityGetWithName("dummy") == 0 and 5 or 0
				max_hp = max_hp + (gain / 25)
				hp = math.min(max_hp, hp + (max_hp / 2))
				ComponentSetValue2(dmg, "max_hp", max_hp)
				ComponentSetValue2(dmg, "hp", hp)
				EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x, y)

				worked = true
			end
		elseif entity_to_load == "nolla" then
			thing("nolla", "magic_gas_polymorph")
		elseif entity_to_load == "fourth" then
			thing("fourth", "spark_yellow")
		elseif entity_to_load == "decelerate" then
			thing("decelerate", "spark_blue")
		elseif entity_to_load == "gutbuster" then
			thing("gutbuster", "spark_green")
		end
	end
	if uses_remaining > 0 and worked then
		uses_remaining = uses_remaining - 1
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