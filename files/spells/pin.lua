function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it, component_id, proj_entity)
	if not is_heart then return end
	local add = ComponentGetValue2(component_id, "value_int")
	ComponentSetValue2(component_id, "value_int", add * 0.75)
	local pin = EntityGetFirstComponent(who_got_hit, "LuaComponent", "pin")
	if not pin then
		pin = EntityAddComponent2(who_got_hit, "LuaComponent", {
			_tags="pin",
			script_source_file="mods/noiting_simulator/files/spells/pin_bounce.lua",
			script_electricity_receiver_electrified="0",
		})
		local p = EntityAddComponent2(who_got_hit, "ParticleEmitterComponent", {
			_tags="pin",
			render_on_grid=true,
			cosmetic_force_create=true,
			count_min=6,
			count_max=6,
			custom_alpha=0.3,
			draw_as_long=false,
			emission_interval_min_frames=1,
			emission_interval_max_frames=1,
			emit_cosmetic_particles=true,
			emit_only_if_there_is_space=false,
			emit_real_particles=false,
			emitted_material_name="spark_yellow",
			fade_based_on_lifetime=false,
			fire_cells_dont_ignite_damagemodel=false,
			is_emitting=true,
			is_trail=false,
			lifetime_min=5/60,
			lifetime_max=5/60,
			particle_single_width=true,
			render_back=false,
			x_pos_offset_min=0,
			x_pos_offset_max=0,
			y_pos_offset_min=0,
			y_pos_offset_max=0,
			velocity_always_away_from_center=0,
			friction=0,
		})
		ComponentSetValue2(p, "gravity", 0, 0)
	end
	local frames = ComponentGetValue2(pin, "script_electricity_receiver_electrified")
	ComponentSetValue2(pin, "script_electricity_receiver_electrified", tostring(tonumber(frames) + add))
end