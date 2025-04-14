function Damage(projcomp, who, multiplier)
    multiplier = (multiplier or 1)
    local who_did_it = ComponentGetValue2(projcomp, "mWhoShot")
    local dmg_cute = ComponentObjectGetValue2(projcomp, "damage_by_type", "melee") * multiplier
    if dmg_cute > 0 then
        EntityInflictDamage(who, dmg_cute, "DAMAGE_MELEE", "$inventory_dmg_melee", "NORMAL", 0, 0, who_did_it)
    end
    local dmg_charming = ComponentObjectGetValue2(projcomp, "damage_by_type", "slice") * multiplier
    if dmg_charming > 0 then
        EntityInflictDamage(who, dmg_charming, "DAMAGE_SLICE", "$inventory_dmg_slice", "NORMAL", 0, 0, who_did_it)
    end
    local dmg_clever = ComponentObjectGetValue2(projcomp, "damage_by_type", "drill") * multiplier
    if dmg_clever > 0 then
        EntityInflictDamage(who, dmg_clever, "DAMAGE_DRILL", "$inventory_dmg_drill", "NORMAL", 0, 0, who_did_it)
    end
    local dmg_comedic = ComponentObjectGetValue2(projcomp, "damage_by_type", "ice") * multiplier
    if dmg_comedic > 0 then
        EntityInflictDamage(who, dmg_comedic, "DAMAGE_ICE", "$inventory_dmg_ice", "NORMAL", 0, 0, who_did_it)
    end
end