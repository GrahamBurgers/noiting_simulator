function enabled_changed(me, is_enabled)
	local target_player = EntityGetRootEntity(me)
	local dmg = target_player and EntityGetFirstComponent(target_player, "DamageModelComponent")
	if not dmg then return end
	ComponentSetValue2(dmg, "max_hp", ComponentGetValue2(dmg, "max_hp") + (is_enabled and 1 or -1))
end