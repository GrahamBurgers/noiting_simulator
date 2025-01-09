function shot( entity )
    local proj = EntityGetFirstComponent(entity, "ProjectileComponent")
    if proj then
        ComponentSetValue2(proj, "spawn_entity", "mods/noiting_simulator/files/items/capes/amp_effect.xml")
        ComponentSetValue2(proj, "spawn_entity_is_projectile", true)
    end
end