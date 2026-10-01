function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it, component_id, proj_entity)
	local retort_count = tonumber(GlobalsGetValue("RETORT_COUNT", "0")) or 0
	if retort_count >= 35 then
		dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
		Shoot({file = "mods/noiting_simulator/files/spells/retort_shield.xml", whoshot = who_did_it, x = x, y = y, deg_random = 360})
		retort_count = 0
	end
	GlobalsSetValue("RETORT_COUNT", tostring(retort_count + 1))
end