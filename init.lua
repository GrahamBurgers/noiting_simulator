local utf8 = dofile_once("mods/noiting_simulator/files/scripts/utf8.lua") --[[@as utf8]]

local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/noiting_simulator/translations.csv")

local formatted = ""

local ASCII_SIZE = 128
local PUA_START = 0xE000

local ICONS = {
	"CUTE",
	"CHARMING",
	"CLEVER",
	"COMEDIC",
	"TYPELESS",
}

local ICON_MODE = "ICON"
local ICONS_PREFIX = ICON_MODE .. "_"

local SPECIAL_MODES = {
	-- start of PUA
	CUTE = PUA_START + ASCII_SIZE * 0,
	CHARMINING = PUA_START + ASCII_SIZE * 1,
	CLEVER = PUA_START + ASCII_SIZE * 2,
	COMEDIC = PUA_START + ASCII_SIZE * 3,
	TYPELESS = PUA_START + ASCII_SIZE * 4,
	[ICON_MODE] = PUA_START + ASCII_SIZE * 5,
	NONE = 0
}

local largest_follower = 0
for k, _ in pairs(SPECIAL_MODES) do
	-- why can't luals infer this ?? stupid generics
	largest_follower = math.max(largest_follower, k:len()) --[[@as integer]]
end
for _, v in ipairs(ICONS) do
	largest_follower = math.max(largest_follower, v:len() + ICONS_PREFIX:len()) --[[@as integer]]
end

---@type integer?
local special = nil
local i = 1

---@param follower string
local function handle_icon(follower)
	for k, icon in ipairs(ICONS) do
		local name = ICONS_PREFIX .. icon
		if follower:sub(1, name:len()) == name then
			formatted = formatted .. utf8.char(SPECIAL_MODES[ICON_MODE] + k)
			i = i + name:len() --[[@as integer]]
		end
		return
	end
end

---Mutates i, special, formatted
local function handle_format()
	local follower = new_translations:sub(i, i + largest_follower)
	for mode, shift in pairs(SPECIAL_MODES) do
		if follower:sub(1, mode:len()) == mode then
			if mode == ICON_MODE then
				handle_icon(follower)
			else
				special = shift
				if special == 0 then special = nil end
				i = i + mode:len()
			end
			break
		end
	end
end

local SECTION = "§"

while i <= new_translations:len() do
	local next_point = new_translations:find(SECTION, i) or new_translations:len()
	local sub = new_translations:sub(i, next_point - 1)
	if special then
		for char in sub:gmatch(".") do
			formatted = formatted .. utf8.char(char:byte() + special)
		end
	else
		formatted = formatted .. sub
	end
	i = next_point + SECTION:len()
	handle_format()
end

local updated_translations = translations .. formatted
ModTextFileSetContent("data/translations/common.csv", updated_translations:gsub("\r",""):gsub("\n\n","\n"))
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noiting_simulator/files/spells/__gun_actions.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noiting_simulator/files/perks/_perk_list.lua")
AddFlagPersistent("perk_picked_ns_achievement_thingy") -- remove later
ModTextFileSetContent("data/scripts/magic/amulet.lua", [[print("no hat")]])

-- Fix spell charges desyncing from the card. Goddamn
local gun = ModTextFileGetContent("data/scripts/gun/gun.lua")
gun = gun:gsub([[elseif action.is_identified then]],
[[elseif action.is_identified then
local x, y = EntityGetTransform%(GetUpdatedEntityID%(%)%)
local cards = EntityGetWithTag%("card_action"%) or {}
for i = 1, #cards do
    local item = EntityGetFirstComponentIncludingDisabled%(cards[i], "ItemComponent"%)
    if item and ComponentGetValue2%(item, "mItemUid"%) == action.inventoryitem_id then
        action.uses_remaining = ComponentGetValue2%(item, "uses_remaining"%)
        break
    end
end
]])
ModTextFileSetContent("data/scripts/gun/gun.lua", gun)

