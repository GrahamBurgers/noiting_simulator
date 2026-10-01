function enabled_changed(me, is_enabled)
	if is_enabled then
		EntityAddTag(me, "active_banter")
	else
		EntityRemoveTag(me, "active_banter")

		GlobalsSetValue("SPELL_BANTER_ACTIVE", "0")
	end
end