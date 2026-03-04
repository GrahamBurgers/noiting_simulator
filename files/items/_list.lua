--[[
dofile_once("mods/noiting_simulator/files/items/_list.lua")
GiveItem("shroom")
]]--
ITEMS = {
	["firestone"] = {dmg = 5, size = 4, material = "sulphur_box2d", extra_func = function(me)
		EntityAddComponent2(me, "VariableStorageComponent", {
			_tags="fire",
			value_string="TYPELESS",
			value_float=0.5,
		})
	end},
	["thunderstone"] = {dmg = 5, size = 4},
	["waterstone"]   = {dmg = 5, size = 4},
	["stonestone"]   = {dmg = 5, size = 4},
	["poopstone"]    = {dmg = 5, size = 4},
	["gourd"]        = {dmg = 5, size = 4, material = "meat_fruit"},
	["roofkey"]      = {dmg = 5, size = 4, material = "item_box2d_glass"},
	["medickey"]     = {dmg = 5, size = 4, material = "item_box2d_glass"},
	["shroom"]       = {dmg = 5, size = 24, material = "meat_fruit", offset_y = 9, throw = false, extra_func = function(me)
		local radius = 14
		local degrees = 90
		local s = EntityAddComponent2(me, "EnergyShieldComponent", {
			_enabled=false,
			_tags="enabled_in_hand",
			radius=radius,
			sector_degrees=degrees,
			damage_multiplier=50,
			max_energy=100,
			energy_required_to_shield=0,
			recharge_speed=2,
		})
		ComponentSetValue2(s, "energy", ComponentGetValue2(s, "max_energy"))
		local p = EntityAddComponent2(me, "ParticleEmitterComponent", {
			_enabled=false,
			_tags="enabled_in_hand,enabled_in_world2,shield_hit",
			emitted_material_name="plasma_fading_pink",
			lifetime_min=1,
			lifetime_max=1,
			count_min=25,
			count_max=25,
			render_on_grid=true,
			fade_based_on_lifetime=true,
			velocity_always_away_from_center=90,
			cosmetic_force_create=false,
			airflow_force=0,
			area_circle_sector_degrees=degrees,
			emission_interval_min_frames=0,
			emission_interval_max_frames=0,
			emit_cosmetic_particles=true,
			is_emitting=false,
		})
		EntityAddComponent2(me, "LuaComponent", {
			_tags="enabled_in_hand",
			script_source_file="mods/noiting_simulator/files/items/shroom.lua",
			script_enabled_changed="mods/noiting_simulator/files/items/shroom_deselect.lua",
		})
		ComponentSetValue2(p, "area_circle_radius", radius, radius)
		ComponentSetValue2(p, "gravity", 0, 102)
	end}
}
for i, j in pairs(ITEMS) do
	ITEMS[i].name = "$ns_name_" .. i
	ITEMS[i].desc = "$ns_desc_" .. i
	ITEMS[i].sprite = "mods/noiting_simulator/files/items/" .. i .. ".png"
	ITEMS[i].inhand = "mods/noiting_simulator/files/items/" .. i .. "_small.png"
	if ITEMS[i].throw == nil then ITEMS[i].throw = true end -- falsy...
end

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

function GiveItem(id)
	dofile_once("mods/noiting_simulator/files/items/_list.lua")
	local items = smallfolk.loads(GlobalsGetValue("NS_ITEMS", "{}")) or {}
	items[#items+1] = id
	GlobalsSetValue("NS_ITEMS", smallfolk.dumps(items))
end

function CollectItems(include_held)
	include_held = include_held or false

	local items = smallfolk.loads(GlobalsGetValue("NS_ITEMS", "{}")) or {}

	local entities = EntityGetWithTag("inventory_item")
	for i = 1, #entities do
		if include_held or (EntityGetRootEntity(entities[i]) == entities[i]) then
			local id = EntityGetName(entities[i])
			items[#items+1] = id
			EntityKill(entities[i])
		end
	end
	GlobalsSetValue("NS_ITEMS", smallfolk.dumps(items))
end

function SpawnItem(id, x, y)
	local entity = EntityLoad("mods/noiting_simulator/files/items/_base.xml", x, y)
	EntitySetName(entity, id)
	local proj = EntityGetFirstComponentIncludingDisabled(entity, "ProjectileComponent")
	if proj then
		ComponentSetValue2(proj, "blood_count_multiplier", ITEMS[id].size)
		ComponentObjectSetValue2(proj, "damage_by_type", "drill", ITEMS[id].dmg / 25)
	end
	local phys = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsImageShapeComponent")
	if phys then
		ComponentSetValue2(phys, "image_file", ITEMS[id].inhand)
		ComponentSetValue2(phys, "material", CellFactory_GetType(ITEMS[id].material or "item_box2d"))
	end
	EntityAddComponent2(entity, "SpriteComponent", {
		_enabled=true,
		_tags="enabled_in_hand",
		offset_x=ITEMS[id].offset_x or 4,
		offset_y=ITEMS[id].offset_y or 4,
		image_file=ITEMS[id].inhand,
	})
	EntityAddComponent2(entity, "ItemComponent", {
		_tags="enabled_in_world2",
		item_name=ITEMS[id].name,
		auto_pickup=false,
		max_child_items=0,
		is_pickable=true,
		is_equipable_forced=true,
		ui_sprite=ITEMS[id].sprite,
		ui_description=ITEMS[id].desc,
		preferred_inventory="QUICK",
		next_frame_pickable=-999,
		play_hover_animation=true,
		play_spinning_animation=false,
	})
	EntityAddComponent2(entity, "UIInfoComponent", {
		_tags="enabled_in_world2",
		name=ITEMS[id].name,
	})
	EntityAddComponent2(entity, "LuaComponent", {
		_enabled=false,
		_tags="enabled_in_hand,enabled_in_inventory",
		script_source_file="mods/noiting_simulator/files/items/_pickup.lua",
		remove_after_executed=true,
	})
	EntityAddComponent2(entity, "LuaComponent", {
		_tags="enabled_in_world2",
		script_source_file="mods/noiting_simulator/files/items/_inworld.lua",
	})
	local ability = EntityAddComponent2(entity, "AbilityComponent", {
		ui_name=ITEMS[id].name,
		throw_as_item=ITEMS[id].throw,
	})
	ComponentObjectSetValue2(ability, "gun_config", "deck_capacity", 0)
	if ITEMS[id].extra_func then ITEMS[id].extra_func(entity) end
	EntitySetComponentsWithTagEnabled(entity, "enabled_in_hand", false)
	EntitySetComponentsWithTagEnabled(entity, "enabled_in_world", true)
	EntitySetComponentsWithTagEnabled(entity, "enabled_in_inventory", false)
	EntityAddComponent2(entity, "SpriteComponent", {
		_enabled=true,
		_tags="",
		offset_x=9,
		offset_y=9,
		image_file="mods/noiting_simulator/files/items/_itemslot.png",
		z_index=1.1,
		update_transform_rotation=false,
	})
	EntityAddComponent2(entity, "SpriteComponent", {
		_enabled=true,
		_tags="",
		offset_x=7,
		offset_y=7,
		image_file=ITEMS[id].sprite,
		update_transform_rotation=false,
	})
end