function portal_teleport_used(entity_that_was_teleported, from_x, from_y, to_x, to_y)
	local me = GetUpdatedEntityID()
	dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
	StartBattle(EntityGetName(me), true)

	local dummy = EntityGetWithName("dummy")
	if dummy and dummy > 0 then EntityKill(dummy) end
	local reroll_station = EntityGetWithName("reroll_station")
	if reroll_station and reroll_station > 0 then EntityKill(reroll_station) end
	EntityAddRandomStains(entity_that_was_teleported, CellFactory_GetType("ns_unstainer"), 999)
	EntityKill(me)
	dofile_once("mods/noiting_simulator/files/items/_list.lua")
	CollectSpells(false, false)
	CollectItems()
	dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
	SafeKillAllProjectiles()
	local invgui = EntityGetFirstComponentIncludingDisabled(entity_that_was_teleported, "InventoryGuiComponent")
	if invgui then ComponentSetValue2(invgui, "mActive", false) end

	local inv = EntityGetWithName("inventory_quick")
	local duplicount = EntityGetWithTag("active_passives")
	local wands = EntityGetIsAlive(inv) and EntityGetAllChildren(inv, "wand") or {}
	for i = 1, #wands do
		local ability = EntityGetFirstComponentIncludingDisabled(wands[i], "AbilityComponent")
		local spells = EntityGetAllChildren(wands[i], "card_action") or {}
		if ability then
			for j = 1, #spells do
				local action = EntityGetFirstComponentIncludingDisabled(spells[j], "ItemActionComponent")
				local sprite = EntityGetFirstComponentIncludingDisabled(spells[j], "SpriteComponent", "item_bg")
				local id = action and ComponentGetValue2(action, "action_id")
				local file = sprite and ComponentGetValue2(sprite, "image_file")
				if id ~= "NS_PASSIVES" and file == "data/ui_gfx/inventory/item_bg_passive.png" then
					for q = 1, #duplicount do -- I LOVE LOOPS!!!!
						ComponentObjectSetValue2(ability, "gun_config", "deck_capacity", ComponentObjectGetValue2(ability, "gun_config", "deck_capacity") + 1)

						local action_entity_id = CreateItemActionEntity(id)
						EntityAddChild(wands[i], action_entity_id)
						EntitySetComponentsWithTagEnabled(action_entity_id, "enabled_in_world", false)
						EntitySetComponentsWithTagEnabled(action_entity_id, "enabled_in_inventory", true)
					end
				end
			end
		end
	end
end