local function getsetgo(entity, comp, name, value, object)
    local c = EntityGetFirstComponentIncludingDisabled(entity, comp)
    if c then
        if object then
            ComponentObjectSetValue2(c, name, value, object)
        elseif name == "_enabled" then
            EntitySetComponentIsEnabled(entity, c, value)
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
        getsetgo(player_id, "LightComponent", "radius", 150)
        getsetgo(player_id, "SpriteComponent", "image_file", "mods/noiting_simulator/files/player.xml")
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
            script_source_file="mods/noiting_simulator/files/scripts/player.lua",
        })
        EntityAddComponent2(player_id, "LuaComponent", {
            execute_every_n_frame=-1,
            script_damage_received="mods/noiting_simulator/files/scripts/player_damage_received.lua",
            script_damage_about_to_be_received="mods/noiting_simulator/files/scripts/player_damage_about_to_be_received.lua",
        })
        dofile_once("mods/noiting_simulator/files/gui/scripts/text.lua")
        SetScene("mods/noiting_simulator/files/scenes/intro.lua", 1)
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

function OnPausedChanged(is_paused, is_inventory_pause)
    -- update pronouns on unpause
    ModSettingSet("noiting_simulator.RELOAD", (ModSettingGet("noiting_simulator.RELOAD") or 0) + 1)
    local spells = dofile_once("mods/noiting_simulator/files/spells/__gun_list.lua")
    local cute, charming, clever, comedic, typeless = 0, 0, 0, 0, 0
    local cute_mods, charming_mods, clever_mods, comedic_mods, typeless_mods = 0, 0, 0, 0, 0
    local cute_projs, charming_projs, clever_projs, comedic_projs, typeless_projs = 0, 0, 0, 0, 0
    for i = 1, #spells do
        local cat  = spells[i].ns_category
        local type = spells[i].type
        cute       = cute +       (cat == "CUTE" and 1 or 0)
        cute_mods  = cute_mods +  ((cat == "CUTE" and type == ACTION_TYPE_MODIFIER)   and 1 or 0)
        cute_projs = cute_projs + ((cat == "CUTE" and type == ACTION_TYPE_PROJECTILE) and 1 or 0)
        charming       = charming + (cat == "CHARMING" and 1 or 0)
        charming_mods  = charming_mods +  ((cat == "CHARMING" and type == ACTION_TYPE_MODIFIER)   and 1 or 0)
        charming_projs = charming_projs + ((cat == "CHARMING" and type == ACTION_TYPE_PROJECTILE) and 1 or 0)
        clever       = clever + (cat == "CLEVER" and 1 or 0)
        clever_mods  = clever_mods +  ((cat == "CLEVER" and type == ACTION_TYPE_MODIFIER)   and 1 or 0)
        clever_projs = clever_projs + ((cat == "CLEVER" and type == ACTION_TYPE_PROJECTILE) and 1 or 0)
        comedic       = comedic + (cat == "COMEDIC" and 1 or 0)
        comedic_mods  = comedic_mods +  ((cat == "COMEDIC" and type == ACTION_TYPE_MODIFIER)   and 1 or 0)
        comedic_projs = comedic_projs + ((cat == "COMEDIC" and type == ACTION_TYPE_PROJECTILE) and 1 or 0)
        typeless       = typeless + (cat == "TYPELESS" and 1 or 0)
        typeless_mods  = typeless_mods +  ((cat == "TYPELESS" and type == ACTION_TYPE_MODIFIER)   and 1 or 0)
        typeless_projs = typeless_projs + ((cat == "TYPELESS" and type == ACTION_TYPE_PROJECTILE) and 1 or 0)
    end
    print("CUTE: " .. tostring(cute) .. ", projs: " .. tostring(cute_projs) .. ", mods: " .. tostring(cute_mods) .. ", other: " .. tostring(cute - cute_projs - cute_mods))
    print("CHARMING: " .. tostring(charming) .. ", projs: " .. tostring(charming_projs) .. ", mods: " .. tostring(charming_mods) .. ", other: " .. tostring(charming - charming_projs - charming_mods))
    print("CLEVER: " .. tostring(clever) .. ", projs: " .. tostring(clever_projs) .. ", mods: " .. tostring(clever_mods) .. ", other: " .. tostring(clever - clever_projs - clever_mods))
    print("COMEDIC: " .. tostring(comedic) .. ", projs: " .. tostring(comedic_projs) .. ", mods: " .. tostring(comedic_mods) .. ", other: " .. tostring(comedic - comedic_projs - comedic_mods))
    print("TYPELESS: " .. tostring(typeless) .. ", projs: " .. tostring(typeless_projs) .. ", mods: " .. tostring(typeless_mods) .. ", other: " .. tostring(typeless - typeless_projs - typeless_mods))
    print("TOTAL: " .. tostring(#spells))
end
