function portal_teleport_used(entity_that_was_teleported, from_x, from_y, to_x, to_y)
	local me = GetUpdatedEntityID()
	dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
	StartBattle(EntityGetName(me), true)

	local dummy = EntityGetWithName("dummy")
	if dummy and dummy > 0 then EntityKill(dummy) end
	local reroll_station = EntityGetWithName("reroll_station")
	if reroll_station and reroll_station > 0 then EntityKill(reroll_station) end
	EntityKill(me)
	dofile_once("mods/noiting_simulator/files/items/_list.lua")
	CollectItems()
	CollectSpells(false, false)
	dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
	SafeKillAllProjectiles()
end