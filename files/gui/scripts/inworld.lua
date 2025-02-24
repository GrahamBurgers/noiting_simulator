Gui2 = Gui2 or GuiCreate()

local screen_x, screen_y = GuiGetScreenDimensions(Gui2)

return function()
    -- stamina renderer
    local empty_img = "mods/noiting_simulator/files/gui/gfx/empty.png"
    local full_img = "mods/noiting_simulator/files/gui/gfx/full.png"
    local temp_img = "mods/noiting_simulator/files/gui/gfx/blue.png"
    local flash_img = "mods/noiting_simulator/files/gui/gfx/flash.png"

    local empty = tonumber(GlobalsGetValue("NS_STAMINA_MAX", "5"))
    local full = tonumber(GlobalsGetValue("NS_STAMINA_VALUE", "3"))
    local temp = tonumber(GlobalsGetValue("NS_STAMINA_TEMP", "2"))
    local flash = tonumber(GlobalsGetValue("NS_STAMINA_FLASH", "0"))
    if flash > 0 then
        flash = flash - 1
        GlobalsSetValue("NS_STAMINA_FLASH", tostring(flash))
        full_img = flash_img
        temp_img = flash_img
    end

    local ax, ay = screen_x / 68, screen_y / 17
    local x, y = ax, ay
    local _id = 40
    local function id()
        _id = _id + 1
        return _id
    end
    GuiStartFrame(Gui2)
    GuiOptionsAdd(Gui2, 2) -- NonInteractive
    local w, h = GuiGetImageDimensions(Gui2, empty_img, GUI_SCALE)
    for i = 1, empty do
        GuiZSetForNextWidget(Gui2, 54)
        GuiImage(Gui2, id(), x, y, empty_img, 1, GUI_SCALE, GUI_SCALE)
        x = x + w + GUI_SCALE
    end
    for i = 1, temp do
        GuiZSetForNextWidget(Gui2, 54)
        GuiImage(Gui2, id(), x, y, temp_img, 1, GUI_SCALE, GUI_SCALE)
        x = x + w + GUI_SCALE
    end
    x, y = ax, ay
    for i = 1, full do
        GuiZSetForNextWidget(Gui2, 53)
        GuiImage(Gui2, id(), x, y, full_img, 1, GUI_SCALE, GUI_SCALE)
        x = x + w + GUI_SCALE
    end

    -- GuiText(Gui2, spacing, y, day .. ": " .. time, GUI_SCALE, DEFAULT_FONT)
end