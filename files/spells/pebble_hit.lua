function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it, component_id, proj_entity)
	local things = EntityGetWithTag("active_pebble") or {}
	for i = 1, #things do
		local bar = EntityGetFirstComponentIncludingDisabled(things[i], "SpriteComponent", "pebble_bar")
		if bar then
			local thing = math.max(1, ComponentGetValue2(bar, "special_scale_x")) + 0.25
			ComponentSetValue2(bar, "special_scale_x", thing)
		end
	end
end