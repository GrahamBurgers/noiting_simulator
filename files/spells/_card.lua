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
if data.max_uses then
    local current = ComponentGetValue2(item, "uses_remaining")
    local charges = ComponentGetValue2(var, "value_float")
	local max_charges = data.max_uses or -1
	if EntityGetWithName("dummy") > 0 then
		ComponentSetValue2(item, "uses_remaining", max_charges)
	elseif data.charge_time then
		local charge_time = 1 / (data.charge_time * 25 * 60)
		charges = charges + charge_time
		if charges >= 1 then
			ComponentSetValue2(item, "uses_remaining", current + 1)
			charges = charges - 1
		end
		if current >= max_charges or charge_time == -1 then charges = 0 end
	end
    ComponentSetValue2(var, "value_float", charges)
end

-- bootleg InheritTransformComponent
local root = EntityGetRootEntity(me)
local x, y = EntityGetTransform(root)
if root ~= me then
	EntitySetTransform(me, x, y - 2, 0)
end

-- discovery
if EntityHasTag(root, "player_unit") and data.id and ModSettingGet("noiting_simulator.spell_discovered_" .. data.id) ~= true then
    ModSettingSet("noiting_simulator.spell_discovered_" .. data.id, true)
	AddFlagPersistent("action_" .. string.lower(data.id))
end
if EntityHasTag(EntityGetParent(me), "wand") then
	EntitySetComponentsWithTagEnabled(me, "enable_when_on_wand", true)
	if EntityHasTag(me, "puppydog") then EntityAddTag(me, "puppydog_enabled") end
	if EntityHasTag(root, "player_unit") and not EntityHasTag(me, "spells_tip_check") then
		EntityAddTag(me, "spells_tip_check")
		local sprite2 = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "item_bg")
		local img = sprite2 and ComponentGetValue2(sprite2, "image_file")
		dofile_once("mods/noiting_simulator/files/scripts/gui_feed.lua")
		if ComponentGetValue2(item, "permanently_attached") then
			CallFeedMessage("card_alwayscasts")
		end
		if img == "data/ui_gfx/inventory/item_bg_other.png" then
			CallFeedMessage("card_activate")
		elseif img == "data/ui_gfx/inventory/item_bg_passive.png" then
			CallFeedMessage("card_passive")
		end
	end
else
	EntitySetComponentsWithTagEnabled(me, "enable_when_on_wand", false)
	if EntityHasTag(me, "puppydog") then EntityRemoveTag(me, "puppydog_enabled") end
end
if EntityHasTag(me, "kill_me") then
	local comps = EntityGetAllComponents(me)
	for i = 1, #comps do
		EntitySetComponentIsEnabled(me, comps[i], false)
	end
	EntityKill(me)
end

local function boop(who, x2, y2)
	EntityRemoveFromParent(who)
	EntityApplyTransform(who, x2, y2, 0)
	EntitySetComponentsWithTagEnabled(who, "enabled_in_world", true)
	EntitySetComponentsWithTagEnabled(who, "enabled_in_hand", false)
	EntitySetComponentsWithTagEnabled(who, "enabled_in_inventory", false)
	-- boop
	local velcomp = EntityGetFirstComponentIncludingDisabled(who, "VelocityComponent") or 0
	SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
	ComponentSetValue2(velcomp, "mVelocity", Random(-100, 100), Random(-50, -100))
end

-- activate spell type
local parent = EntityGetParent(me)
if parent and parent > 0 and EntityHasTag(parent, "wand") and EntityHasTag(me, "spell_type_activate") then
	if Just_got_parent then
		EntityRemoveTag(me, "spell_type_activate")
		local siblings = EntityGetAllChildren(parent, "spell_type_activate") or {}
		EntityAddTag(me, "spell_type_activate")
		local x2, y2 = EntityGetTransform(parent)
		for i = 1, #siblings do
			local item2 = EntityGetFirstComponentIncludingDisabled(siblings[i], "ItemComponent")
			if item2 and ComponentGetValue2(item2, "permanently_attached") then
				-- nvm
				boop(me, x2, y2)
				break
			else
				boop(siblings[i], x2, y2)
			end
		end
	end
	Just_got_parent = false
else
	Just_got_parent = true
end

--[[
local frames_without_parent = ComponentGetValue2(var, "value_int")
if parent and parent > 0 and EntityGetIsAlive(parent) then
	ComponentSetValue2(var, "value_int", 0)
else
	ComponentSetValue2(var, "value_int", frames_without_parent + 1)
end
]]--
local not_near_player = #EntityGetInRadiusWithTag(x, y, 96, "player_unit") == 0
if EntityHasTag(me, "collect_me") or (not_near_player and root == me) then
    local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
    local storage = GlobalsGetValue("NS_STORAGE_BOX_SPELLS", "") or ""
    local spellstorage = string.len(storage) > 0 and smallfolk.loads(storage) or {}

    spellstorage[data.id] = (spellstorage[data.id] or 0) + 1
	EntityLoad("data/entities/particles/poof_blue.xml", x, y)
	GlobalsSetValue("NS_LOG_SPELLS", tostring(tonumber(GlobalsGetValue("NS_LOG_SPELLS", "0")) + 1))

    GlobalsSetValue("NS_STORAGE_BOX_SPELLS", smallfolk.dumps(spellstorage))
	local comps = EntityGetAllComponents(me)
	for i = 1, #comps do
		EntitySetComponentIsEnabled(me, comps[i], false)
	end
	EntityKill(me)
end

-- temporary components
local comps = EntityGetAllComponents(me) or {}
for i = 1, #comps do
	if ComponentHasTag(comps[i], "remove_me_please2") then
		EntityRemoveComponent(me, comps[i])
	elseif ComponentHasTag(comps[i], "remove_me_please") then
		ComponentRemoveTag(comps[i], "remove_me_please")
		ComponentAddTag(comps[i], "remove_me_please2")
	end
end