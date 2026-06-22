Gui5 = Gui5 or GuiCreate()

local icons_list = {
	["fungus"]     = {x = 3, y = 0},

	["apartments"] = {x = 2, y = 1},
	["mountain"]   = {x = 3, y = 1},
	["library"]    = {x = 4, y = 1},

	["island"]     = {x = 0, y = 2},
	["lakeside"]   = {x = 1, y = 2},
	["market"]     = {x = 2, y = 2},
	["plaza"]      = {x = 3, y = 2},
	["park"]       = {x = 4, y = 2},
	["theater"]    = {x = 5, y = 2},
	["pyramid"]    = {x = 6, y = 2},

	["arcade"]     = {x = 2, y = 3},
	["graveyard"]  = {x = 3, y = 3},
	["forest"]     = {x = 4, y = 3},

	["sunseed"]    = {x = 3, y = 4},
}

local imgs = {
	map = "mods/noiting_simulator/files/gui/map_icons.png",
	map_small = "mods/noiting_simulator/files/gui/map_small.png",
	hidden = "mods/noiting_simulator/files/gui/map_hidden.png",
	hidden_small = "mods/noiting_simulator/files/gui/map_hidden_small.png",
	bg = "mods/noiting_simulator/files/gui/map_bg.png",
	bg_small = "mods/noiting_simulator/files/gui/map_small_bg.png",
	white_small = "mods/noiting_simulator/files/gui/map_small_white.png",
	location_1 = "mods/noiting_simulator/files/gui/map_location_1.png",
	location_2 = "mods/noiting_simulator/files/gui/map_location_2.png",
	location_small_1 = "mods/noiting_simulator/files/gui/map_location_small_1.png",
	location_small_2 = "mods/noiting_simulator/files/gui/map_location_small_2.png",
}

return function()
	local _id = 44444
	local function id()
		_id = _id + 1
		return _id
	end

	Location = GlobalsGetValue("NS_LOCATION", "plaza")

	Use_small = (Use_small == nil and true) or Use_small
	Scale = Scale or 1

	local icon_w = Use_small and (2 + 1) or (11 + 5)
	local icon_h = Use_small and (2 + 1) or (12 + 4)
	local map = Use_small and imgs.map_small or imgs.map
	local hidden = Use_small and imgs.hidden_small or imgs.hidden
	local bg = Use_small and imgs.bg_small or imgs.bg
	local tick = (GameGetFrameNum() % 100) < 50
	local selector = Use_small and (tick and imgs.location_small_1 or imgs.location_small_2) or (tick and imgs.location_1 or imgs.location_2)
	GuiStartFrame(Gui5)
	local mx, my = GuiGetImageDimensions(Gui5, map)
	local scale = (Border_size / mx) * Scale

	local x, y = Rightborder_x - mx * scale, 50
	local x2, y2 = SCREEN_W / 2 + ((mx * scale) / -2), BY + ((my * scale) / -1) - Margin
	Realx, Realy = Realx or x, Realy or y
	if Use_small then
		Realx = Realx + (x - Realx) / 6
		Realy = Realy + (y - Realy) / 6
		Scale = Scale + (1 - Scale) / 6
	else
		Realx = Realx + (x2 - Realx) / 6
		Realy = Realy + (y2 - Realy) / 6
		Scale = Scale + (3 - Scale) / 6
	end

	GuiZSet(Gui5, 9)
	GuiImage(Gui5, id(), Realx, Realy, bg, 1, scale, scale, 0)
	local ck, _, hover = GuiGetPreviousWidgetInfo(Gui5)
	if ck then
		Use_small = not Use_small
	end
	if hover and Use_small then
		GuiZSet(Gui5, 6)
		GuiImage(Gui5, id(), Realx, Realy, imgs.white_small, 0.1, scale, scale, 0)
	end
	GuiZSet(Gui5, 8)
	GuiImage(Gui5, id(), Realx, Realy, map, 1, scale, scale, 0)

	for i, j in pairs(icons_list) do
		GuiZSet(Gui5, 7)
		local area_is_unlocked = true or ModSettingGet("noiting_simulator.area_discovered_ " .. i)
		GuiImage(Gui5, id(), Realx + j.x * icon_w * scale, Realy + j.y * icon_h * scale, hidden, area_is_unlocked and 0 or 1, scale, scale, 0)
		local _, _, hovered2 = GuiGetPreviousWidgetInfo(Gui5)
		if hovered2 and not Use_small then
			GuiTooltip(Gui5, area_is_unlocked and GameTextGet("$ns_area_" .. i) or GameTextGet("$ns_area_undiscovered"), "")
		end
		if Location == i then
			GuiZSet(Gui5, 2)
			GuiImage(Gui5, id(), Realx + (j.x * icon_w * scale) - scale, Realy + (j.y * icon_h * scale) - scale, selector, 1, scale, scale, 0)
		end
	end
end