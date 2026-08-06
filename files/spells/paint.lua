local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
local sprite = EntityGetFirstComponent(me, "SpriteComponent", "paint")
if not (v and sprite) then return end

ComponentRemoveTag(this, "paint_crit")
local percent = 0.30
local x_threshold = (x > v.arena_x + v.arena_x * percent) and "right" or (x < v.arena_x - v.arena_x * percent) and "left" or "hor"
local y_threshold = (y < v.arena_y - v.arena_h * percent) and "up" or (y > v.arena_y + v.arena_h * percent) and "down" or "ver"
local paint_color = (
	(x_threshold == "hor" and y_threshold == "up" and "ns_paint_blue") or
	(x_threshold == "left" and y_threshold == "up" and "ns_paint_lightblue") or
	(x_threshold == "right" and y_threshold == "up" and "ns_paint_grey") or

	(x_threshold == "right" and y_threshold == "ver" and "ns_paint_white") or
	(x_threshold == "left" and y_threshold == "ver" and "ns_paint_green") or

	(x_threshold == "hor" and y_threshold == "down" and "ns_paint_red") or
	(x_threshold == "left" and y_threshold == "down" and "ns_paint_purple") or
	(x_threshold == "right" and y_threshold == "down" and "ns_paint_pink") or
	"none"
)
ComponentSetValue2(this, "script_material_area_checker_failed", paint_color)
if paint_color ~= "none" then
	ComponentAddTag(this, "paint_crit")
	ComponentSetValue2(sprite, "visible", true)
else
	ComponentSetValue2(sprite, "visible", false)
end