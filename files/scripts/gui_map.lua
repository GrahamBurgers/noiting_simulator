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

local paths = {
	plaza_park = true, plaza_market = true, market_apartments = true, market_arcade = true, market_lakeside = true, lakeside_island = true,
	park_forest = true, park_library = true, park_theater = true, plaza_graveyard = "firstentry_graveyard", plaza_mountain = true, theater_pyramid = true,
	apartments_fungus = true, library_fungus = true,
	forest_sunseed = "vine_untangle_done", arcade_sunseed = true,
	island_pyramid = true,
}

local valid_date_spots = {
	healer = {
		["arcade"] = true, ["library"] = true, ["theater"] = true, ["park"] = true, ["lakeside"] = true, ["forest"] = true,
		["intro"]         = "S-so, um... Where to?",
		["undiscovered"]  = "U-um...? What?",
		["already_dated"] = "O-oh... We've already been there, though, haven't we?",
		["fungus"]        = "L-let's, um... not...",
		["plaza"]         = "The Mountain Altar...? Y-you know I can't fly, silly...",
		["apartments"]    = "L-Let's go somewhere that's further away from my work... a-and home..."
	}
}

local imgs = {
	map = "mods/noiting_simulator/files/gui/map/map_icons.png",
	map_small = "mods/noiting_simulator/files/gui/map/map_small.png",
	hidden = "mods/noiting_simulator/files/gui/map/map_hidden.png",
	hidden_small = "mods/noiting_simulator/files/gui/map/map_hidden_small.png",
	bg = "mods/noiting_simulator/files/gui/map/map_bg.png",
	bg_small = "mods/noiting_simulator/files/gui/map/map_small_bg.png",
	white_small = "mods/noiting_simulator/files/gui/map/map_small_white.png",
	location_1 = "mods/noiting_simulator/files/gui/map/map_location_1.png",
	location_2 = "mods/noiting_simulator/files/gui/map/map_location_2.png",
	location_small_1 = "mods/noiting_simulator/files/gui/map/map_location_small_1.png",
	location_small_2 = "mods/noiting_simulator/files/gui/map/map_location_small_2.png",
	valid_date_marker_1 = "mods/noiting_simulator/files/gui/map/valid_date_marker_1.png",
	valid_date_marker_2 = "mods/noiting_simulator/files/gui/map/valid_date_marker_2.png",
	you_decide = "mods/noiting_simulator/files/gui/map/you_decide.png",
	you_decide2 = "mods/noiting_simulator/files/gui/map/you_decide2.png",
	toolbox = "mods/noiting_simulator/files/gui/toolbox_button.png",
	toolbox_open = "mods/noiting_simulator/files/gui/toolbox_button_open.png",
	toolbox_white = "mods/noiting_simulator/files/gui/toolbox_white.png",
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
	local marker = (tick and imgs.valid_date_marker_1 or imgs.valid_date_marker_2)
	GuiStartFrame(Gui5)
	local mx, my = GuiGetImageDimensions(Gui5, map)
	local scale = (Border_size / mx) * Scale

	local scale2 = 2
	local tx, ty = GuiGetImageDimensions(Gui5, imgs.toolbox, scale2)

	local x, y = Rightborder_x - mx * scale, 50 + ty
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

	local date_selecty = GlobalsGetValue("TEXT_HANDOFF_VALUE", "0") == "DATE_MAP_SELECTOR"
	local date_character
	if date_selecty then
		date_character = GlobalsGetValue("DATE_MAP_CHARACTER", "")
	end

	GuiZSet(Gui5, 9)
	GuiImage(Gui5, id(), Realx, Realy, bg, 1, scale, scale, 0)
	local ck, _, hover = GuiGetPreviousWidgetInfo(Gui5)
	if ck then
		Use_small = not Use_small
	end
	if date_selecty then
		Use_small = false
	end
	if (GlobalsGetValue("NS_STORAGE_BOX_FRAME", "0") ~= "0") or (GlobalsGetValue("NS_IN_BATTLE", "0") ~= "0") then
		Use_small = true
	end
	if hover and Use_small then
		GuiZSet(Gui5, 6)
		GuiImage(Gui5, id(), Realx, Realy, imgs.white_small, 0.1, scale, scale, 0)
	end
	GuiZSet(Gui5, 8)
	GuiImage(Gui5, id(), Realx, Realy, map, 1, scale, scale, 0)
	GlobalsSetValue("MAP_BE_BIG", Use_small and "NAY" or "YEA")

	local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
	Character_text = Character_text or ""
	Character_num = Character_num or 0
	for i, j in pairs(icons_list) do
		GuiZSet(Gui5, 7)
		local area_is_unlocked = ModSettingGet("noiting_simulator.area_discovered_ " .. i)
		GuiImage(Gui5, id(), Realx + j.x * icon_w * scale, Realy + j.y * icon_h * scale, hidden, area_is_unlocked and 0 or 1, scale, scale, 0)
		local ck2, rk2, hovered2 = GuiGetPreviousWidgetInfo(Gui5)
		local date_info = date_character and valid_date_spots[date_character][i]
		local can_do_date_here = area_is_unlocked and date_character and date_info == true
		if hovered2 then
			local str = GameTextGet("$ns_area_undiscovered")
			if area_is_unlocked then
				str = GameTextGet("$ns_area_" .. i)
				if can_do_date_here then
					str = GameTextGet("$ns_valid_date_location", str)
				end
			end
			GuiTooltip(Gui5, str, "")
		end
		Data = smallfolk.loads(GlobalsGetValue("NS_STORY_DATA", "{}")) or {}
		if date_character and Data[table.concat({"date_done_", date_character, "_", i})] then -- date_done_healer_park
			if ck2 then
				Character_num = 0
				Character_text = valid_date_spots[date_character]["already_dated"]
			end
		elseif can_do_date_here and not Use_small then
			GuiZSet(Gui5, 1.9)
			GuiImage(Gui5, id(), Realx + (j.x * icon_w * scale) - scale, Realy + (j.y * icon_h * scale) - scale, marker, 1, scale, scale, 0)
			if ck2 then
				GlobalsSetValue("TEXT_HANDOFF_VALUE", "0")
				GlobalsSetValue("FORCE_SEND_ID", i)
				GlobalsSetValue("FORCE_SEND_FILE", "mods/noiting_simulator/files/scenes/characters/" .. date_character .. "_dates.lua")
				Use_small = true
			end
		elseif date_character and ck2 then
			Character_num = 0
			Character_text = date_info
			if not area_is_unlocked then Character_text = valid_date_spots[date_character]["undiscovered"] end
		end
		if Location == i then
			GuiZSet(Gui5, 2)
			GuiImage(Gui5, id(), Realx + (j.x * icon_w * scale) - scale, Realy + (j.y * icon_h * scale) - scale, selector, 1, scale, scale, 0)
		end
	end
	if date_character and not Use_small then
		if Character_text == "" then
			Character_text = valid_date_spots[date_character]["intro"]
		end
		Character_num = Character_num + 1
		local yx, yy = GuiGetImageDimensions(Gui5, imgs.you_decide)
		local youx, youy = Realx + (mx - yx) * scale / 2, Realy + my * scale
		GuiImage(Gui5, id(), youx, youy, imgs.you_decide, 0, scale, scale, 0)
		local ck2, rk2, hover2 = GuiGetPreviousWidgetInfo(Gui5)
		if ck2 then
			GlobalsSetValue("TEXT_HANDOFF_VALUE", "0")
			GlobalsSetValue("FORCE_SEND_ID", "main")
			GlobalsSetValue("FORCE_SEND_FILE", "mods/noiting_simulator/files/scenes/characters/" .. date_character .. "_dates.lua")
			Use_small = true
		end
		GuiImage(Gui5, id(), youx, youy, hover2 and imgs.you_decide2 or imgs.you_decide, 1, scale, scale, 0)

		dofile("mods/noiting_simulator/settings.lua")
		for i = 1, #CHARACTERS do
			if CHARACTERS[i].id == date_character and type(Character_text) == "string" then
				local text_scale = 1.5
				local str = string.sub(Character_text, 0, Character_num)
				local tw, th = GuiGetTextDimensions(Gui5, str, text_scale, 0, DEFAULT_FONT)

				GuiImage(Gui5, id(), (Realx - (8 * scale)) + (mx * scale / 2), youy + yy * 2, CHARACTERS[i].icon, 1, scale, scale, 0)
				GuiColorSetForNextWidget(Gui5, CHARACTERS[i].color[1] / 255, CHARACTERS[i].color[2] / 255, CHARACTERS[i].color[3] / 255, CHARACTERS[i].color[4] / 255)
				GuiText(Gui5, (Realx - (tw / 2)) + (mx * scale / 2), youy + yy * 4, str, text_scale, DEFAULT_FONT)
			end
		end
	else
		Character_text = ""
	end

	local hi_data = smallfolk.loads(GlobalsGetValue("NS_STORY_DATA", "{}")) or {}
	for i, j in pairs(paths) do
		if (not Use_small) and ModSettingGet("noiting_simulator.path_" .. i) then
			local file = "mods/noiting_simulator/files/gui/map/path_" .. i
			if j ~= true and (hi_data[j] ~= true) then
				file = file .. "_locked"
			end
			GuiZSet(Gui5, 1.9)
			GuiImage(Gui5, id(), Realx, Realy, file .. ".png", 1, scale, scale, 0)
		end
	end

	mx, _ = GuiGetImageDimensions(Gui5, imgs.map, 1)
	_, my = GuiGetImageDimensions(Gui5, imgs.map_small, 1)
	x, y = (Rightborder_x - tx) - (mx / 8), 50

	local toolbox_exists = #EntityGetWithTag("storage_box") > 0
	local specl = #EntityGetWithTag("special_storge") > 0
	GuiZSet(Gui5, 10)
	GuiImage(Gui5, id(), x, y, specl and imgs.toolbox_open or imgs.toolbox, 1, scale2, scale2, 0)
	GuiTooltip(Gui5, "$ns_storage_box_storage", "")
	local ck2, _, hover2 = GuiGetPreviousWidgetInfo(Gui5)
	if hover2 then
		GuiZSet(Gui5, 9)
		GuiImage(Gui5, id(), x, y, imgs.toolbox_white, 0.1, scale2, scale2, 0)
	end
	if ck2 and not toolbox_exists then
		local cx, cy = tonumber(GlobalsGetValue("NS_CAM_X", "nil")) or 0, tonumber(GlobalsGetValue("NS_CAM_Y", "nil")) or 0
		local entity_interacted = EntityLoad("mods/noiting_simulator/files/spells/storage_box/storage_box.xml", cx, cy + 30)
		local sprite = EntityGetFirstComponentIncludingDisabled(entity_interacted, "SpriteComponent", "box") or 0
		local interact = EntityGetFirstComponentIncludingDisabled(entity_interacted, "InteractableComponent") or 0
		local move = EntityGetFirstComponentIncludingDisabled(entity_interacted, "VelocityComponent") or 0
		GlobalsSetValue("NS_STORAGE_BOX_FRAME", tostring(GameGetFrameNum()))
		GlobalsSetValue("NS_BOX_FREE", "NO")
		GlobalsSetValue("NS_STORAGE_BOX_JUST_LOOKING", "1")
		ComponentSetValue2(sprite, "rect_animation", "open")
		ComponentSetValue2(interact, "radius", 100000)
		EntityRefreshSprite(entity_interacted, sprite)
		EntitySetComponentIsEnabled(entity_interacted, move, false)
		EntityAddTag(entity_interacted, "special_storge")
	elseif ck2 and GlobalsGetValue("NS_STORAGE_BOX_JUST_LOOKING", "0") == "1" then
		GlobalsSetValue("NS_STORAGE_BOX_JUST_LOOKING", "0")
		local boxboxboxboxbox = EntityGetWithTag("storage_box")
		for i = 1, #boxboxboxboxbox do
			EntityAddTag(boxboxboxboxbox[i], "boxboxboxboxboxboxb")
		end
	end
end