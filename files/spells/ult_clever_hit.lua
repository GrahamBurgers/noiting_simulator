function DoHit(who_got_hit, types, is_heart, v, x, y)
	if not (is_heart and v) then return end
	local me = GetUpdatedEntityID()
	local comp = EntityGetFirstComponentIncludingDisabled(me, "LuaComponent", "ult_clever")
	local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "character")
	if comp and sprite then
		local count = ComponentGetValue2(comp, "limit_how_many_times_per_frame") + 1
		ComponentSetValue2(comp, "limit_how_many_times_per_frame", count)
		if count == 3 then
			v.tempolevel = v.tempolevel - 1
			ComponentSetValue2(sprite, "rect_animation", "fill_2")
		end
		if count == 6 then
			v.tempolevel = v.tempolevel - 1
			ComponentSetValue2(sprite, "rect_animation", "fill_3")
		end
		if count == 9 then
			v.tempolevel = v.tempolevel - 1
			ComponentSetValue2(sprite, "rect_animation", "fill_4")
		end
		if count == 12 then
			v.tempolevel = v.tempolevel - 1
			ComponentSetValue2(sprite, "rect_animation", "fill_5")
		end
		if count == 15 then
			v.tempolevel = v.tempolevel - 1
			EntityKill(me)
		end
	end
	return v
end