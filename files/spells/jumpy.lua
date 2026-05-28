local me = GetUpdatedEntityID()
local player = EntityGetRootEntity(me)
local this = GetUpdatedComponentID()

local cdc = EntityGetFirstComponentIncludingDisabled(player, "CharacterDataComponent")
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "jumpy_sprite")
if not (cdc and sprite) then return end
local us = EntityGetWithTag("active_jumpy")
if us[1] ~= me then
	EntitySetComponentIsEnabled(me, sprite, false)
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
local timer_wiggle_room = 0.4

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
	local img = "mods/noiting_simulator/files/spells/jumpy_bar_" .. math.floor(current_timer) .. ".png"
	ComponentSetValue2(sprite, "image_file", img)
	EntityRefreshSprite(me, sprite)
	EntitySetComponentIsEnabled(me, sprite, true)
else
	EntitySetComponentIsEnabled(me, sprite, false)
end

ComponentSetValue2(this, "script_material_area_checker_failed", tostring(current_timer))
ComponentSetValue2(this, "script_material_area_checker_success", tostring(timer_speed))