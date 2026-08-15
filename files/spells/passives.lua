function enabled_changed(me, is_enabled)
	if is_enabled then
		EntityAddTag(me, "active_passives") -- where have I heard that before?
	else
		EntityRemoveTag(me, "active_passives")
	end
end