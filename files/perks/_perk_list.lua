perk_list = {
    {
        id = "RETAIN",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)

        end
    },
    {
        id = "SPEED",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
            local boost = 1.2
            local c = EntityGetFirstComponentIncludingDisabled(entity_who_picked, "CharacterPlatformingComponent")
            if c then
                ComponentSetValue2(c, "velocity_min_x", ComponentGetValue2(c, "velocity_min_x") * boost)
                ComponentSetValue2(c, "velocity_max_x", ComponentGetValue2(c, "velocity_max_x") * boost)
                ComponentSetValue2(c, "jump_velocity_x", ComponentGetValue2(c, "jump_velocity_x") * boost)
                ComponentSetValue2(c, "fly_velocity_x", ComponentGetValue2(c, "fly_velocity_x") * boost)
                ComponentSetValue2(c, "accel_x", ComponentGetValue2(c, "accel_x") / boost)
                ComponentSetValue2(c, "accel_x_air", ComponentGetValue2(c, "accel_x_air") / boost)
            end
        end
    },
    {
        id = "CHEST",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
        end
    },
    {
        id = "DOUBLE",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)

        end
    },
    {
        id = "HEALTHY",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
            local boost = 25
            local d = EntityGetFirstComponentIncludingDisabled(entity_who_picked, "DamageModelComponent")
            if d then
                ComponentSetValue2(d, "max_hp", ComponentGetValue2(d, "max_hp") + boost / 25)
            end
        end
    },
    {
        id = "GAMBLE",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
        end
    },
    {
        id = "SPARKLES",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
        end
    },
    {
        id = "BURNING",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
        end
    },
}

for i = 1, #perk_list do
    local id = string.lower(perk_list[i].id)
    perk_list[i].ui_name = "$name_ns_" .. id
    perk_list[i].ui_description = "$desc_ns_" .. id
    perk_list[i].perk_icon = "mods/noiting_simulator/files/perks/" .. id .. ".png"
    perk_list[i].ui_icon = "mods/noiting_simulator/files/perks/" .. id .. "_ui.png"
end