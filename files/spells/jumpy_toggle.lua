function enabled_changed(me, is_enabled)
	if is_enabled then
		EntityAddTag(me, "active_jumpy")
	else
		GlobalsSetValue("SPELL_JUMPY_ACTIVE", "FALSE")
		EntityRemoveTag(me, "active_jumpy")
	end
end