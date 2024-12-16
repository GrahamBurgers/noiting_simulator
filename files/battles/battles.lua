--[[
dofile_once("mods/noiting_simulator/files/battles/battles.lua")
StartBattle("Parantajahiisi")
]]--
local x, y = 256, -728
Battles = {

["Parantajahiisi"] = {size = 8,
    heart = "mods/noiting_simulator/files/battles/hearts/parantajahiisi.png",
    arena = "mods/noiting_simulator/files/battles/arenas/default.png",
    cute = 1.4, charming = 0.8, clever = 1.0, funny = 1.2
},
["Stendari"] = {size = 8,
    arena = "mods/noiting_simulator/files/battles/arenas/default.png",
    cute = 0.8, charming = 1.2, clever = 1.4, funny = 1.0
},
["Snipuhiisi"] = {size = 8,
    arena = "mods/noiting_simulator/files/battles/arenas/default.png",
    cute = 1.2, charming = 0.8, clever = 1.0, funny = 1.4
},
}

function StartBattle(character)
    local ah = GuiCreate()
    local mine = Battles[character]
    local heart = EntityLoad("mods/noiting_simulator/files/battles/hearts/heart.xml", x, y)

    local w2, h2 = GuiGetImageDimensions(ah, mine["arena"])
    LoadPixelScene(mine["arena"], "", x - w2 / 2, y - h2 / 2, "", true, false)
    GlobalsSetValue("NS_CAM_X", tostring(x))
    GlobalsSetValue("NS_CAM_Y", tostring(y + 48))

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
            ComponentObjectSetValue2(c[i], "damage_multipliers", "fire", mine["cute"])
            ComponentObjectSetValue2(c[i], "damage_multipliers", "slice", mine["charming"])
            ComponentObjectSetValue2(c[i], "damage_multipliers", "drill", mine["clever"])
            ComponentObjectSetValue2(c[i], "damage_multipliers", "ice", mine["funny"])
            ComponentObjectSetValue2(c[i], "damage_multipliers", "melee", 0)
        end
        if ComponentGetTypeName(c[i]) == "HitboxComponent" then
            ComponentSetValue2(c[i], "aabb_min_x", -mine["size"])
            ComponentSetValue2(c[i], "aabb_max_x", mine["size"])
            ComponentSetValue2(c[i], "aabb_min_y", -mine["size"])
            ComponentSetValue2(c[i], "aabb_max_y", mine["size"])
        end
    end
    EntitySetName(heart, character)
    GlobalsSetValue("NS_BATTLE_TURN", "0")
    PlayerTurn()
end

function PlayerTurn()
    dofile_once("mods/noiting_simulator/files/gui/scripts/text.lua")
    local turn = tostring(GlobalsGetValue("NS_BATTLE_TURN") + 1)
    GlobalsSetValue("NS_BATTLE_TURN", turn)
    -- GlobalsSetValue("NS_STAMINA_VALUE", tostring(math.max(0, GlobalsGetValue("NS_STAMINA_VALUE", "0")) - 1))
    AddLines({texts = {{text = "Turn " .. turn .. "!", style = {"info"}}}, behavior = "instant",
    choices = {
        {name = "TINKER", location = "left"},
        {name = "CHAT", location = "right"},
        {name = "ITEM", location = "left"},
        {name = "FLEE", location = "right"},
    }})
end