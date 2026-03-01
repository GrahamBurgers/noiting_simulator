Gui2 = Gui2 or GuiCreate()

local gfx = {
    empty_img = "mods/noiting_simulator/files/gui/s_empty.png",
    full_img = "mods/noiting_simulator/files/gui/s_full.png",
    temp_img = "mods/noiting_simulator/files/gui/s_temp.png",
    flash_img = "mods/noiting_simulator/files/gui/s_flash.png",
    border_img = "mods/noiting_simulator/files/gui/borders/border_test.png",
    bg_img = "mods/noiting_simulator/files/gui/amulets/bg.png",
    bar_img = "mods/noiting_simulator/files/gui/amulets/bar.png",

	item_top = "mods/noiting_simulator/files/items/_top.png",
	item_slot = "mods/noiting_simulator/files/items/_itemslot.png",
}

local itemdata = dofile_once("mods/noiting_simulator/files/items/_list.lua")
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

return function()
    local _id = 40
    local function id()
        _id = _id + 1
        return _id
    end

	local storage = tostring(GlobalsGetValue("NS_STAMINA", ""))
	local stam = string.len(storage) > 0 and smallfolk.loads(storage)
	if not stam then return end

    GuiStartFrame(Gui2)
    -- GuiOptionsAdd(Gui2, 2) -- NonInteractive

    local amulet = GlobalsGetValue("NS_AMULET", "nil")
    local amuletgem = GlobalsGetValue("NS_AMULETGEM", "nil")

    local scale = GUI_SCALE / 2

    local ix, iy = GuiGetImageDimensions(Gui2, gfx.border_img, 1)
    local scale_x = (BX - Margin) / ix
    local scale_y = SCREEN_H / iy

    local leftborder_x = ((BX - scale_x) - (ix * scale_x) - (Margin / 2) - 0.5) - ix * BATTLETWEEN * 1.5
    local rightborder_x = ((BW + scale_x) - (ix * scale_x * -2) + 0.5 + (Margin * 1.5)) + ix * BATTLETWEEN * 1.5

    local w, h = GuiGetImageDimensions(Gui2, gfx.empty_img, scale)
    local sx = ((BX - scale_x) - (ix * scale_x) - (Margin / 2) - 0.5) + ix * scale_x - (22 * (BATTLETWEEN / 1)) - w
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

	local largest_y = -999
    x, y = sx, sy
    for i = 1, stam.max do
        GuiZSetForNextWidget(Gui2, z + 2)
        GuiImage(Gui2, id(), x, y, gfx.empty_img, 1, scale, scale)
        y = y + h
		largest_y = math.max(y, largest_y)
    end
    for i = 1, stam.temp do
        GuiZSetForNextWidget(Gui2, z + 1)
        GuiImage(Gui2, id(), x, y, flash and gfx.flash_img or gfx.temp_img, 1, scale, scale)
        y = y + h
		largest_y = math.max(y, largest_y)
    end
    x, y = sx, sy
    for i = 1, stam.normal do
        GuiZSetForNextWidget(Gui2, z)
        GuiImage(Gui2, id(), x, y, flash and gfx.flash_img or gfx.full_img, 1, scale, scale)
        y = y + h
		largest_y = math.max(y, largest_y)
    end

    GuiZSet(Gui2, z)
	local slotsw, slotsh = GuiGetImageDimensions(Gui2, gfx.item_slot, scale)

	local alpha = 1 - BATTLETWEEN
	local item_slots = 4

	y = largest_y + slotsh / 2
	GuiImage(Gui2, id(), x, y, gfx.item_top, alpha, scale, scale)
	y = y + 5
	x = x + (w - slotsw) / 2
	local padding = 2

	local base_y = y
	local inv = EntityGetWithName("inventory_quick2") or 0
	if inv == 0 then inv = EntityGetWithName("inventory_quick") end
	local items = EntityGetAllChildren(inv, "inventory_item") or {}
	for i = 1, math.max(item_slots, #items) do
		GuiZSet(Gui2, z)
		GuiImage(Gui2, id(), x, y, gfx.item_slot, alpha, scale, scale)
		GuiZSet(Gui2, z - 1)
		local item = (#items >= i) and EntityGetFirstComponentIncludingDisabled(items[i], "ItemComponent")
		if item then -- item exists
			local img = ComponentGetValue2(item, "ui_sprite")
			local lw, lh = GuiGetImageDimensions(Gui2, img, scale)
			local invx, _ = ComponentGetValue2(item, "inventory_slot")
			local y_offset = (slotsh + padding) * invx
			GuiImage(Gui2, id(), x + (slotsw - lw) / 2, base_y + y_offset + (slotsh - lh) / 2, img, alpha, scale, scale)

			GuiImage(Gui2, id(), x, base_y + y_offset, gfx.item_slot, 0, scale, scale) -- invisible box for tooltip
			GuiTooltip(Gui2, string.upper(GameTextGetTranslatedOrNot(ComponentGetValue2(item, "item_name"))), ComponentGetValue2(item, "ui_description"))
		end
		y = y + slotsh + padding
	end

    -- GuiText(Gui2, spacing, y, day .. ": " .. time, GUI_SCALE, DEFAULT_FONT)

    GuiZSet(Gui2, 99)
    GuiImage(Gui2, id(), leftborder_x, 0, gfx.border_img, 1, scale_x, scale_y)
    GuiImage(Gui2, id(), rightborder_x, 0, gfx.border_img, 1, -scale_x, scale_y)
end