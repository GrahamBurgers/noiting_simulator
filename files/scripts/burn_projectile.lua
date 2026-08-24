function Add_burn(projectile, type, amount, x_offset, y_offset, also_do_a_poof)
	x_offset = x_offset or -1
	y_offset = y_offset or -2
    if type and amount > 0 then
        -- note that this uses the darkest color of the palette
        local color = (type == "CUTE" and -4101426) or
            (type == "CHARMING" and -12544322) or
            (type == "CLEVER" and -3832712) or
            (type == "COMEDIC" and -9854150) or
            (type == "TYPELESS" and 13685968)
        local child = (EntityGetAllChildren(projectile, "fire_child") or {})[1]
        local fire = EntityGetFirstComponentIncludingDisabled(projectile, "VariableStorageComponent", "fire")
        if fire and child then
            ComponentSetValue2(fire, "value_string", type)
            ComponentSetValue2(fire, "value_float", ComponentGetValue2(fire, "value_float") + amount)
            local particles = EntityGetFirstComponentIncludingDisabled(child, "ParticleEmitterComponent", "fire")
            if particles then ComponentSetValue2(particles, "color", color) end
        else
            EntityAddComponent2(projectile, "VariableStorageComponent", {
                _tags="fire",
                value_string=type,
                value_float=amount,
            })
            child = EntityCreateNew()
            EntityAddTag(child, "fire_child")
            EntityAddComponent2(child, "InheritTransformComponent", {only_position=true})
            EntityAddComponent2(child, "ParticleEmitterComponent", {
                _tags="fire",
                emitted_material_name="smoke",
                custom_style="FIRE",
                x_pos_offset_min=x_offset,
                x_pos_offset_max=x_offset,
                y_pos_offset_min=y_offset,
                y_pos_offset_max=y_offset,
                x_vel_min=-2,
                x_vel_max=2,
                y_vel_min=-20,
                y_vel_max=-10,
                count_min=1,
                count_max=1,
                color_is_based_on_pos=false,
                lifetime_min=0.3,
                lifetime_max=0.4,
                create_real_particles=false,
				is_trail=true,
                emit_cosmetic_particles=true,
                emission_interval_min_frames=1,
                emission_interval_max_frames=1,
                color = color
            })
            EntityAddChild(projectile, child)
        end
		if also_do_a_poof then
			local p = EntityAddComponent2(child, "ParticleEmitterComponent", {
				_tags="fire",
				emitted_material_name="smoke",
				custom_style="FIRE",
				x_pos_offset_min=0,
				x_pos_offset_max=0,
				y_pos_offset_min=0,
				y_pos_offset_max=0,
				velocity_always_away_from_center = 70,
				collide_with_grid=false,
				x_vel_min=-3,
				x_vel_max=3,
				y_vel_min=-3,
				y_vel_max=3,
				count_min=6,
				count_max=12,
				color_is_based_on_pos=false,
				lifetime_min=0.1,
				lifetime_max=0.1,
				friction=3,
				create_real_particles=false,
				emit_cosmetic_particles=true,
				emission_interval_min_frames=1,
				emission_interval_max_frames=1,
				color = color,
				emitter_lifetime_frames=2,
			})
			ComponentSetValue2(p, "area_circle_radius", 0.1, 0.1)
		end
    end
end