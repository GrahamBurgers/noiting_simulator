function Damage(projcomp, who, multiplier, x, y, who_did_it)
    local dmg = EntityGetFirstComponent(who, "DamageModelComponent")
    if (not dmg) then return end

    multiplier = (multiplier or 1)
    local dmg_cute = ComponentObjectGetValue2(projcomp, "damage_by_type", "melee") * multiplier * ComponentObjectGetValue2(dmg, "damage_multipliers", "melee")
    if dmg_cute > 0 then
        EntityInflictDamage(who, dmg_cute, "DAMAGE_PROJECTILE", "$inventory_dmg_melee", "NORMAL", 0, 0, who_did_it)
    end
    local dmg_charming = ComponentObjectGetValue2(projcomp, "damage_by_type", "slice") * multiplier * ComponentObjectGetValue2(dmg, "damage_multipliers", "slice")
    if dmg_charming > 0 then
        EntityInflictDamage(who, dmg_charming, "DAMAGE_PROJECTILE", "$inventory_dmg_slice", "NORMAL", 0, 0, who_did_it)
    end
    local dmg_clever = ComponentObjectGetValue2(projcomp, "damage_by_type", "fire") * multiplier * ComponentObjectGetValue2(dmg, "damage_multipliers", "fire")
    if dmg_clever > 0 then
        EntityInflictDamage(who, dmg_clever, "DAMAGE_PROJECTILE", "$inventory_dmg_fire", "NORMAL", 0, 0, who_did_it)
    end
    local dmg_comedic = ComponentObjectGetValue2(projcomp, "damage_by_type", "ice") * multiplier * ComponentObjectGetValue2(dmg, "damage_multipliers", "ice")
    if dmg_comedic > 0 then
        EntityInflictDamage(who, dmg_comedic, "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NORMAL", 0, 0, who_did_it)
        if who_did_it and who_did_it > 0 then
            EntityInflictDamage(who_did_it, dmg_comedic * -1, "DAMAGE_HEALING", "$inventory_dmg_healing", "NORMAL", 0, 0, who_did_it)
            local x2, y2 = EntityGetTransform(who_did_it)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal_silent.xml", x, y)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x2, y2)
        end
    end
end