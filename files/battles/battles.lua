--[[
dofile_once("mods/noiting_simulator/files/battles/battles.lua")
StartBattle("Parantajahiisi")
]]--
local x, y = 256, -728
local battles = dofile_once("mods/noiting_simulator/files/battles/hearts/_hearts.lua")
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

function StartBattle(character)
    local ah = GuiCreate()
    local mine = battles[character]
    local heart = EntityLoad("mods/noiting_simulator/files/battles/hearts/heart.xml", x, y)
    if character == "Dummy" then
        EntityLoad("mods/noiting_simulator/files/battles/hearts/dummy_stand.xml", x, y)
    end
    EntityAddTag(heart, "heart")

    local w2, h2 = GuiGetImageDimensions(ah, mine["arena"])
    LoadPixelScene(mine["arena"], "", x - w2 / 2, y - h2 / 2, "", true, false)
    GlobalsSetValue("NS_CAM_X", tostring(x))
    GlobalsSetValue("NS_CAM_Y", tostring(y + 48))
    GlobalsSetValue("NS_IN_BATTLE", "1")

    local v = {
        name = character,
        guard = mine.guard,
        guardmax = mine.guard,
        tempolevel = 0,
        tempo = 0,
        tempomax = mine.tempomax, -- when tempo reaches tempomax, tempo level goes up by 1
        cute = mine.cute,
        charming = mine.charming,
        clever = mine.clever,
        comedic = mine.comedic,
        charming_boost = 1,
        guardflashframe = -1,
        tempoflashframe = -1,
    }
    GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))

    local c = EntityGetAllComponents(heart)
    for i = 1, #c do
        if ComponentGetTypeName(c[i]) == "SpriteComponent" then
            local w3, h3 = GuiGetImageDimensions(ah, mine["heart"])

            ComponentSetValue2(c[i], "image_file", mine["heart"])
            ComponentSetValue2(c[i], "offset_x", w3 / 2)
            ComponentSetValue2(c[i], "offset_y", h3 / 2)
            EntityRefreshSprite(heart, c[i])
        end
        if ComponentGetTypeName(c[i]) == "ParticleEmitterComponent" and ComponentHasTag(c[i], "fire") then
            -- not technically a good idea to not have a separate burn sprite, but it looks fine
            ComponentSetValue2(c[i], "image_animation_file", mine["heart"])
        end
        if ComponentGetTypeName(c[i]) == "DamageModelComponent" then
            ComponentObjectSetValue2(c[i], "damage_multipliers", "melee", v.cute)
            ComponentObjectSetValue2(c[i], "damage_multipliers", "slice", v.charming)
            ComponentObjectSetValue2(c[i], "damage_multipliers", "fire", v.clever)
            ComponentObjectSetValue2(c[i], "damage_multipliers", "ice", v.comedic)
        end
        if ComponentGetTypeName(c[i]) == "VariableStorageComponent" and ComponentGetValue2(c[i], "name") == "hitbox" then
            ComponentSetValue2(c[i], "value_float", mine["size"])
        end
        if ComponentGetTypeName(c[i]) == "VelocityComponent" then
            ComponentSetValue2(c[i], "mass", mine["mass"])
        end
    end
    EntitySetName(heart, character)
end