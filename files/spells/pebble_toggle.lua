function enabled_changed(me, is_enabled)
	if is_enabled then
		EntityAddTag(me, "active_pebble")
	else
		EntityRemoveTag(me, "active_pebble")

		GlobalsSetValue("SPELL_PEBBLE_ACTIVE", "0")
	end
end