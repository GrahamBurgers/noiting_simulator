Gui4 = Gui4 or GuiCreate()
local img = "mods/noiting_simulator/files/gui/portraits/hamis.xml"

Res_x = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")) or 0
Res_y = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")) or 0

function CreateSprite(id)
	EntityCreateNew(id)
end

function SetSprite(id)
	local entity = EntityGetWithName(id)
end

function DestroySprite(id)
	local entity = EntityGetWithName(id)
	if entity and entity > 0 then EntityKill(entity) end
end

return function()
	local cam_x, cam_y = GameGetCameraPos()
	local res_x = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")) or 0
	local res_y = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")) or 0
	local s_w, s_h = GuiGetScreenDimensions(Gui3)
	local vx = cam_x + res_x / 2
	local vy = cam_y + res_y / 2
	local gui_x = vx * s_w / res_x
	local gui_y = vy * s_h / res_y
end