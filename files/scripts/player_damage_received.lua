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
    end
end