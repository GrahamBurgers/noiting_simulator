function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
    local me = GetUpdatedEntityID()
    local dmg = EntityGetFirstComponent(me, "DamageModelComponent")
    if dmg --[[and GlobalsGetValue("NS_IN_BATTLE", "0") == "1" ]] then
        local hp = ComponentGetValue2(dmg, "hp")
        local max_hp = ComponentGetValue2(dmg, "max_hp")

        if hp - damage <= 0 then
            local stamina = tonumber(GlobalsGetValue("NS_STAMINA_VALUE", "3"))
            local stam_max = tonumber(GlobalsGetValue("NS_STAMINA_MAX", "5"))
            local temp = tonumber(GlobalsGetValue("NS_STAMINA_TEMP", "2"))

            if temp > 0 then
                GlobalsSetValue("NS_STAMINA_FLASH", "12")
                GlobalsSetValue("NS_STAMINA_TEMP", tostring(temp - 1))
                ComponentSetValue2(dmg, "hp", max_hp)
            elseif stamina > 0 then
                GlobalsSetValue("NS_STAMINA_FLASH", "12")
                GlobalsSetValue("NS_STAMINA_VALUE", tostring(stamina - 1))
                ComponentSetValue2(dmg, "hp", max_hp)
            end
        end

        -- sparkles perk
        local sparkles = tonumber(GlobalsGetValue("PERK_PICKED_SPARKLES_PICKUP_COUNT", "0")) or 0
        if sparkles > 0 and damage > 0 then
            local chance = sparkles * 10
            SetRandomSeed(me + GameGetFrameNum(), damage + 389508)
            if Random(1, 100) <= chance then
                dofile_once("data/scripts/lib/utilities.lua")

                local x, y = EntityGetTransform(me)
                local how_many = math.max(1, math.ceil(damage * 20)) + sparkles
                local angle_inc = (2 * math.pi) / how_many
                local theta = Random(-math.pi, math.pi)

                for q = 1, how_many do
                    local speed = Random(50, 300)
                    local add = Random(-200, 200) / 100
                    local vel_x = math.cos(theta + add) * speed
                    local vel_y = math.sin(theta + add) * speed
                    theta = theta + angle_inc
                    shoot_projectile(me, "mods/noiting_simulator/files/spells/sparkle.xml", x + vel_x / 120, y + vel_y / 120, vel_x, vel_y)
                end
            end
        end
    end
end