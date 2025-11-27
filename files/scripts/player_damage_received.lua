function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
    local me = GetUpdatedEntityID()
    local storage = EntityGetFirstComponent(me, "VariableStorageComponent", "wheel")
    if storage and damage > 0 then
        ComponentSetValue2(storage, "value_float", ComponentGetValue2(storage, "value_float") + damage)
    end
end