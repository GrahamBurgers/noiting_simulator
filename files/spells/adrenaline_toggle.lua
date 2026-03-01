function enabled_changed(me, is_enabled)
	if is_enabled then
		EntityAddTag(me, "active_adrenaline")
	else
		GlobalsSetValue("SPELL_ADRENALINE_ACTIVE", "FALSE")
		EntityRemoveTag(me, "active_adrenaline")
	end
end