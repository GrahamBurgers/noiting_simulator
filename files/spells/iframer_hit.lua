function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it, component_id, proj_entity)
	local me = (proj_entity and EntityGetIsAlive(proj_entity) and proj_entity) or GetUpdatedEntityID()
	if EntityHasTag(me, "iframer_hit") then return end
	if not EntityHasTag(who_did_it, "player_unit") then return end
	if #EntityGetAllChildren(who_did_it, "iframer_inv") > 0 then return end
	EntityAddTag(me, "iframer_hit")
	local starshield = EntityGetFirstComponentIncludingDisabled(who_did_it, "ParticleEmitterComponent", "starshield")
	local starlua = EntityGetFirstComponentIncludingDisabled(who_did_it, "LuaComponent", "starshield")
	local current = "mods/noiting_simulator/files/spells/explosions/star_shield1.png"
	if starshield then
		current = ComponentGetValue2(starshield, "image_animation_file")
		EntityRemoveComponent(who_did_it, starshield)
		current = current:gsub("star_shield4", "star_shield5")
			:gsub("star_shield3", "star_shield4")
			:gsub("star_shield2", "star_shield3")
			:gsub("star_shield1", "star_shield2") -- awesome
	end
	if starlua then EntityRemoveComponent(who_did_it, starlua) end
	local sfx_path = "sfx/" .. current:gsub("mods/noiting_simulator/files/spells/explosions/", ""):gsub(".png", "")
	GamePlaySound("mods/noiting_simulator/files/audio/sfx.bank", sfx_path, x, y)

	local material = "spark_yellow"
	if current == "mods/noiting_simulator/files/spells/explosions/star_shield5.png" then
		LoadGameEffectEntityTo(who_did_it, "mods/noiting_simulator/files/spells/iframer_inv.xml")
		material = "gold"
	end

	starshield = EntityAddComponent2(who_did_it, "ParticleEmitterComponent", {
		_tags="starshield",
		airflow_force=0,
		collide_with_gas_and_fire=false,
		collide_with_grid=false,
		cosmetic_force_create=true,
		count_min=1,
		count_max=1,
		create_real_particles=false,
		custom_alpha=0.4,
		direction_random_deg=0,
		draw_as_long=false,
		emission_chance=100,
		emission_interval_min_frames=1,
		emission_interval_max_frames=1,
		emit_cosmetic_particles=true,
		emit_only_if_there_is_space=false,
		emit_real_particles=false,
		emitted_material_name=material,
		fade_based_on_lifetime=true,
		fire_cells_dont_ignite_damagemodel=true,
		friction=0,
		image_animation_emission_probability=1,
		image_animation_file=current,
		image_animation_loop=true,
		image_animation_raytrace_from_center=false,
		image_animation_speed=1,
		image_animation_use_entity_rotation=false,
		emitter_lifetime_frames=180,
		is_emitting=true,
		is_trail=false,
		lifetime_min=0.05,
		lifetime_max=0.05,
		particle_single_width=true,
		render_back=true,
		render_on_grid=false,
		render_ultrabright=false,
		set_magic_creation=false,
		velocity_always_away_from_center=0,
		x_pos_offset_min=0,
		x_pos_offset_max=0,
		x_vel_min=0,
		x_vel_max=0,
		y_pos_offset_min=-6,
		y_pos_offset_max=-6,
		y_vel_min=0,
		y_vel_max=0,
	})
	ComponentSetValue2(starshield, "gravity", 0, 0)
	EntityAddComponent(who_did_it, "LuaComponent", {
		_tags="starshield",
		script_source_file="mods/noiting_simulator/files/spells/iframer_particles.lua",
		execute_times=180,
	})

end