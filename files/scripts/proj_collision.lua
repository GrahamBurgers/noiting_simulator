return function(circle_size, target_entity, ignore_collision)
    local px, py = EntityGetTransform(GetUpdatedEntityID())
    local x, y = EntityGetTransform(target_entity)

    x = x or px
    y = y or py
    local dx = x - px
    local dy = y - py
    local distance = math.sqrt(dx * dx + dy * dy)

	local circle_hitbox = EntityGetFirstComponent(target_entity, "VariableStorageComponent", "hitbox")
	local proj_hitbox = EntityGetFirstComponent(target_entity, "ProjectileComponent")

	local radius = (circle_hitbox and ComponentGetValue2(circle_hitbox, "value_float"))
		or (proj_hitbox and ComponentGetValue2(proj_hitbox, "blood_count_multiplier"))

	if radius then
		local first_contact = circle_size + radius
		local full_engulf = math.abs(circle_size - radius)

		if distance <= first_contact then
			local range = first_contact - full_engulf

			local penetration = 1
			if range > 0 then
				penetration = (first_contact - distance) / range
			end

			penetration = math.max(0, math.min(1, penetration))

			if ignore_collision or not RaytracePlatforms(px, py, x, y) then
				return true, penetration
			end
		end

		return false, 0
	end

    local rectangle_hitbox = EntityGetFirstComponent(target_entity, "HitboxComponent")

    if rectangle_hitbox then
        local min_x = x + ComponentGetValue2(rectangle_hitbox, "aabb_min_x")
        local max_x = x + ComponentGetValue2(rectangle_hitbox, "aabb_max_x")
        local min_y = y + ComponentGetValue2(rectangle_hitbox, "aabb_min_y")
        local max_y = y + ComponentGetValue2(rectangle_hitbox, "aabb_max_y")

        local closest_x = math.max(min_x, math.min(px, max_x))
        local closest_y = math.max(min_y, math.min(py, max_y))

        local cdx = px - closest_x
        local cdy = py - closest_y

        local closest_distance = math.sqrt(cdx * cdx + cdy * cdy)

        if closest_distance <= circle_size then
            local penetration

            if px < min_x or px > max_x or py < min_y or py > max_y then
                penetration = 1 - (closest_distance / circle_size)
            else
                local left   = px - min_x
                local right  = max_x - px
                local top    = py - min_y
                local bottom = max_y - py

                local nearest_edge = math.min(left, right, top, bottom)

                local half_width = (max_x - min_x) * 0.5
                local half_height = (max_y - min_y) * 0.5
                local max_inside = math.min(half_width, half_height)

                if max_inside <= 0 then
                    penetration = 1
                else
                    penetration = nearest_edge / max_inside
                end
            end

            penetration = math.max(0, math.min(1, penetration))

            if ignore_collision or not RaytracePlatforms(px, py, closest_x, closest_y) then
                return true, penetration
            end
        end

        return false, 0
    end

    return false, 0
end