function portal_teleport_used(entity_that_was_teleported, from_x, from_y, to_x, to_y)
	local me = GetUpdatedEntityID()
	dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
	StartBattle(EntityGetName(me), true)

	local dummy = EntityGetWithName("dummy")
	if dummy and dummy > 0 then EntityKill(dummy) end
	EntityKill(me)
	dofile_once("mods/noiting_simulator/files/items/_list.lua")
	CollectItems()
	local collect = EntityGetWithTag("card_action")
	for i = 1, #collect do
		if not EntityHasTag(EntityGetParent(collect[i]), "wand") then
			EntityAddTag(collect[i], "collect_me")
		end
	end
end