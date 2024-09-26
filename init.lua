local translations = ModTextFileGetContent("data/translations/common.csv")
local new = translations .. ModTextFileGetContent("mods/noiting_simulator/translations.csv")
ModTextFileSetContent("data/translations/common.csv", new:gsub("\r",""):gsub("\n\n","\n"))
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noiting_simulator/files/scripts/gun_actions.lua")

function OnPlayerSpawned(player_id)
    if not GameHasFlagRun("NOITING_SIM_INIT") then
        GameAddFlagRun("NOITING_SIM_INIT")
        EntityAddComponent2(GameGetWorldStateEntity(), "LuaComponent", {
            _tags="noiting_simulator",
            script_source_file="mods/noiting_simulator/files/scripts/text_run.lua",
            script_inhaled_material="", -- this is scene file
            script_throw_item="1", -- this is scene line number
            script_material_area_checker_failed="0" -- current text number
        })
        dofile_once("mods/noiting_simulator/files/scripts/text.lua")
        SetScene("mods/noiting_simulator/files/scenes/intro.lua")
    end
end