Gui4 = Gui4 or GuiCreate()

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local prefix = "mods/noiting_simulator/files/gui/characters/"

local default_scale = 0.33

--[[
VALID PARAMS:

kill_now      : Kills it if true.
file          : Image path, XML or PNG. Set this to nil to kill the sprite.
x, y          : (0, 0) is top-left of the canvas, (1, 1) is bottom-right. Default (0.5, 0.5)
target_x, target_y, target_div: Moves x and y towards this point, divided by div. Div default 10.
squish, squish_div : Squishes sprite. Automatically unsquishes based on div. Div default 6. Characters will be auto-squished if their ID is talking.
w, h          : This is automatically set when adding a sprite. Only set it manually if you need to lie to the system?
created_frame : This is automatically set when adding a sprite. Only set it manually if you need to lie to the system?
scalex, scaley, scale: Default is 2. scalex or scaley fall back on scale if unset.
center        : Defaults to true. Otherwise, sprite is anchored top-left.
rot         : Rotation in radians.
alpha       : 0-1. Self explanatory.
anim        : Animation name to play. Defaults to "idle".
animtype    : 0: Play to end and hide, 1: Play to end and pause, 2: Loop.
z_offset    : Larger z = deeper. This is added to the default z of 250.
sin         : Table of values that modifies other values here. Includes offset, amplitude, and speed. Use a key to set.
]]--
local example_table = {
	text = [[hello there]], sprites = {
		a = {file = "pointer_center.png", x = 0, y = 0},
		b = {file = "pointer_center.png", x = 0.25, y = 0.25, alpha = 1},
		c = {file = "hamis.xml", x = 0.5, y = 0.5, tags = "character", sin = {scalex = {amplitude = 1, offset = 30}, scaley = {amplitude = 1}}},
		d = {file = "pointer_center.png", x = 0.75, y = 0.75},
		e = {file = "pointer_center.png", x = 1, y = 1},
		kill_all = true,
		speaker_id = "c"
	}
}
local presets = {
	slide_in_from_left = {x = -0.25, target_x = 0.5},
	slide_in_from_right = {x = 1.25, target_x = 0.5},
	slide_left_and_die = {target_x = -0.25, kill_when_offscreen = true},
	slide_right_and_die = {target_x = 1.25, kill_when_offscreen = true},
	fade_out_and_die = {fade_out_and_die = 0.1}
}

function Input(data)
    local storage = tostring(GlobalsGetValue("NS_SPRITES", ""))
    local s = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	for i, g in pairs(data) do
		if i == "kill_all" then
			s = {}
		else
			for j, v in pairs(g) do
				s[i] = s[i] or {}
				s[i][j] = v
				if j == "preset" then
					for a, b in pairs(presets[v]) do
						s[i][a] = b
					end
				end
				if s[i].file == nil then
					s[i] = {}
				end
			end
		end
	end
	GlobalsSetValue("NS_SPRITES", smallfolk.dumps(s))
end

return function()
	local _id = 22222
	local function id()
		_id = _id + 1
		return _id
	end

	local changes_made = false
    local storage = tostring(GlobalsGetValue("NS_SPRITES", ""))
    local s = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	GuiStartFrame(Gui4)
    GuiOptionsAdd(Gui4, 2) -- NonInteractive
	for i, v in pairs(s) do
		v.x = v.x or 0.5
		v.y = v.y or 0.5
		local x, y, file = v.x, v.y, v.file

		file = file or "blank.png"
		if not (v.kill_now) then
			if not (v.created_frame) then
				v.created_frame = GameGetFrameNum()
				changes_made = true
			end
			local target_div = v.target_div or 10
			if v.target_x then
				v.x = v.x + (v.target_x - v.x) / target_div
				changes_made = true
			end
			if v.target_y then
				v.y = v.y + (v.target_y - v.y) / target_div
				changes_made = true
			end
			file = prefix .. file
			local scalex = v.scalex or v.scale or default_scale
			local scaley = v.scaley or v.scale or default_scale
			local fade_out_and_die = v.fade_out_and_die or 0
			local center = v.center or true
			local alpha = v.alpha or 1
			local rot = v.rot or 0
			local sins = v.sin or {}
			if fade_out_and_die > 0 then
				alpha = alpha - fade_out_and_die
				if alpha <= 0 then
					v.fade_out_and_die = 0
					v.kill_now = true
				end
				v.alpha = alpha
				changes_made = true
			end
			for e, f in pairs(sins) do
				local sine = math.sin(((GameGetFrameNum() - v.created_frame) - (f.offset or 0)) * (math.pi / 60) * (f.speed or 1)) * (f.amplitude or 1)
				x = (e == "x" and x + sine) or x
				y = (e == "y" and y + sine) or y
				scalex = ((e == "scalex" or e == "scale") and scalex + sine) or scalex
				scaley = ((e == "scaley" or e == "scale") and scaley + sine) or scaley
				alpha = (e == "alpha" and alpha + sine) or alpha
				rot = (e == "rot" and rot + sine) or rot
			end
			x = (BX + (x * (BW + Margin * 2))) - Margin
			y = (y * ((SCREEN_H - BH) - Margin * 2))
			if (v.last_file ~= v.file) or not (v.w and v.h) then
				v.last_file = v.file
				-- fake image to get the dimensions
				GuiImage(Gui4, id(), x, y, file, 0, 1, 1, rot, v.anim_type or 2, v.anim or "idle")
				local _, _, _, _, _, w, h = GuiGetPreviousWidgetInfo(Gui4)
				v.w = w
				v.h = h
				changes_made = true
			end
			if center then
				x = x + (v.w * scalex) / -2
				y = y + (v.h * scaley) / -2
			end
			v.squish = v.squish == true and 0.95 or v.squish or 1
			if v.squish < 1 then
				v.squish = v.squish + (1 - v.squish) / (v.squish_div or 6)
				scaley = scaley * v.squish
				y = y + (v.h * scaley * (1 - v.squish)) -- bottom align
				changes_made = true
			end
			if v.kill_when_offscreen == true and
					((x - (v.w / 2) > SCREEN_W) or
					(x + (v.w / 2) < 0) or
					(y - (v.h / 2) > SCREEN_H) or
					(y + (v.h / 2) < 0)) then
				v.kill_when_offscreen = false
				v.kill_now = true
				changes_made = true
			end
			GuiZSetForNextWidget(Gui4, 250 + (v.z_offset or 0))
			alpha = alpha * (1 - BATTLETWEEN)
			GuiImage(Gui4, id(), x, y, file, alpha or 1, scalex, scaley, rot, v.anim_type or 2, v.anim or "idle")
		else
			s[i] = nil
			changes_made = true
		end
	end
	if changes_made then
		GlobalsSetValue("NS_SPRITES", smallfolk.dumps(s))
	end
end