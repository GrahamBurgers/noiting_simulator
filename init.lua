local translations = ModTextFileGetContent("data/translations/common.csv")
local new = translations .. ModTextFileGetContent("mods/noiting_simulator/translations.csv")
ModTextFileSetContent("data/translations/common.csv", new:gsub("\r",""):gsub("\n\n","\n"))
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noiting_simulator/files/scripts/gun_actions.lua")

local function getsetgo(entity, comp, name, value)
    local c = EntityGetFirstComponentIncludingDisabled(entity, comp)
    if c then
        ComponentSetValue2(c, name, value)
    end
end

--[[i wish this worked
function OnModPreInit()
    -- KILL other mods
    local mods = ModGetActiveModIDs() or {}
    for i = 1, #mods do
        if mods[i] ~= "noiting_simulator" then
            ModTextFileSetContent("mods/" .. mods[i] .. "/init.lua", "print(\"" .. (mods[i] .. " has been DESTROYED") .. ")\"")
        end
    end
end
]]--

function OnPlayerSpawned(player_id)
    if not GameHasFlagRun("NOITING_SIM_INIT") then
        -- base player modifications
        getsetgo(player_id, "SpriteStainsComponent", "_enabled", false)
        getsetgo(player_id, "DamageModelComponent",  "air_needed", false)
        getsetgo(player_id, "SpriteStainsComponent", "materials_damage", false)
        local inventory = EntityGetWithName("inventory_quick")
        local c = EntityGetAllChildren(inventory) or {}
        if false then -- TODO REMOVE
            for i = 1, #c do
                EntityKill(c[i])
            end
        end
        EntityAddComponent2(player_id, "LuaComponent", {
            script_source_file="mods/noiting_simulator/files/overworld/player_follow.lua"
        })

        local x, y = EntityGetTransform(player_id)
        GameAddFlagRun("NOITING_SIM_INIT")
        -- create text handler
        local child = EntityCreateNew()
        EntitySetName(child, "ns_text_handler")
        EntityAddChild(GameGetWorldStateEntity(), child)
        EntityAddComponent2(child, "LuaComponent", {
            _tags="noiting_simulator",
            script_source_file="mods/noiting_simulator/files/gui/scripts/render.lua",
            script_inhaled_material="", -- scene file
            script_throw_item="1", -- scene line number
            script_material_area_checker_failed="0", -- current character number
            script_material_area_checker_success="1", -- current text track
        })
        dofile_once("mods/noiting_simulator/files/gui/scripts/text.lua")
        SetScene("mods/noiting_simulator/files/scenes/intro2.lua", 1, 1, 1)
        local entity_id = EntityCreateNew()
        EntityAddComponent2(entity_id, "GameEffectComponent", {
            effect="EDIT_WANDS_EVERYWHERE",
            frames=-1
        })
        EntityAddChild(player_id, entity_id)
        -- GameSetCameraFree(true)
        GlobalsSetValue("NS_STAMINA_VALUE", "4")
        GlobalsSetValue("NS_STAMINA_MAX", "4")
        -- create overworld handler
        dofile_once("mods/noiting_simulator/files/overworld/locations.lua")
        child = EntityCreateNew()
        EntitySetName(child, "ns_world_handler")
        EntityAddChild(GameGetWorldStateEntity(), child)
        EntityLoad("mods/noiting_simulator/files/overworld/player.xml", x + 8, y + 8)
        Load_location("plaza", 4, 4)
    end
end