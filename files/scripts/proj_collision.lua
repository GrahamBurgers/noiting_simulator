return function(circle_size, target_entity, ignore_collision)
    local px, py = EntityGetTransform(GetUpdatedEntityID())
    local x, y = EntityGetTransform(target_entity)
    x = x or px
    y = y or py
    local distance = math.sqrt((x - px)^2 + (y - py)^2)
    if distance and distance > 0 then
        local direction = math.pi - math.atan2((y - py), (x - px))
        local circle_hitbox = EntityGetFirstComponent(target_entity, "VariableStorageComponent", "hitbox")
        if circle_hitbox then
            circle_size = circle_size * (1 / 1.5) -- DANGEROUS!!!
            local rx = px + -math.cos(direction) * circle_size
            local ry = py + math.sin(direction) * circle_size
            local size = ComponentGetValue2(circle_hitbox, "value_float")
            return distance <= circle_size + size and ((not RaytracePlatforms(px, py, rx, ry)) or ignore_collision)
        end
        local rectangle_hitbox = EntityGetFirstComponent(target_entity, "HitboxComponent")
        if rectangle_hitbox then
            local min_x = x + ComponentGetValue2(rectangle_hitbox, "aabb_min_x")
            local max_x = x + ComponentGetValue2(rectangle_hitbox, "aabb_max_x")
            local min_y = y + ComponentGetValue2(rectangle_hitbox, "aabb_min_y")
            local max_y = y + ComponentGetValue2(rectangle_hitbox, "aabb_max_y")
            local magnitude = math.min(circle_size, distance)
            local rx = px + -math.cos(direction) * magnitude
            local ry = py + math.sin(direction) * magnitude
            return (rx >= min_x and rx <= max_x and ry >= min_y and ry <= max_y) and ((not RaytracePlatforms(px, py, rx, ry)) or ignore_collision)
        end
    end
    return false
end