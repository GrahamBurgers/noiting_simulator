function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	local things = EntityGetWithTag("active_banter") or {}
	if entity_thats_responsible ~= GetUpdatedEntityID() then
		for i = 1, #things do
			local bar = EntityGetFirstComponentIncludingDisabled(things[i], "SpriteComponent", "banter_bar")
			if bar then
				local thing = math.max(1, ComponentGetValue2(bar, "special_scale_x")) + 0.25
				ComponentSetValue2(bar, "special_scale_x", thing)
			end
		end
	end
end