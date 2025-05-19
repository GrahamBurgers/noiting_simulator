local translations = ModTextFileGetContent("data/translations/common.csv")
local new = translations .. ModTextFileGetContent("mods/noiting_simulator/translations.csv")
ModTextFileSetContent("data/translations/common.csv", new:gsub("\r",""):gsub("\n\n","\n"))
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noiting_simulator/files/spells/__gun_actions.lua")
AddFlagPersistent("perk_picked_ns_achievement_thingy") -- remove later
ModTextFileSetContent("data/scripts/perks/perk_list.lua", [[
perk_list = {{
id = "NS_ACHIEVEMENT_THINGY",
ui_name = "$perk_genome_more_love",
ui_description = "$perkdesc_genome_more_love",
ui_icon = "data/ui_gfx/perk_icons/genome_more_love.png",
perk_icon = "data/items_gfx/perks/genome_more_love.png"}}
]])
ModTextFileSetContent("data/scripts/magic/amulet.lua", [[print("no hat")]])

local function getsetgo(entity, comp, name, value, object)
    local c = EntityGetFirstComponentIncludingDisabled(entity, comp)
    if c then
        if object then
            ComponentObjectSetValue2(c, name, value, object)
        else
            ComponentSetValue2(c, name, value)
        end
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
        GameAddFlagRun("NOITING_SIM_INIT")
        -- base player modifications
        getsetgo(player_id, "SpriteStainsComponent", "_enabled", false)
        getsetgo(player_id, "DamageModelComponent",  "air_needed", false)
        getsetgo(player_id, "DamageModelComponent", "materials_damage", false)
        getsetgo(player_id, "DamageModelComponent", "damage_multipliers", "explosion", 1.0)
        getsetgo(player_id, "DamageModelComponent", "damage_multipliers", "holy", 1.0)
        getsetgo(player_id, "DamageModelComponent", "blood_multiplier", 0)
        -- getsetgo(player_id, "PlatformShooterPlayerComponent", "center_camera_on_this_entity", false)
        -- getsetgo(player_id, "PlatformShooterPlayerComponent", "move_camera_with_aim", false)
        getsetgo(player_id, "PlatformShooterPlayerComponent", "eating_delay_frames", 99999999) -- holding the down button for 19 days straight will let you eat
        getsetgo(player_id, "KickComponent", "can_kick", false)
        local inventory = EntityGetWithName("inventory_quick")
        local c = EntityGetAllChildren(inventory) or {}
        if false then -- TODO REMOVE
            for i = 1, #c do
                EntityKill(c[i])
            end
        end
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
            script_material_area_checker_success="main", -- current text track
        })
        EntityAddComponent2(player_id, "LuaComponent", {
            _tags="ns_cape_effect",
            script_source_file="mods/noiting_simulator/files/items/capes/default.lua",
        })
        EntityAddComponent2(player_id, "LuaComponent", {
            execute_every_n_frame=-1,
            script_damage_received="mods/noiting_simulator/files/scripts/player_damage_received.lua",
        })
        dofile_once("mods/noiting_simulator/files/gui/scripts/text.lua")
        SetScene("mods/noiting_simulator/files/scenes/info.lua", 1, 1)
        local entity_id = EntityCreateNew()
        EntityAddComponent2(entity_id, "GameEffectComponent", {effect="PROTECTION_POLYMORPH", frames=-1})
        EntityAddChild(player_id, entity_id)
        -- todo remove
        entity_id = EntityCreateNew()
        EntityAddComponent2(entity_id, "GameEffectComponent", {effect="EDIT_WANDS_EVERYWHERE", frames=-1})
        EntityAddChild(player_id, entity_id)

        GlobalsSetValue("NS_IN_BATTLE", "0")
        dofile_once("mods/noiting_simulator/files/scripts/time.lua")
        OnGameStart()
    end
end

function OnWorldPreUpdate()
    local cx, cy = tonumber(GlobalsGetValue("NS_CAM_X", "nil")), tonumber(GlobalsGetValue("NS_CAM_Y", "nil"))
    local follow = tonumber(GlobalsGetValue("NS_CAM_FOLLOW", "4"))
    if not (cx and cy) then return end
    local players = EntityGetWithTag("player_unit") or {}
    for i = 1, #players do
        local x, y = EntityGetTransform(players[i])
        local c = EntityGetFirstComponentIncludingDisabled(players[i], "PlatformShooterPlayerComponent")
        if c then
            ComponentSetValue2(c, "mDesiredCameraPos", cx + ((x - cx) / follow), cy)
        end
    end
end

function OnPausedChanged(is_paused, is_inventory_pause)
    -- update pronouns on unpause
    if not is_paused then
        dofile("mods/noiting_simulator/files/scripts/characters.lua")
    end
end