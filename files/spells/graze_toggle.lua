function enabled_changed(me, is_enabled)
	if is_enabled then
		EntityAddTag(me, "active_graze")
	else
		EntityRemoveTag(me, "active_graze")
	end
end