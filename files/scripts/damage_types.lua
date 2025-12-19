function CheckDamageNumbers(who, is_heart)
    local dmg = EntityGetFirstComponentIncludingDisabled(who, "DamageModelComponent")
    if dmg then
        if (not ModSettingGet("noiting_simulator.dmg_display_total")) and
        (not EntityHasTag(who, "player_unit")) and
        (ModSettingGet("noiting_simulator.dmg_display") == "always" or
        (ModSettingGet("noiting_simulator.dmg_display") == "only_hearts" and is_heart)) then
            ComponentSetValue2(dmg, "ui_report_damage", false)
        else
            ComponentSetValue2(dmg, "ui_report_damage", true)
        end
    end
end

function MakeDamageNumbers(who, types, is_heart)
    if (not EntityHasTag(who, "player_unit")) and
        (ModSettingGet("noiting_simulator.dmg_display") == "always" or
        (ModSettingGet("noiting_simulator.dmg_display") == "only_hearts" and is_heart)) then
        local x, y = EntityGetTransform(who)
        local typeless = math.floor((types.typeless or 0) * 25 + 0.5)
        local cute = math.floor((types.cute or 0) * 25 + 0.5)
        local charming = math.floor((types.charming or 0) * 25 + 0.5)
        local clever = math.floor((types.clever or 0) * 25 + 0.5)
        local comedic = math.floor((types.comedic or 0) * 25 + 0.5)
        local total = {}
        if typeless > 0 then total[#total+1] = {"mods/noiting_simulator/files/fonts/font_pixel_typeless.xml", typeless, "typeless"} end
        if cute > 0 then total[#total+1] = {"mods/noiting_simulator/files/fonts/font_pixel_cute.xml", cute, "cute"} end
        if charming > 0 then total[#total+1] = {"mods/noiting_simulator/files/fonts/font_pixel_charming.xml", charming, "charming"} end
        if clever > 0 then total[#total+1] = {"mods/noiting_simulator/files/fonts/font_pixel_clever.xml", clever, "clever"} end
        if comedic > 0 then total[#total+1] = {"mods/noiting_simulator/files/fonts/font_pixel_comedic.xml", comedic, "comedic"} end

        if #total > 0 then
            local gui = GuiCreate()
            local turn_deg = math.pi / -2
            if ModSettingGet("noiting_simulator.dmg_display_total") then
                table.insert(total, 1, {"", false})
                turn_deg = turn_deg - math.rad(360 / #total)
            end
            for i = 1, #total do
                if total[i][1] ~= "" then
                    local name = tostring(who) .. total[i][3]
                    local str = total[i][2]
                    local scale = 0.75

                    local existing = EntityGetWithName(name)
                    local sprite = existing and EntityGetFirstComponent(existing, "SpriteComponent", "target")
                    local lua = existing and EntityGetFirstComponent(existing, "LuaComponent", "target")
                    if sprite and lua then
                        -- update our existing floaty text
                        str = tostring(str + tonumber(ComponentGetValue2(sprite, "text")))
                        local w, h = GuiGetTextDimensions(gui, str, scale)
                        ComponentSetValue2(sprite, "text", str)
                        ComponentSetValue2(sprite, "offset_x", w / 2)
                        ComponentSetValue2(sprite, "offset_y", h / 2)
                        EntityRefreshSprite(existing, sprite)
                        ComponentSetValue2(lua, "limit_how_many_times_per_frame", ComponentGetValue2(lua, "mTimesExecuted"))
                        ComponentSetValue2(lua, "script_electricity_receiver_electrified", tostring(total[i][2]))
                    else
                        -- make a new one
                        str = tostring(str)
                        local w, h = GuiGetTextDimensions(gui, str, scale)
                        local text = EntityCreateNew()
                        EntityAddComponent2(text, "SpriteComponent", {
                            _tags="target",
                            image_file=total[i][1],
                            is_text_sprite=true,
                            offset_x=w / 2,
                            offset_y=h / 2,
                            update_transform=true,
                            update_transform_rotation=false,
                            has_special_scale=true,
                            special_scale_x=scale,
                            special_scale_y=scale,
                            text = str,
                            z_index = -99,
                        })
                        EntityAddComponent2(text, "LuaComponent", {
                            _tags="target",
                            execute_on_added=true,
                            script_source_file="mods/noiting_simulator/files/gui/damage_number_custom.lua",
                            limit_how_many_times_per_frame=0,
                            script_material_area_checker_failed=tostring(turn_deg),
                            script_material_area_checker_success=tostring(who),
                            script_electricity_receiver_electrified=tostring(total[i][2])
                        })
                        EntitySetTransform(text, x, y)
                        EntitySetName(text, name)
                        turn_deg = turn_deg - math.rad(360 / #total)
                    end
                end
            end

            GuiDestroy(gui)
        end
    end
end

function ProjHit(proj_entity, projcomp, who, multiplier, x, y, who_did_it)
    if EntityHasTag(who, "heart") then
        DamageHeart(who, {
            cute = ComponentObjectGetValue2(projcomp, "damage_by_type", "melee"),
            charming = ComponentObjectGetValue2(projcomp, "damage_by_type", "slice"),
            clever = ComponentObjectGetValue2(projcomp, "damage_by_type", "fire"),
            comedic = ComponentObjectGetValue2(projcomp, "damage_by_type", "ice"),
            typeless = ComponentObjectGetValue2(projcomp, "damage_by_type", "drill"),
        }, multiplier, who_did_it, proj_entity, x, y)
        local fire = EntityGetFirstComponent(proj_entity, "VariableStorageComponent", "fire")
        local on_fire = EntityGetFirstComponent(who, "VariableStorageComponent", "on_fire")
        if fire and on_fire then
            ComponentSetValue2(on_fire, "value_float", ComponentGetValue2(on_fire, "value_float") + ComponentGetValue2(fire, "value_float") * multiplier)
            ComponentSetValue2(on_fire, "value_string", ComponentGetValue2(fire, "value_string"))
        end
        if ComponentGetValue2(projcomp, "on_collision_die") then EntityKill(proj_entity) end
    elseif EntityHasTag(who, "projectile") then
        DamageProjectile(who, {
            cute = ComponentObjectGetValue2(projcomp, "damage_by_type", "melee"),
            charming = ComponentObjectGetValue2(projcomp, "damage_by_type", "slice"),
            clever = ComponentObjectGetValue2(projcomp, "damage_by_type", "fire"),
            comedic = ComponentObjectGetValue2(projcomp, "damage_by_type", "ice"),
            typeless = ComponentObjectGetValue2(projcomp, "damage_by_type", "drill"),
        }, multiplier, who_did_it, proj_entity, projcomp)
    else
        Damage(who, {
            cute = ComponentObjectGetValue2(projcomp, "damage_by_type", "melee"),
            charming = ComponentObjectGetValue2(projcomp, "damage_by_type", "slice"),
            clever = ComponentObjectGetValue2(projcomp, "damage_by_type", "fire"),
            comedic = ComponentObjectGetValue2(projcomp, "damage_by_type", "ice"),
            typeless = ComponentObjectGetValue2(projcomp, "damage_by_type", "drill"),
        }, multiplier, who_did_it, proj_entity, x, y)
        if ComponentGetValue2(projcomp, "on_collision_die") then EntityKill(proj_entity) end
    end
end

function Damage(who, types, multiplier, who_did_it, proj_entity, x, y, do_percent_damage)
    local dmg = EntityGetFirstComponent(who, "DamageModelComponent")
    if dmg and do_percent_damage then
        local max_hp = ComponentGetValue2(dmg, "max_hp")
        types.cute = types.cute and (max_hp * types.cute / 25) or 0
        types.charming = types.charming and (max_hp * types.charming / 25) or 0
        types.clever = types.clever and (max_hp * types.clever / 25) or 0
        types.comedic = types.comedic and (max_hp * types.comedic / 25) or 0
        types.typeless = types.typeless and (max_hp * types.typeless / 25) or 0
    end
    CheckDamageNumbers(who, false)
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

        if who_did_it and who_did_it > 0 and not (proj_entity and EntityHasTag(proj_entity, "comedic_noheal")) and who_did_it ~= who then
            EntityInflictDamage(who_did_it, comedic * -1, "DAMAGE_HEALING", "$inventory_dmg_healing", "NORMAL", 0, 0, who_did_it)
            local x2, y2 = EntityGetTransform(who_did_it)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal_silent.xml", x, y)
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x2, y2)
            if proj_entity then -- disable comedic effects
                -- EntityAddTag(proj_entity, "comedic_noheal")
                EntityAddTag(proj_entity, "comedic_nohurt")
            end
        end
    end
    local typeless = (types.typeless or 0) * multiplier
    if typeless > 0 then -------- TYPELESS --------
        EntityInflictDamage(who, typeless, "DAMAGE_PROJECTILE", "$inventory_dmg_drill", "NORMAL", 0, 0, who_did_it)
    end
    MakeDamageNumbers(who, {cute = cute, charming = charming, clever = clever, comedic = comedic, typeless = typeless}, false)
end

function DamageProjectile(who, types, multiplier, who_did_it, proj_entity, projcomp, do_percent_damage)
    local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
    if do_percent_damage then
        local max_hp = 50
        types.cute = types.cute and (max_hp * types.cute / 25) or 0
        types.charming = types.charming and (max_hp * types.charming / 25) or 0
        types.clever = types.clever and (max_hp * types.clever / 25) or 0
        types.comedic = types.comedic and (max_hp * types.comedic / 25) or 0
        types.typeless = types.typeless and (max_hp * types.typeless / 25) or 0
    end
    local cute     = (types.cute or 0) * multiplier
    local charming = (types.charming or 0) * multiplier
    local clever   = (types.clever or 0) * multiplier
    local comedic  = (types.comedic or 0) * multiplier
    local typeless = (types.typeless or 0) * multiplier
    local total_defending = cute + charming + clever + comedic + typeless
    cute = cute / total_defending
    charming = charming / total_defending
    clever = clever / total_defending
    comedic = comedic / total_defending
    typeless = typeless / total_defending

    local dmg = EntityGetFirstComponent(who, "ProjectileComponent")
    if (not dmg) or who_did_it == ComponentGetValue2(dmg, "mWhoShot") then return end
    local multiplier2 = q.get_mult_collision(who)
    local cute2     = ComponentObjectGetValue2(dmg, "damage_by_type", "melee") * multiplier2
    local charming2 = ComponentObjectGetValue2(dmg, "damage_by_type", "slice") * multiplier2
    local clever2   = ComponentObjectGetValue2(dmg, "damage_by_type", "fire") * multiplier2
    local comedic2  = ComponentObjectGetValue2(dmg, "damage_by_type", "ice") * multiplier2
    local typeless2 = ComponentObjectGetValue2(dmg, "damage_by_type", "drill") * multiplier2
    local total_attacking = cute2 + charming2 + clever2 + comedic2 + typeless2
    cute2 = cute2 / total_attacking
    charming2 = charming2 / total_attacking
    clever2 = clever2 / total_attacking
    comedic2 = comedic2 / total_attacking
    typeless2 = typeless2 / total_attacking

    if total_defending > total_attacking then
        -- kill attacking projectile, lower defender damage
        total_defending = total_defending - total_attacking
        ComponentObjectSetValue2(projcomp, "damage_by_type", "melee", total_defending * cute)
        ComponentObjectSetValue2(projcomp, "damage_by_type", "slice", total_defending * charming)
        ComponentObjectSetValue2(projcomp, "damage_by_type", "fire", total_defending * clever)
        ComponentObjectSetValue2(projcomp, "damage_by_type", "ice", total_defending * comedic)
        ComponentObjectSetValue2(projcomp, "damage_by_type", "drill", total_defending * typeless)

        EntityKill(who)
        EntityAddTag(who, "comedic_nohurt")
        EntityAddTag(proj_entity, "comedic_nohurt")
    elseif total_attacking > total_defending then
        -- kill defending projectile, lower attacker damage
        total_attacking = total_attacking - total_defending
        ComponentObjectSetValue2(dmg, "damage_by_type", "melee", total_attacking * cute2)
        ComponentObjectSetValue2(dmg, "damage_by_type", "slice", total_attacking * charming2)
        ComponentObjectSetValue2(dmg, "damage_by_type", "fire", total_attacking * clever2)
        ComponentObjectSetValue2(dmg, "damage_by_type", "ice", total_attacking * comedic2)
        ComponentObjectSetValue2(dmg, "damage_by_type", "drill", total_attacking * typeless2)

        EntityKill(proj_entity)
        EntityAddTag(who, "comedic_nohurt")
        EntityAddTag(proj_entity, "comedic_nohurt")
    else
        -- if equal, kill both
        EntityKill(who)
        EntityKill(proj_entity)
        EntityAddTag(who, "comedic_nohurt")
        EntityAddTag(proj_entity, "comedic_nohurt")
    end
end

function DamageHeart(who, types, multiplier, who_did_it, proj_entity, x, y, do_percent_damage)
    local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
    if not (string.len(storage) > 0) then return end
    local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
    local v = smallfolk.loads(storage)
    local charming_boost_cap = 2
    -- CHARMING ULT
    if proj_entity and (EntityGetName(proj_entity) == "n_ns_ultcharmingshot" or EntityGetName(proj_entity) == "$n_ns_ultcharming") then
        charming_boost_cap = 10
        local parent = EntityGetRootEntity(proj_entity)
        local var = EntityGetFirstComponent(parent, "VariableStorageComponent", "heart_pupil_frame")
        if var then ComponentSetValue2(var, "value_int", GameGetFrameNum() + 8) end
    end
    CheckDamageNumbers(who, true)

    multiplier = (multiplier or 1)
    if do_percent_damage then
        types.cute = types.cute and (v.guardmax * types.cute / 25) or 0
        types.charming = types.charming and (v.guardmax * types.charming / 25) or 0
        types.clever = types.clever and (v.guardmax * types.clever / 25) or 0
        types.comedic = types.comedic and (v.guardmax * types.comedic / 25) or 0
        types.typeless = types.typeless and (v.guardmax * types.typeless / 25) or 0
    end
    local cute = (types.cute or 0) * multiplier * v.charming_boost * v.cute
    if cute > 0 then -------- CUTE --------
        if v.guard <= v.guardmax * 0.25 or v.guard >= v.guardmax * 0.75 then
            cute = cute * 1.25
            v.cuteflashframe = math.max(GameGetFrameNum(), v.cuteflashframe)
        end
        EntityInflictDamage(who, cute, "DAMAGE_PROJECTILE", "$inventory_dmg_melee", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - cute * 25)
        v.charming_boost = math.max(1, v.charming_boost - (cute * 0.25))
        v.tempo = math.min(v.tempomax, v.tempo + cute * v.tempo_dmg_mult)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)
    end
    local charming = (types.charming or 0) * multiplier * v.charming
    if charming > 0 then -------- CHARMING --------
        EntityInflictDamage(who, charming, "DAMAGE_PROJECTILE", "$inventory_dmg_slice", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - charming * 25)
        if v.charming_boost < charming_boost_cap then
            v.charming_boost = math.min(charming_boost_cap, v.charming_boost + (charming * 0.25))
            v.charmingflashframe = math.max(GameGetFrameNum(), v.charmingflashframe)
        end
        v.tempo = math.min(v.tempomax, v.tempo + charming * v.tempo_dmg_mult)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)
    end
    local clever = (types.clever or 0) * multiplier * v.charming_boost * v.clever
    if clever > 0 then -------- CLEVER --------
        EntityInflictDamage(who, clever, "DAMAGE_PROJECTILE", "$inventory_dmg_fire", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - clever * 25)
        v.charming_boost = math.max(1, v.charming_boost - (clever * 0.25))
        local old = v.tempo
        if v.tempo > clever then
            v.tempo = math.max(0, v.tempo - clever)
            v.tempodebt = v.tempodebt + (old - v.tempo)
            v.cleverflashframe = math.max(GameGetFrameNum(), v.cleverflashframe)
        end
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)
        -- CLEVER ULT
        if proj_entity and EntityGetName(proj_entity) == "$n_ns_ultclever" then
            local comp = EntityGetFirstComponentIncludingDisabled(proj_entity, "LuaComponent", "ult_clever")
            local sprite = EntityGetFirstComponentIncludingDisabled(proj_entity, "SpriteComponent", "character")
            if comp and sprite then
                local count = ComponentGetValue2(comp, "limit_how_many_times_per_frame") + 1
                ComponentSetValue2(comp, "limit_how_many_times_per_frame", count)
                if count == 3 then
                    v.tempolevel = v.tempolevel - 1
                    ComponentSetValue2(sprite, "rect_animation", "fill_2")
                end
                if count == 6 then
                    v.tempolevel = v.tempolevel - 1
                    ComponentSetValue2(sprite, "rect_animation", "fill_3")
                end
                if count == 9 then
                    v.tempolevel = v.tempolevel - 1
                    ComponentSetValue2(sprite, "rect_animation", "fill_4")
                end
                if count == 12 then
                    v.tempolevel = v.tempolevel - 1
                    ComponentSetValue2(sprite, "rect_animation", "fill_5")
                end
                if count == 15 then
                    v.tempolevel = v.tempolevel - 1
                    EntityKill(proj_entity)
                end
            end
        end
        -- CLEVER ULT
    end
    local comedic = (types.comedic or 0) * multiplier * v.charming_boost * v.comedic
    if comedic > 0 then -------- COMEDIC --------
        EntityInflictDamage(who, comedic, "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - comedic * 25)
        v.charming_boost = math.max(1, v.charming_boost - (comedic * 0.25))
        v.tempo = math.min(v.tempomax, v.tempo + comedic * v.tempo_dmg_mult)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)

        if who_did_it and who_did_it > 0 and proj_entity and (not EntityHasTag(proj_entity, "comedic_noheal")) and who_did_it ~= who then
            local dmg = EntityGetFirstComponent(who_did_it, "DamageModelComponent")
            -- COMEDIC ULT
            if dmg and proj_entity and EntityGetName(proj_entity) == "$n_ns_ultcomedic" then
                v.damagemax = math.min(v.guardmax - 1, v.damagemax + comedic * 25)
                ComponentSetValue2(dmg, "max_hp", ComponentGetValue2(dmg, "max_hp") + comedic)
            end
            -- COMEDIC ULT
            if dmg and ComponentGetValue2(dmg, "hp") < ComponentGetValue2(dmg, "max_hp") then
                EntityInflictDamage(who_did_it, comedic * -1, "DAMAGE_HEALING", "$inventory_dmg_healing", "NORMAL", 0, 0, who_did_it)
                local x2, y2 = EntityGetTransform(who_did_it)
                EntityLoad("mods/noiting_simulator/files/spells/comedic_heal_silent.xml", x, y)
                EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x2, y2)
                v.comedicflashframe = math.max(GameGetFrameNum(), v.comedicflashframe)
            end
            -- EntityAddTag(proj_entity, "comedic_noheal")
            EntityAddTag(proj_entity, "comedic_nohurt")
        end
    end

    local typeless = (types.typeless or 0) * multiplier
    if typeless > 0 then -------- TYPELESS --------
        EntityInflictDamage(who, typeless, "DAMAGE_PROJECTILE", "$inventory_dmg_drill", "NORMAL", 0, 0, who_did_it)
        v.guard = math.max(0, v.guard - typeless * 25)
        v.tempo = math.min(v.tempomax, v.tempo + typeless * v.tempo_dmg_mult)
        v.guardflashframe = math.max(GameGetFrameNum(), v.guardflashframe)
    end
    MakeDamageNumbers(who, {cute = cute, charming = charming, clever = clever, comedic = comedic, typeless = typeless}, true)

    GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
    v = smallfolk.loads(GlobalsGetValue("NS_BATTLE_STORAGE"))
end