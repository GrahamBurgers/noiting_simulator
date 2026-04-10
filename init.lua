local translation_updater = dofile_once("mods/noiting_simulator/files/scripts/translation_updater.lua") --[[@as TranlationUpdater]]

translation_updater.update_translations()

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noiting_simulator/files/spells/__gun_actions.lua")
-- ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noiting_simulator/files/perks/_perk_list.lua")
AddFlagPersistent("perk_picked_ns_achievement_thingy") -- remove later
ModTextFileSetContent("data/scripts/magic/amulet.lua", [[print("no hat")]])

-- Fix spell charges desyncing from the card. Goddamn
local gun = ModTextFileGetContent("data/scripts/gun/gun.lua")
gun = gun:gsub([[elseif action.is_identified then]],
[[elseif action.is_identified then
local x, y = EntityGetTransform%(GetUpdatedEntityID%(%)%)
local cards = EntityGetWithTag%("card_action"%) or {}
for i = 1, #cards do
	local item = EntityGetFirstComponentIncludingDisabled%(cards[i], "ItemComponent"%)
	if item and ComponentGetValue2%(item, "mItemUid"%) == action.inventoryitem_id then
		action.uses_remaining = ComponentGetValue2%(item, "uses_remaining"%)
		break
	end
end
]])
ModTextFileSetContent("data/scripts/gun/gun.lua", gun)

local function getsetgo(entity, comp, name, value, object)
	if not EntityGetIsAlive(entity) then return end
	local c = EntityGetFirstComponentIncludingDisabled(entity, comp)
	if c then
		if object then
			ComponentObjectSetValue2(c, name, value, object)
		elseif name == "_enabled" then
			EntitySetComponentIsEnabled(entity, c, value)
		else
			ComponentSetValue2(c, name, value)
		end
	end
end

--[[i wish this worked
function OnModPreInit()
	-- KILL other mods
	local mods = ModGetActiveModIDs() or {}
	for i = 1, #mods do
		if mods[i] ~= "noiting_simulator" then
			ModTextFileSetContent("mods/" .. mods[i] .. "/init.lua", "print(\"" .. (mods[i] .. " has been DESTROYED") .. ")\"")
		end
	end
end
]]--

function OnPlayerSpawned(player_id)
	if not GameHasFlagRun("NOITING_SIM_INIT") then
		GameAddFlagRun("NOITING_SIM_INIT")
		-- base player modifications
		getsetgo(player_id, "SpriteStainsComponent", "_enabled", false)
		getsetgo(player_id, "DamageModelComponent",  "air_needed", false)
		getsetgo(player_id, "DamageModelComponent", "materials_damage", false)
		getsetgo(player_id, "DamageModelComponent", "damage_multipliers", "explosion", 1.0)
		getsetgo(player_id, "DamageModelComponent", "damage_multipliers", "holy", 1.0)
		getsetgo(player_id, "DamageModelComponent", "blood_multiplier", 0)
		getsetgo(player_id, "DamageModelComponent", "fire_probability_of_ignition", 0)
		getsetgo(player_id, "LightComponent", "radius", 150)
		getsetgo(player_id, "SpriteComponent", "image_file", "mods/noiting_simulator/files/player.xml")
		-- getsetgo(player_id, "PlatformShooterPlayerComponent", "center_camera_on_this_entity", false)
		-- getsetgo(player_id, "PlatformShooterPlayerComponent", "move_camera_with_aim", false)
		getsetgo(player_id, "PlatformShooterPlayerComponent", "eating_delay_frames", 99999999) -- holding the down button for 19 days straight will let you eat
		getsetgo(player_id, "KickComponent", "can_kick", false)
		local inventory = EntityGetWithName("inventory_quick")
		local c = EntityGetAllChildren(inventory) or {}
		if false then -- TODO REMOVE
			for i = 1, #c do
				EntityKill(c[i])
			end
		end
		-- create text handler
		local child = EntityCreateNew()
		EntitySetName(child, "ns_text_handler")
		EntityAddChild(GameGetWorldStateEntity(), child)
		EntityAddComponent2(child, "LuaComponent", {
			_tags="noiting_simulator",
			script_source_file="mods/noiting_simulator/files/scripts/gui_render.lua",
			script_inhaled_material="", -- scene file
			script_throw_item="1", -- scene line number
			script_material_area_checker_failed="0", -- current character number
			script_material_area_checker_success="main", -- current text track
		})
		EntityAddComponent2(player_id, "LuaComponent", {
			script_source_file="mods/noiting_simulator/files/scripts/player.lua",
		})
		EntityAddComponent2(player_id, "LuaComponent", {
			execute_every_n_frame=-1,
			script_damage_received="mods/noiting_simulator/files/scripts/player_damage_received.lua",
			script_damage_about_to_be_received="mods/noiting_simulator/files/scripts/player_damage_about_to_be_received.lua",
		})
		dofile_once("mods/noiting_simulator/files/scripts/gui_text.lua")
		SetScene("mods/noiting_simulator/files/scenes/intro.lua", 1)
		local entity_id = EntityCreateNew()
		EntityAddComponent2(entity_id, "GameEffectComponent", {effect="PROTECTION_POLYMORPH", frames=-1})
		EntityAddComponent2(entity_id, "GameEffectComponent", {effect="REMOVE_FOG_OF_WAR", frames=-1})
		EntityAddChild(player_id, entity_id)

		GlobalsSetValue("NS_IN_BATTLE", "0")
		dofile_once("mods/noiting_simulator/files/scripts/time.lua")

		GlobalsSetValue("COMEDIC_HEAL_FACTOR", "0.5")
		GlobalsSetValue("COMEDIC_HURT_FACTOR", "0.5")
		GlobalsSetValue("CUTE_CRIT_FACTOR", "1")
		GlobalsSetValue("NS_BOX_FREE", "GOGOGO")
		OnGameStart()
	end
end

function OnPausedChanged(is_paused, is_inventory_pause)
	-- update pronouns on unpause
	ModSettingSet("noiting_simulator.RELOAD", (ModSettingGet("noiting_simulator.RELOAD") or 0) + 1)
	local spells = dofile_once("mods/noiting_simulator/files/spells/__gun_list.lua")

	local categories = {"CUTE", "CHARMING", "CLEVER", "COMEDIC", "TYPELESS"}
	local action_types = {
		mods = ACTION_TYPE_MODIFIER,
		projs = ACTION_TYPE_PROJECTILE,
		passive = ACTION_TYPE_PASSIVE,
		utility = ACTION_TYPE_UTILITY,
	}

	local stats = {}
	for _, cat in ipairs(categories) do
		stats[cat] = {total = 0}
		for type_name in pairs(action_types) do
			stats[cat][type_name] = 0
		end
	end

	for i = 1, #spells do
		local cat = spells[i].ns_category
		local spell_type = spells[i].type

		if stats[cat] then
			stats[cat].total = stats[cat].total + 1
			for type_name, type_val in pairs(action_types) do
				if spell_type == type_val then
					stats[cat][type_name] = stats[cat][type_name] + 1
				end
			end
		end
	end

	for _, cat in ipairs(categories) do
		print(string.format("%-8s: %2d, projs: %2d, mods: %2d, passive: %2d, utility: %2d",
			cat, stats[cat].total, stats[cat].projs, stats[cat].mods, stats[cat].passive, stats[cat].utility))
	end
	print("TOTAL	: " .. tostring(#spells))
end
