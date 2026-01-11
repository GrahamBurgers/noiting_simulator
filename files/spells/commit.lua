function enabled_changed(me, is_enabled)
	local multiplier = 1.5
	if not is_enabled then multiplier = 1 / multiplier end
	GlobalsSetValue("COMEDIC_HEAL_FACTOR", tostring(multiplier * tonumber(GlobalsGetValue("COMEDIC_HEAL_FACTOR", "0.5"))))
	GlobalsSetValue("COMEDIC_HURT_FACTOR", tostring(multiplier * tonumber(GlobalsGetValue("COMEDIC_HURT_FACTOR", "0.5"))))
end