--[[
dofile_once("mods/noiting_simulator/files/battles/battles.lua")
StartBattle("Dummy")
]]--
local x, y = 256, -728
local battles = dofile_once("mods/noiting_simulator/files/battles/hearts/_hearts.lua")

function StartBattle(character)
    local ah = GuiCreate()
    local mine = battles[character]
    local heart = EntityLoad("mods/noiting_simulator/files/battles/hearts/heart.xml", x, y)

    local w2, h2 = GuiGetImageDimensions(ah, mine["arena"])
    LoadPixelScene(mine["arena"], "", x - w2 / 2, y - h2 / 2, "", true, false)
    GlobalsSetValue("NS_CAM_X", tostring(x))
    GlobalsSetValue("NS_CAM_Y", tostring(y + 48))
    GlobalsSetValue("NS_IN_BATTLE", "1")

    local c = EntityGetAllComponents(heart)
    for i = 1, #c do
        if ComponentGetTypeName(c[i]) == "SpriteComponent" then
            local w3, h3 = GuiGetImageDimensions(ah, mine["heart"])

            ComponentSetValue2(c[i], "image_file", mine["heart"])
            ComponentSetValue2(c[i], "offset_x", w3 / 2)
            ComponentSetValue2(c[i], "offset_y", h3 / 2)
            EntityRefreshSprite(heart, c[i])
        end
        if ComponentGetTypeName(c[i]) == "DamageModelComponent" then
            ComponentObjectSetValue2(c[i], "damage_multipliers", "melee", mine["cute"])
            ComponentObjectSetValue2(c[i], "damage_multipliers", "slice", mine["charming"])
            ComponentObjectSetValue2(c[i], "damage_multipliers", "fire", mine["clever"])
            ComponentObjectSetValue2(c[i], "damage_multipliers", "ice", mine["comedic"])
        end
        if ComponentGetTypeName(c[i]) == "VariableStorageComponent" and ComponentGetValue2(c[i], "name") == "heart_hitbox" then
            ComponentSetValue2(c[i], "value_float", mine["size"])
        end
        if ComponentGetTypeName(c[i]) == "VelocityComponent" then
            ComponentSetValue2(c[i], "mass", mine["mass"])
        end
    end
    EntitySetName(heart, character)
end