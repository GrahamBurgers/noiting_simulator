Gui2 = Gui2 or GuiCreate()

local gfx = {
    empty_img = "mods/noiting_simulator/files/gui/s_empty.png",
    full_img = "mods/noiting_simulator/files/gui/s_full.png",
    temp_img = "mods/noiting_simulator/files/gui/s_temp.png",
    flash_img = "mods/noiting_simulator/files/gui/s_flash.png",
    border_img = "mods/noiting_simulator/files/gui/borders/border_test.png",
    bg_img = "mods/noiting_simulator/files/gui/amulets/bg.png",
    bar_img = "mods/noiting_simulator/files/gui/amulets/bar.png",
}
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
    GuiOptionsAdd(Gui2, 2) -- NonInteractive

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

	local flash = stam.flash >= GameGetFrameNum()

    x, y = sx, sy
    for i = 1, stam.max do
        GuiZSetForNextWidget(Gui2, 7)
        GuiImage(Gui2, id(), x, y, gfx.empty_img, 1, scale, scale)
        y = y + h
    end
    for i = 1, stam.temp do
        GuiZSetForNextWidget(Gui2, 6)
        GuiImage(Gui2, id(), x, y, flash and gfx.flash_img or gfx.temp_img, 1, scale, scale)
        y = y + h
    end
    x, y = sx, sy
    for i = 1, stam.normal do
        GuiZSetForNextWidget(Gui2, 5)
        GuiImage(Gui2, id(), x, y, flash and gfx.flash_img or gfx.full_img, 1, scale, scale)
        y = y + h
    end

    -- GuiText(Gui2, spacing, y, day .. ": " .. time, GUI_SCALE, DEFAULT_FONT)

    GuiZSet(Gui2, 99)
    GuiImage(Gui2, id(), leftborder_x, 0, gfx.border_img, 1, scale_x, scale_y)
    GuiImage(Gui2, id(), rightborder_x, 0, gfx.border_img, 1, -scale_x, scale_y)
end