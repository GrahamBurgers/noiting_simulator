function enabled_changed(me, is_enabled)
	if is_enabled then
		EntityAddTag(me, "active_slam")
	else
		EntityRemoveTag(me, "active_slam")
	end
end