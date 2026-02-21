local me = GetUpdatedEntityID()
local action = EntityGetFirstComponentIncludingDisabled(me, "ItemActionComponent")
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local var = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "charges")
local id = action and ComponentGetValue2(action, "action_id")
local spells = dofile_once("mods/noiting_simulator/files/spells/__gun_list.lua")
if not (var and item and string.len(id) > 1 and #spells > 0) then return end
local data = {}
for i = 1, #spells do
    if spells[i].id == id then
        data = spells[i]
        break
    end
end

-- quote flavor text
local text = "$q_" .. string.lower(id)
local real = GameTextGetTranslatedOrNot(text)
if not (real and real ~= text and string.len(real) > 1) then return end
if ComponentGetValue2(item, "custom_pickup_string") == "" then
    ComponentSetValue2(item, "custom_pickup_string", text)
end

-- fix z-fighting
local z_target_sprite = -1.5 + me / 1000
local z_target_bg = -1.2 + me / 1000
local sprites = EntityGetComponentIncludingDisabled(me, "SpriteComponent") or {}
for i = 1, #sprites do
    if ComponentHasTag(sprites[i], "item_identified") and ComponentGetValue2(sprites[i], "z_index") ~= z_target_sprite then
        ComponentSetValue2(sprites[i], "z_index", z_target_sprite)
        EntityRefreshSprite(me, sprites[i])
    end
    if ComponentHasTag(sprites[i], "item_bg") and ComponentGetValue2(sprites[i], "z_index") ~= z_target_bg then
        ComponentSetValue2(sprites[i], "z_index", z_target_bg)
        EntityRefreshSprite(me, sprites[i])
    end
end

-- charging functionality
if data.charge_time and data.max_uses then
    local current = ComponentGetValue2(item, "uses_remaining")
    local charges = ComponentGetValue2(var, "value_float")
    local charge_time = 1 / (data.charge_time * 25 * 60)
    local max_charges = data.max_uses or -1
    charges = charges + charge_time
    if charges >= 1 then
        ComponentSetValue2(item, "uses_remaining", current + 1)
        charges = charges - 1
    end
    if current >= max_charges or charge_time == -1 then charges = 0 end
    ComponentSetValue2(var, "value_float", charges)
end

-- bootleg InheritTransformComponent
local root = EntityGetRootEntity(me)
local x, y = EntityGetTransform(root)
if root ~= me then
	EntitySetTransform(me, x, y - 2, 0)
end

-- discovery
if EntityHasTag(root, "player_unit") and ModSettingGet("noiting_simulator.spell_discovered_" .. data.id) ~= true then
    ModSettingSet("noiting_simulator.spell_discovered_" .. data.id, true)
	AddFlagPersistent("action_" .. string.lower(data.id))
end
if EntityHasTag(EntityGetParent(me), "wand") then
	EntitySetComponentsWithTagEnabled(me, "enable_when_on_wand", true)
	if EntityHasTag(me, "puppydog") then EntityAddTag(me, "puppydog_enabled") end
else
	EntitySetComponentsWithTagEnabled(me, "enable_when_on_wand", false)
	if EntityHasTag(me, "puppydog") then EntityRemoveTag(me, "puppydog_enabled") end
end
if root == me and ComponentGetValue2(item, "has_been_picked_by_player") == true then
    local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
    local storage = GlobalsGetValue("NS_STORAGE_BOX_SPELLS", "") or ""
    local spellstorage = string.len(storage) > 0 and smallfolk.loads(storage) or {}

    spellstorage[data.id] = (spellstorage[data.id] or 0) + 1
	EntityLoad("data/entities/particles/poof_blue.xml", x, y)

    GlobalsSetValue("NS_STORAGE_BOX_SPELLS", smallfolk.dumps(spellstorage))
    EntityKill(me)
end

-- commander
local is_in_hand = EntityGetFirstComponent(me, "VariableStorageComponent", "hand_checker") ~= nil
local controls = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
if id == "NS_COMMANDER" then
	local commander_type = GlobalsGetValue("SPELL_COMMANDER_TYPE", "NONE")
	local sprite = commander_type == "NONE" and "mods/noiting_simulator/files/spells/commander.png" or
		commander_type == "CUTE" and "mods/noiting_simulator/files/spells/commander_cute.png" or
		commander_type == "CHARMING" and "mods/noiting_simulator/files/spells/commander_charming.png" or
		commander_type == "CLEVER" and "mods/noiting_simulator/files/spells/commander_clever.png" or
		commander_type == "COMEDIC" and "mods/noiting_simulator/files/spells/commander_comedic.png"
	ComponentSetValue2(item, "ui_sprite", sprite)
	local cooldown = tonumber(GlobalsGetValue("SPELL_COMMANDER_COOLDOWN", "0"))
	if is_in_hand and controls and ComponentGetValue2(controls, "mButtonDownThrow") and cooldown < GameGetFrameNum() then
		commander_type = (commander_type == "NONE" and "CUTE") or
			(commander_type == "CUTE" and "CHARMING") or
			(commander_type == "CHARMING" and "CLEVER") or
			(commander_type == "CLEVER" and "COMEDIC") or
			(commander_type == "COMEDIC" and "NONE")
		GlobalsSetValue("SPELL_COMMANDER_TYPE", tostring(commander_type))
		GlobalsSetValue("SPELL_COMMANDER_COOLDOWN", tostring(GameGetFrameNum() + 30))
		commander_type = commander_type == "NONE" and "TYPELESS" or commander_type
		EntityLoad("mods/noiting_simulator/files/spells/explosions/mini_" .. string.lower(commander_type) .. ".xml", x, y - 2)
	end
end