function enabled_changed(me, is_enabled)
	local target_player = EntityGetRootEntity(me)
	local c = target_player and EntityGetFirstComponentIncludingDisabled(target_player, "CharacterPlatformingComponent")
	if not c then return end

    local boost = 1.25
	if not is_enabled then boost = 1 / boost end
	ComponentSetValue2(c, "velocity_min_x", ComponentGetValue2(c, "velocity_min_x") * boost)
	ComponentSetValue2(c, "velocity_max_x", ComponentGetValue2(c, "velocity_max_x") * boost)
	ComponentSetValue2(c, "jump_velocity_x", ComponentGetValue2(c, "jump_velocity_x") * boost)
	ComponentSetValue2(c, "fly_velocity_x", ComponentGetValue2(c, "fly_velocity_x") * boost)
	ComponentSetValue2(c, "accel_x", ComponentGetValue2(c, "accel_x") / boost)
	ComponentSetValue2(c, "accel_x_air", ComponentGetValue2(c, "accel_x_air") / boost)
end