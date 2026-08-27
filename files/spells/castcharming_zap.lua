function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it, component_id)
	local me = GetUpdatedEntityID()
	EntityAddTag(me, "charmy_zap")

	local lua = EntityGetFirstComponent(me, "LuaComponent", "castcharming")
	local str = lua and ComponentGetValue2(lua, "script_material_area_checker_success") or ""
	if lua and string.len(str) > 0 then
		local list = EntityGetWithTag(str)
		for i = 1, #list do
			if (list[i] ~= me) and (not EntityHasTag(list[i], "charmy_zap")) then
				local p = EntityGetFirstComponent(list[i], "ParticleEmitterComponent", "quantum")
				local particle_type = p and ComponentGetValue2(p, "emitted_material_name") or "spark_red_transparent"
				x, y = EntityGetTransform(me)
				local x2, y2 = EntityGetTransform(list[i])
				local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
				local dx, dy = x2 - x, y2 - y
				local count = distance * 2
				local time = 5
				for j = 1, count do
					x = x + dx / count
					y = y + dy / count
					time = time + 12 / 60
					GameCreateCosmeticParticle(particle_type, x, y, 1, 0, 0, nil, time / 30, time / 30, true, false, false, false, 0, 0)
				end
				EntityAddComponent2(list[i], "VariableStorageComponent", {
					_tags="hit_this_entity_now",
					value_int=who_got_hit,
				})
				local hi = EntityGetFirstComponent(list[i], "VariableStorageComponent", "charmy_zap")
				if hi then
					EntityRemoveComponent(list[i], hi)
				end
			end
		end
	end
end