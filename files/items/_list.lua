--[[
dofile_once("mods/noiting_simulator/files/items/_list.lua")
GiveItem("shroom")
]]--
local ITEMS = {
	["firestone"]    = {material = "sulphur_box2d"},
	["thunderstone"] = {},
	["waterstone"]   = {},
	["stonestone"]   = {},
	["poopstone"]    = {},
	["gourd"]        = {material = "meat_fruit"},
	["roofkey"]      = {material = "item_box2d_glass"},
	["medickey"]     = {material = "item_box2d_glass"},
	["shroom"]       = {material = "meat_fruit", offset_y = 9, throw = false, extra_func = function(me)
		local radius = 14
		local degrees = 90
		local s = EntityAddComponent2(me, "EnergyShieldComponent", {
			_enabled=false,
			_tags="enabled_in_hand,enabled_in_world",
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
			_tags="enabled_in_hand,enabled_in_world,shield_hit",
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
			_tags="enabled_in_hand,enabled_in_world,enabled_in_inventory",
			script_source_file="mods/noiting_simulator/files/items/shroom.lua",
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
function GiveItem(id)
	local entity = EntityLoad("mods/noiting_simulator/files/items/_base.xml")
	EntitySetName(entity, ITEMS[id].name)
	local phys = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsImageShapeComponent")
	if phys then
		ComponentSetValue2(phys, "image_file", ITEMS[id].inhand)
		ComponentSetValue2(phys, "material", CellFactory_GetType(ITEMS[id].material or "item_box2d"))
	end
	EntityAddComponent2(entity, "SpriteComponent", {
		_enabled=false,
		_tags="enabled_in_hand",
		offset_x=ITEMS[id].offset_x or 4,
		offset_y=ITEMS[id].offset_y or 4,
		image_file=ITEMS[id].inhand,
	})
	EntityAddComponent2(entity, "ItemComponent", {
		_tags="enabled_in_world",
		item_name=ITEMS[id].name,
		auto_pickup=true,
		max_child_items=0,
		is_pickable=true,
		is_equipable_forced=true,
		ui_sprite=ITEMS[id].sprite,
		ui_description=ITEMS[id].desc,
		preferred_inventory="QUICK",
		next_frame_pickable=-999
	})
	EntityAddComponent2(entity, "UIInfoComponent", {
		_tags="enabled_in_world",
		name=ITEMS[id].name,
	})
	EntityAddComponent2(entity, "LuaComponent", {
		_tags="enabled_in_hand,enabled_in_world,enabled_in_inventory",
		execute_on_added=true,
		script_source_file="mods/noiting_simulator/files/items/_pickmeup.lua"
	})
	local ability = EntityAddComponent2(entity, "AbilityComponent", {
		ui_name=ITEMS[id].name,
		throw_as_item=ITEMS[id].throw,
	})
	ComponentObjectSetValue2(ability, "gun_config", "deck_capacity", 0)
	if ITEMS[id].extra_func then ITEMS[id].extra_func(entity) end
	local inv = EntityGetWithName("inventory_quick2") or 0
	if inv == 0 then inv = EntityGetWithName("inventory_quick") end
	EntityAddChild(inv, entity)
end