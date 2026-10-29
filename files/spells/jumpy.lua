local me = GetUpdatedEntityID()
local player = EntityGetRootEntity(me)
local this = GetUpdatedComponentID()

local cdc = EntityGetFirstComponentIncludingDisabled(player, "CharacterDataComponent")
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "jumpy_sprite")
if not (cdc and sprite) then return end
local is_visible = ComponentGetValue2(sprite, "visible")
ComponentSetValue2(sprite, "visible", false)
EntitySetComponentIsEnabled(me, sprite, false)

local us = EntityGetWithTag("active_jumpy")
if us[1] ~= me then
	EntityRefreshSprite(me, sprite)
	ComponentSetValue2(this, "script_material_area_checker_failed", "-1")
	ComponentSetValue2(this, "script_material_area_checker_success", "0")
	return
end
local is_on_ground = ComponentGetValue2(cdc, "is_on_ground")

local current_timer = tonumber(ComponentGetValue2(this, "script_material_area_checker_failed") or "-1") or -1
local timer_speed = tonumber(ComponentGetValue2(this, "script_material_area_checker_success") or "0") or 0

if current_timer == -1 and is_on_ground then
	SetRandomSeed(GameGetFrameNum() + me, this + GameGetFrameNum())
	current_timer = 0
	timer_speed = Random(7, 10) / #us
end

local timer_go_time = 3
local timer_wiggle_room = 0.3

current_timer = current_timer + timer_speed / 400
if not is_on_ground then
	if current_timer > timer_go_time and current_timer < timer_go_time + timer_wiggle_room then
		dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
		for i = 1, #us do
			Shoot({file = "mods/noiting_simulator/files/spells/jumpy_bullet.xml", whoshot = player, target = "HEART"})
		end
	end
	current_timer = -1
	timer_speed = 0
end
if current_timer > -1 and current_timer < (timer_go_time + timer_wiggle_room) then
	local current_img = ComponentGetValue2(sprite, "image_file")
	local img = "mods/noiting_simulator/files/spells/jumpy_bar_" .. math.floor(current_timer) .. ".png"
	if (img ~= current_img) or is_visible ~= true then
		local sfx_path = "sfx/jumpy_" .. tostring(math.floor(current_timer + 1))
		local x, y = EntityGetTransform(me)
		GamePlaySound("mods/noiting_simulator/files/audio/sfx.bank", sfx_path, x, y)
	end
	ComponentSetValue2(sprite, "image_file", img)
	EntityRefreshSprite(me, sprite)
	EntitySetComponentIsEnabled(me, sprite, true)
	ComponentSetValue2(sprite, "visible", true)
end
ComponentSetValue2(this, "script_material_area_checker_failed", tostring(current_timer))
ComponentSetValue2(this, "script_material_area_checker_success", tostring(timer_speed))