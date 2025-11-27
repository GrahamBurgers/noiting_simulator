--[[
dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
StartBattle("healer")
]]--
local x, y = 256, -728
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

local function path(character, name)
    return table.concat({"mods/noiting_simulator/files/battles/", character, "/", name})
end

function StartBattle(character)
    local ah = GuiCreate()
    local data = path(character, "_data.lua")
    local mine = dofile(data).DATA
    local heart = EntityLoad("mods/noiting_simulator/files/battles/heart.xml", x, y)

    local w, h = GuiGetImageDimensions(ah, mine.arena)
    LoadPixelScene(mine.arena, "", x - w / 2, y - h / 2, "", true, false)
    GlobalsSetValue("NS_CAM_X", tostring(x))
    GlobalsSetValue("NS_CAM_Y", tostring(y + 48))
    GlobalsSetValue("NS_IN_BATTLE", "1")

    local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
    local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
    local p = v.persistent and v.persistent[v.name] or {}
        v.name = character
        v.guard = mine.guard - (p.damage or 0)
        v.guardmax = mine.guard
        v.damagemax = p.damagemax or 0
        v.tempolevel = 0
        v.tempo = 0
        v.tempomax = mine.tempomax
        v.tempodebt = 0
        v.tempogain = mine.tempogain
        v.tempomaxboost = mine.tempomaxboost
        v.tempo_dmg_mult = mine.tempo_dmg_mult
        v.fire_multiplier = mine.fire_multiplier
        v.burn_multiplier = mine.burn_multiplier
        v.cute = mine.cute
        v.charming = mine.charming
        v.clever = mine.clever
        v.comedic = mine.comedic
        v.charming_boost = 1
        v.guardflashframe = -1
        v.tempoflashframe = -1
        v.cuteflashframe = -1
        v.charmingflashframe = -1
        v.cleverflashframe = -1
        v.comedicflashframe = -1
        v.amulet = v.amulet or nil
        v.amuletgem = v.amuletgem or nil
        v.text = {}
        v.textframe = -999
        v.arena_x = x
        v.arena_y = y
        v.arena_w = w - mine.arena_border * 2
        v.arena_h = h - mine.arena_border * 2
        v.necrorevive = false
    GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))

    local c = EntityGetAllComponents(heart)
    for i = 1, #c do
        if ComponentGetTypeName(c[i]) == "SpriteComponent" then
            local w3, h3 = GuiGetImageDimensions(ah, mine.heart)

            ComponentSetValue2(c[i], "image_file", mine.heart)
            ComponentSetValue2(c[i], "offset_x", w3 / 2)
            ComponentSetValue2(c[i], "offset_y", h3 / 2)
            EntityRefreshSprite(heart, c[i])
        end
        if ComponentGetTypeName(c[i]) == "ParticleEmitterComponent" and ComponentHasTag(c[i], "fire") then
            -- not technically a good idea to not have a separate burn sprite, but it looks fine
            ComponentSetValue2(c[i], "image_animation_file", mine.heart)
        end
        if ComponentGetTypeName(c[i]) == "DamageModelComponent" then
            ComponentObjectSetValue2(c[i], "damage_multipliers", "melee", v.cute)
            ComponentObjectSetValue2(c[i], "damage_multipliers", "slice", v.charming)
            ComponentObjectSetValue2(c[i], "damage_multipliers", "fire", v.clever)
            ComponentObjectSetValue2(c[i], "damage_multipliers", "ice", v.comedic)
        end
        if ComponentGetTypeName(c[i]) == "VariableStorageComponent" and ComponentGetValue2(c[i], "name") == "hitbox" then
            ComponentSetValue2(c[i], "value_float", mine.size)
        end
        if ComponentGetTypeName(c[i]) == "VariableStorageComponent" and ComponentGetValue2(c[i], "name") == "logic_file" then
            ComponentSetValue2(c[i], "value_string", data)
        end
        if ComponentGetTypeName(c[i]) == "VelocityComponent" then
            ComponentSetValue2(c[i], "mass", mine.mass)
            ComponentSetValue2(c[i], "air_friction", mine.air_friction)
        end
    end
    EntitySetName(heart, character)
end