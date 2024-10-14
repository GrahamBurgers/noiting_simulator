local translations = ModTextFileGetContent("data/translations/common.csv")
local new = translations .. ModTextFileGetContent("mods/noiting_simulator/translations.csv")
ModTextFileSetContent("data/translations/common.csv", new:gsub("\r",""):gsub("\n\n","\n"))
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noiting_simulator/files/scripts/gun_actions.lua")

function OnPlayerSpawned(player_id)
    if not GameHasFlagRun("NOITING_SIM_INIT") then
        GameAddFlagRun("NOITING_SIM_INIT")
        local child = EntityCreateNew()
        EntitySetName(child, "noiting_sim_handler")
        EntityAddChild(GameGetWorldStateEntity(), child)
        EntityAddComponent2(child, "LuaComponent", {
            _tags="noiting_simulator",
            script_source_file="mods/noiting_simulator/files/gui/scripts/text_run.lua",
            script_inhaled_material="", -- scene file
            script_throw_item="1", -- scene line number
            script_material_area_checker_failed="0", -- current character number
            script_material_area_checker_success="1", -- current text track
        })
        dofile_once("mods/noiting_simulator/files/gui/scripts/text.lua")
        SetScene("mods/noiting_simulator/files/scenes/test.lua", 1, 1, 1)
        local entity_id = EntityCreateNew()
        EntityAddComponent2(entity_id, "GameEffectComponent", {
            effect="EDIT_WANDS_EVERYWHERE",
            frames=-1
        })
        EntityAddChild(player_id, entity_id)
        GameSetCameraFree(true)
        GlobalsSetValue("NS_STAMINA_VALUE", "4")
        GlobalsSetValue("NS_STAMINA_MAX", "4")
    end
end