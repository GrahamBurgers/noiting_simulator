function enabled_changed(me, is_enabled)
	local x, y = EntityGetTransform(me)
	local player = EntityGetClosestWithTag(x, y, "player_unit")
	local plat = player and EntityGetFirstComponent(player, "CharacterPlatformingComponent")
	if plat then
		ComponentSetValue2(plat, "pixel_gravity", 350)
	end
end