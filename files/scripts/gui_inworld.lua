Gui2 = Gui2 or GuiCreate()

local gfx = {
    empty_img = "mods/noiting_simulator/files/gui/s_empty.png",
    full_img = "mods/noiting_simulator/files/gui/s_full.png",
    temp_img = "mods/noiting_simulator/files/gui/s_temp.png",
    flash_img = "mods/noiting_simulator/files/gui/s_flash.png",
    bg_img = "mods/noiting_simulator/files/gui/amulets/bg.png",
    bar_img = "mods/noiting_simulator/files/gui/amulets/bar.png",

	item_top = "mods/noiting_simulator/files/items/_top.png",
	item_slot = "mods/noiting_simulator/files/items/_itemslot.png",
}

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

return function()
    local _id = 33333
    local function id()
        _id = _id + 1
        return _id
    end

	if ModSettingGet("noiting_simulator.cheatcode_exhaustion") then
		local storage = GlobalsGetValue("NS_STAMINA", "") or ""
		local stam = string.len(storage) > 0 and smallfolk.loads(storage) or {}
		stam.max = math.min(stam.max, 1)
		stam.normal = math.min(stam.normal, 1)
		GlobalsSetValue("NS_STAMINA", smallfolk.dumps(stam))
	end

	local storage = tostring(GlobalsGetValue("NS_STAMINA", ""))
	local stam = string.len(storage) > 0 and smallfolk.loads(storage) or {}

    GuiStartFrame(Gui2)

	local border = "mods/noiting_simulator/files/gui/borders/" .. ModSettingGet("noiting_simulator.selected_border")

    local amulet = GlobalsGetValue("NS_AMULET", "nil")
    local amuletgem = GlobalsGetValue("NS_AMULETGEM", "nil")

    local scale = GUI_SCALE / 2

    local ix, iy = GuiGetImageDimensions(Gui2, border, 1)
    local scale_x = (BX - Margin) / ix
    local scale_y = SCREEN_H / iy

    Leftborder_x = ((BX - scale_x) - (ix * scale_x) - (Margin / 2) - 0.5) - ix * BATTLETWEEN * 1.5
    Rightborder_x = ((BW + scale_x) - (ix * scale_x * -2) + 0.5 + (Margin * 1.5)) + ix * BATTLETWEEN * 1.5

    local w, h = GuiGetImageDimensions(Gui2, gfx.empty_img, scale)
    local sx = ((BX - scale_x) - (ix * scale_x) - (Margin / 2) - 0.5) + ix * scale_x - (21 * BATTLETWEEN) - w - 1
    local sy = 46
    local x, y = sx - scale, sy

    -- charge
    if amulet ~= "nil" then
        local am = "mods/noiting_simulator/files/gui/amulets/a_" .. amulet .. ".png"
        local amw, amh = GuiGetImageDimensions(Gui2, am, scale)

        GuiZSet(Gui2, 19)
        GuiImage(Gui2, id(), x, y, gfx.bg_img, 1, scale, scale)
        GuiImage(Gui2, id(), x + amw + 2, y, gfx.bar_img, 1, scale * (BATTLETWEEN / 1), scale)
        GuiZSet(Gui2, 17)
        GuiImage(Gui2, id(), x, y, am, 1, scale, scale)
        if amuletgem ~= "nil" then
            local gm = "mods/noiting_simulator/files/gui/amulets/g_" .. amuletgem .. ".png"
            GuiZSet(Gui2, 18)
            GuiImage(Gui2, id(), x, y, gm, 1, scale, scale)
        end
        sy = sy + amh + (scale * 7)
    end

	local z = 5
	local deathtick = tonumber(GlobalsGetValue("NS_BATTLE_DEATHFRAME", "0"))
	if deathtick > 0 then
		z = -1111
	end

	local flash = stam.flash >= GameGetFrameNum()

	local inbattle = GlobalsGetValue("NS_IN_BATTLE", "0") == "1"
	if inbattle then
    	GuiOptionsAdd(Gui2, 2) -- NonInteractive
	end
	local largest_y = sy
    x, y = sx, sy
    for i = 1, stam.max do
        GuiZSetForNextWidget(Gui2, z + 2)
        GuiImage(Gui2, id(), x, y, gfx.empty_img, 1, scale, scale)
        y = y + h
		largest_y = math.max(y, largest_y)
		GuiTooltip(Gui2, GameTextGet("$ns_stamina_desc", stam.normal + stam.temp, stam.max), "")
    end
    for i = 1, stam.temp do
        GuiZSetForNextWidget(Gui2, z + 1)
        GuiImage(Gui2, id(), x, y, flash and gfx.flash_img or gfx.temp_img, 1, scale, scale)
        y = y + h
		largest_y = math.max(y, largest_y)
		GuiTooltip(Gui2, GameTextGet("$ns_stamina_desc", stam.normal + stam.temp, stam.max), "")
    end
    x, y = sx, sy
    for i = 1, stam.normal do
        GuiZSetForNextWidget(Gui2, z)
        GuiImage(Gui2, id(), x, y, flash and gfx.flash_img or gfx.full_img, 1, scale, scale)
        y = y + h
		largest_y = math.max(y, largest_y)
		GuiTooltip(Gui2, GameTextGet("$ns_stamina_desc", stam.normal + stam.temp, stam.max), "")
    end
	GuiOptionsRemove(Gui2, 2) -- NonInteractive

    GuiZSet(Gui2, z)
	local slotsw, slotsh = GuiGetImageDimensions(Gui2, gfx.item_slot, scale)

	local alpha = 1 - BATTLETWEEN

	dofile_once("mods/noiting_simulator/files/items/_list.lua")
	local items = smallfolk.loads(GlobalsGetValue("NS_ITEMS", "{}")) or {}

	y = largest_y + 4

	-- day + time
	local day_img = "mods/noiting_simulator/files/gui/time_markers/" .. "Monday" .. ".png"
	local time_img = "mods/noiting_simulator/files/gui/time_markers/" .. "Morning" .. ".png"
	local dtw, dth = GuiGetImageDimensions(Gui2, day_img)
	local ttw, tth = GuiGetImageDimensions(Gui2, time_img)
	GuiImage(Gui2, id(), x + w - dtw, y, day_img, alpha, scale, scale)
    GuiZSet(Gui2, z - 1)
	-- GuiText(Gui2, x, y, (GlobalsGetValue("NS_DAY", "???") or "???"))
	y = y + dth
    GuiZSet(Gui2, z)
	GuiImage(Gui2, id(), x + w - ttw, y, time_img, alpha, scale, scale)
    GuiZSet(Gui2, z - 1)
	-- GuiText(Gui2, x, y, (GlobalsGetValue("NS_TIME", "???") or "???"))
	y = y + tth
	-- GuiText(Gui2, x, y, (GlobalsGetValue("NS_WEATHER", "???") or "???"))

	local itw, ith = GuiGetImageDimensions(Gui2, gfx.item_top)

	if #items > 0 then GuiImage(Gui2, id(), x, y + ith, gfx.item_top, alpha, scale, scale) end
	y = y + 5 + ith
	x = x + (w - slotsw) / 2
	local padding = 2

    GuiZSet(Gui2, 199)
    GuiImage(Gui2, id(), Leftborder_x, 0, border, 1, scale_x, scale_y)
    GuiImage(Gui2, id(), Rightborder_x, 0, border, 1, -scale_x, scale_y)
	Border_size = ix * scale_x

	for i = 1, #items do
		GuiZSet(Gui2, z)
		GuiImage(Gui2, id(), x, y, gfx.item_slot, alpha, scale, scale)
		GuiZSet(Gui2, z - 1)
		local item = ITEMS[items[i]]
		if item then -- item exists
			local img = item.sprite
			local lw, lh = GuiGetImageDimensions(Gui2, img, scale)
			GuiImage(Gui2, id(), x + (slotsw - lw) / 2, y + (slotsh - lh) / 2, img, alpha, scale, scale)

			GuiImage(Gui2, id(), x, y, gfx.item_slot, 0, scale, scale) -- invisible box for tooltip
			GuiTooltip(Gui2, string.upper(GameTextGetTranslatedOrNot(item.name)), item.desc)
		end
		y = y + slotsh + padding
	end


	if ModSettingGet("noiting_simulator.cheatcode_data") == true then
		-- DEBUGGY!!!!!!!
		GuiZSet(Gui2, -33)
		Debug_data_display = Debug_data_display == nil and false or Debug_data_display
		local titlebar_pos = 30
		local debug_spacing = 12
		Debug_y_pos = Debug_y_pos or 0
		local ck, rk = GuiButton(Gui2, id(), x - 15, y, "[DATA]")
		if ck or rk then
			Debug_data_display = not Debug_data_display
		end
		if Debug_data_display then
			local data = smallfolk.loads(GlobalsGetValue("NS_STORY_DATA", "{}")) or {}
			local the_y = titlebar_pos
			GuiColorSetForNextWidget(Gui2, 0.7, 0.7, 0.7, 1)
			GuiText(Gui2, 80, the_y, "Data goes here!")

			GuiColorSetForNextWidget(Gui2, 0.6, 0.6, 1, 1)
			local cka, ckb = GuiButton(Gui2, id(), 150, the_y, "^^^^^")
			GuiColorSetForNextWidget(Gui2, 0.6, 0.6, 1, 1)
			local ckc, ckd = GuiButton(Gui2, id(), 190, the_y, "vvvvv")
			Debug_y_pos = Debug_y_pos + (
				ckc and debug_spacing or
				ckd and debug_spacing * 3 or
				cka and -debug_spacing or
				ckb and -debug_spacing * 3 or
				0
			)
			Debug_y_pos = math.min(0, Debug_y_pos)

			the_y = the_y + debug_spacing
			GuiColorSetForNextWidget(Gui2, 0.3, 0.7, 0.3, 1)
			GuiText(Gui2, 80, the_y, table.concat({"DAY: ", GlobalsGetValue("NS_DAY"), ", TIME: ", GlobalsGetValue("NS_TIME"), ", LOCATION: ", GlobalsGetValue("NS_LOCATION", "???")}))

			the_y = the_y + Debug_y_pos
			local counter = 0
			for a, b in pairs(data) do
				counter = counter + 1
				the_y = the_y + debug_spacing
				if the_y > (titlebar_pos + debug_spacing * 1.5) then
					if the_y > (titlebar_pos + debug_spacing * 13.5) then
						GuiColorSetForNextWidget(Gui2, 0.9, 0.3, 0.3, 1)
						GuiText(Gui2, 80, the_y, "...")
						break
					else
						GuiColorSetForNextWidget(Gui2, 0.2, 0.7, 0.7, 1)
						GuiText(Gui2, 80, the_y, table.concat({tostring(counter), ": ", tostring(a), " = ", tostring(b)}))
					end
				end
			end
		end
	end

    -- GuiText(Gui2, spacing, y, day .. ": " .. time, GUI_SCALE, DEFAULT_FONT)
end