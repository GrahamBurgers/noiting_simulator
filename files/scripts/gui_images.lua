Gui4 = Gui4 or GuiCreate()

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local prefix = "mods/noiting_simulator/files/gui/characters/"

local default_scale = 2

--[[
VALID PARAMS:

file       : Image path. XML is borked currently. Set this to nil to kill the sprite.
x, y       : (0, 0) is top-left of the canvas, (1, 1) is bottom-right.
w, h       : This is automatically set when adding a sprite. Only set it manually if you need to lie to the system?
scalex, scaley, scale: Default is 2. scalex or scaley fall back on scale if unset.
center     : Defaults to true. Otherwise, sprite is anchored top-left.
v.rot      : Rotation in radians.
v.alpha    : 0-1. Self explanatory.
v.anim     : Animation name to play. Defaults to "idle".
v.animtype : 0: Play to end and hide, 1: Play to end and pause, 2: Loop.
v.z_offset : Larger z = deeper. This is added to the default z of 5.
]]--


function Input(data)
    local storage = tostring(GlobalsGetValue("NS_SPRITES", ""))
    local s = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	for i, g in pairs(data) do
		for j, v in pairs(g) do
			s[i] = s[i] or {}
			s[i][j] = v
		end
	end
	GlobalsSetValue("NS_SPRITES", smallfolk.dumps(s))
end

local _id = 1234
local function id()
	_id = _id + 1
	return _id
end

return function()
	local changes_made = false
    local storage = tostring(GlobalsGetValue("NS_SPRITES", ""))
    local s = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	GuiStartFrame(Gui4)
    GuiOptionsAdd(Gui2, 2) -- NonInteractive
	for i, v in pairs(s) do
		local x, y, file = v.x, v.y, v.file

		if x and y and file then
			file = prefix .. file
			local scalex = v.scalex or v.scale or default_scale
			local scaley = v.scaley or v.scale or default_scale
			local center = v.center or true
			x = (BX + (x * (BW + Margin * 2))) - Margin
			y = (y * ((SCREEN_H - BH) - Margin * 2))
			if not (v.w and v.h) then
				-- fake image to get the dimensions
				GuiImage(Gui4, id(), x, y, file, 0, scalex, scaley, v.rot or 0, v.anim_type or 2, v.anim or "idle")
				local _, _, _, _, _, w, h = GuiGetPreviousWidgetInfo(Gui4)
				v.w = w
				v.h = h
				changes_made = true
			end
			if center then
				x = x + v.w / -2
				y = y + v.h / -2
			end
			GuiZSetForNextWidget(Gui4, 35 + (v.z_offset or 0))
			GuiImage(Gui4, id(), x, y, file, v.alpha or 1, scalex, scaley, v.rot or 0, v.anim_type or 2, v.anim or "idle")
		else
			v = nil
			changes_made = true
		end
	end
	if changes_made then
		GlobalsSetValue("NS_SPRITES", smallfolk.dumps(s))
	end
end