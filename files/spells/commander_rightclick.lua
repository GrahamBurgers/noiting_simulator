local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local root = EntityGetRootEntity(me)
-- commander
local is_in_hand = EntityGetFirstComponent(me, "VariableStorageComponent", "hand_checker") ~= nil
local controls = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local inworld = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "item_identified")
if not (controls and item and inworld) then return end

if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") % 60 == 0 then
	dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
	Shoot({file = "mods/noiting_simulator/files/spells/sparkle.xml", forced_speed = 0, whoshot = EntityGetRootEntity(me), comedic_multiplier = 0})
end

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
	commander_type = tostring(commander_type == "NONE" and "TYPELESS" or commander_type)
	local particle = EntityLoad("mods/noiting_simulator/files/spells/explosions/mini_typeless.xml", x, y - 2)
	local img = EntityGetFirstComponentIncludingDisabled(particle, "ParticleEmitterComponent")
	if img then
		ComponentSetValue2(img, "emitted_material_name", (commander_type == "TYPELESS" and "material_confusion") or
		(commander_type == "CUTE" and "plasma_fading_pink") or
		(commander_type == "CHARMING" and "spark_yellow") or
		(commander_type == "CLEVER" and "spark_blue") or
		(commander_type == "COMEDIC" and "spark_green"))
		EntitySetComponentIsEnabled(me, img, true)
		ComponentSetValue2(img, "is_emitting", true)
	end
	ComponentSetValue2(inworld, "image_file", sprite)
	EntityRefreshSprite(me, inworld)
end