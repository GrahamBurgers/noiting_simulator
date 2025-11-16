gamble_list = {}
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
        id = "TREASURE",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
        end
    },
    {
        id = "DOUBLE",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
            -- see data/scripts/perks/perk_pickup.lua
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
            SetRandomSeed(entity_perk_item + GameGetFrameNum(), 2049205 + entity_who_picked)
            local x, y = EntityGetTransform(entity_who_picked)
            local print_string = "Rolled: "
            local count = Random(1, 3)
            while count > 0 do
                local pid = perk_spawn(x, y, gamble_list[Random(1, #gamble_list)])
                perk_pickup(pid, entity_who_picked, "", false, false)
                count = count - 1
                local ui = pid and EntityGetFirstComponent(pid, "UIInfoComponent")
                if ui then
                    print_string = print_string .. GameTextGet(ComponentGetValue2(ui, "name"))
                    if count > 0 then print_string = print_string .. ", " end
                end
            end
            GamePrint(print_string)
        end
    },
    {
        id = "SPARKLES",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
            -- see files/scripts/player_damage_received.lua
        end
    },
    {
        id = "BURNING",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
            -- see files/spells/_base.lua and files/battles/heart.lua
        end
    },
    {
        id = "REGEN",
        func = function(entity_perk_item, entity_who_picked, item_name, pickup_count)
            -- see files/battles/heart.lua
        end
    },
}

for i = 1, #perk_list do
    local id = string.lower(perk_list[i].id)
    perk_list[i].ui_name = "$name_ns_" .. id
    perk_list[i].ui_description = "$desc_ns_" .. id
    perk_list[i].perk_icon = "mods/noiting_simulator/files/perks/" .. id .. ".png"
    perk_list[i].ui_icon = "mods/noiting_simulator/files/perks/" .. id .. "_ui.png"
    if perk_list[i].id ~= "GAMBLE" then
        gamble_list[#gamble_list+1] = perk_list[i].id
    end
end