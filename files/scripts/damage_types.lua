function ProjHit(proj_entity, projcomp, who, multiplier, x, y, who_did_it)
    if EntityHasTag(who, "heart") then
        DamageHeart(who, {
            cute = ComponentObjectGetValue2(projcomp, "damage_by_type", "melee"),
            charming = ComponentObjectGetValue2(projcomp, "damage_by_type", "slice"),
            clever = ComponentObjectGetValue2(projcomp, "damage_by_type", "fire"),
            comedic = ComponentObjectGetValue2(projcomp, "damage_by_type", "ice"),
        }, multiplier, who_did_it, proj_entity, x, y)
        local fire = EntityGetFirstComponent(proj_entity, "VariableStorageComponent", "fire")
        local on_fire = EntityGetFirstComponent(who, "VariableStorageComponent", "on_fire")
        if fire and on_fire then
            ComponentSetValue2(on_fire, "value_float", ComponentGetValue2(on_fire, "value_float") + ComponentGetValue2(fire, "value_float") * multiplier)
            ComponentSetValue2(on_fire, "value_string", ComponentGetValue2(fire, "value_string"))
        end
    else
        Damage(who, {
            cute = ComponentObjectGetValue2(projcomp, "damage_by_type", "melee"),
            charming = ComponentObjectGetValue2(projcomp, "damage_by_type", "slice"),
            clever = ComponentObjectGetValue2(projcomp, "damage_by_type", "fire"),
            comedic = ComponentObjectGetValue2(projcomp, "damage_by_type", "ice"),
        }, multiplier, who_did_it, proj_entity, x, y)
    end
end

function Damage(who, types, multiplier, who_did_it, proj_entity, x, y, do_percent_damage)
    local dmg = EntityGetFirstComponent(who, "DamageModelComponent")
    if dmg and do_percent_damage then
        types.cute = types.cute and (ComponentGetValue2(dmg, "max_hp") * types.cute / 25) or 0
        types.charming = types.charming and (ComponentGetValue2(dmg, "max_hp") * types.charming / 25) or 0
        types.clever = types.clever and (ComponentGetValue2(dmg, "max_hp") * types.clever / 25) or 0
        types.comedic = types.comedic and (ComponentGetValue2(dmg, "max_hp") * types.comedic / 25) or 0
    end
    local cute = (types.cute or 0) * multiplier
    if cute > 0 then -------- CUTE --------
        EntityInflictDamage(who, cute, "DAMAGE_PROJECTILE", "$inventory_dmg_melee", "NORMAL", 0, 0, who_did_it)
    end
    local charming = (types.charming or 0) * multiplier
    if charming > 0 then -------- CHARMING --------
        EntityInflictDamage(who, charming, "DAMAGE_PROJECTILE", "$inventory_dmg_slice", "NORMAL", 0, 0, who_did_it)
    end
    local clever = (types.clever or 0) * multiplier
    if clever > 0 then -------- CLEVER --------
        EntityInflictDamage(who, clever, "DAMAGE_PROJECTILE", "$inventory_dmg_fire", "NORMAL", 0, 0, who_did_it)
    end
    local comedic = (types.comedic or 0) * multiplier
    if comedic > 0 then -------- COMEDIC --------
        EntityInflictDamage(who, comedic, "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NORMAL", 0, 0, who_did_it)

        if who_did_it and who_did_it > 0 and not (proj_entity and EntityHasTag(proj_entity, "comedic_noheal")) then
            EntityInflictDamage(who_did_it, comedic * -1, "DAMAGE_HEALING", "$inventory_dmg_healing", "NORMAL", 0, 0, who_did_it)
            local x2, y2 = EntityGetTransform(who_did_it)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal_silent.xml", x, y)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x2, y2)
            if proj_entity then -- disable comedic effects
                EntityAddTag(proj_entity, "comedic_noheal")
                EntityAddTag(proj_entity, "comedic_nohurt")
            end
        end
    end
end

function DamageHeart(who, types, multiplier, who_did_it, proj_entity, x, y, do_percent_damage)
    local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
    if not (string.len(storage) > 0) then return end
    local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
    local v = smallfolk.loads(storage)

    multiplier = (multiplier or 1)
    if do_percent_damage then
        types.cute = types.cute and (v.guardmax * types.cute / 25) or 0
        types.charming = types.charming and (v.guardmax * types.charming / 25) or 0
        types.clever = types.clever and (v.guardmax * types.clever / 25) or 0
        types.comedic = types.comedic and (v.guardmax * types.comedic / 25) or 0
    end
    local cute = (types.cute or 0) * multiplier * v.charming_boost * v.cute
    if cute > 0 then -------- CUTE --------
        EntityInflictDamage(who, cute, "DAMAGE_PROJECTILE", "$inventory_dmg_melee", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - cute * 25)
        v.charming_boost = math.max(1, v.charming_boost - (cute * 0.25))
        v.tempo = math.min(v.tempomax, v.tempo + cute / 2)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)
    end
    local charming = (types.charming or 0) * multiplier * v.charming
    if charming > 0 then -------- CHARMING --------
        EntityInflictDamage(who, charming, "DAMAGE_PROJECTILE", "$inventory_dmg_slice", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - charming * 25)
        v.charming_boost = math.min(2, v.charming_boost + (charming * 0.25))
        v.tempo = math.min(v.tempomax, v.tempo + charming / 2)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)
    end
    local clever = (types.clever or 0) * multiplier * v.charming_boost * v.clever
    if clever > 0 then -------- CLEVER --------
        EntityInflictDamage(who, clever, "DAMAGE_PROJECTILE", "$inventory_dmg_fire", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - clever * 25)
        v.charming_boost = math.max(1, v.charming_boost - (clever * 0.25))
        v.tempo = math.max(0, v.tempo - clever)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)
    end
    local comedic = (types.comedic or 0) * multiplier * v.charming_boost * v.comedic
    if comedic > 0 then -------- COMEDIC --------
        EntityInflictDamage(who, comedic, "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - comedic * 25)
        v.charming_boost = math.max(1, v.charming_boost - (comedic * 0.25))
        v.tempo = math.min(v.tempomax, v.tempo + comedic / 2)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)

        if who_did_it and who_did_it > 0 and not (proj_entity and EntityHasTag(proj_entity, "comedic_noheal")) then
            EntityInflictDamage(who_did_it, comedic * -1, "DAMAGE_HEALING", "$inventory_dmg_healing", "NORMAL", 0, 0, who_did_it)
            local x2, y2 = EntityGetTransform(who_did_it)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal_silent.xml", x, y)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x2, y2)
            if proj_entity then -- disable comedic effects
                EntityAddTag(proj_entity, "comedic_noheal")
                EntityAddTag(proj_entity, "comedic_nohurt")
            end
        end
    end

    GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
end