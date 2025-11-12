--[[
dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
StartBattle("Parantajahiisi")
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

    local v = {
        name = character,
        guard = mine.guard,
        guardmax = mine.guard,
        tempolevel = 0,
        tempo = 0,
        tempomax = mine.tempomax,
        tempodebt = 0,
        tempogain = mine.tempogain,
        tempomaxboost = mine.tempomaxboost,
        tempo_dmg_mult = mine.tempo_dmg_mult,
        fire_multiplier = mine.fire_multiplier,
        burn_multiplier = mine.burn_multiplier,
        cute = mine.cute,
        charming = mine.charming,
        clever = mine.clever,
        comedic = mine.comedic,
        charming_boost = 1,
        guardflashframe = -1,
        tempoflashframe = -1,
        cuteflashframe = -1,
        charmingflashframe = -1,
        cleverflashframe = -1,
        comedicflashframe = -1,
        amulet = nil,
        amuletgem = nil,
        text = {},
        textframe = -999,
        arena_x = x,
        arena_y = y,
        arena_w = w - mine.arena_border * 2,
        arena_h = h - mine.arena_border * 2,
    }
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