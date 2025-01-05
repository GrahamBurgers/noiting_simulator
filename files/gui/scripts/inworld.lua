local DEFAULT_FONT = "data/fonts/font_pixel_noshadow.xml"

if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

local screen_x, screen_y = GuiGetScreenDimensions(Gui)

local empty = "mods/noiting_simulator/files/gui/gfx/empty.png"
local full = "mods/noiting_simulator/files/gui/gfx/full.png"

return function()
    -- stamina renderer
    local stamina = tonumber(GlobalsGetValue("NS_STAMINA_VALUE", "3"))
    local stam_max = (GlobalsGetValue("NS_STAMINA_MAX", "5"))

    local ax, ay = 0, screen_y / 12
    local spacing = screen_x / 50
    local x, y = ax, ay
    local _id = 40
    local function id()
        _id = _id + 1
        return _id
    end
    GuiStartFrame(Gui)
    local w, h = 0, 0
    for i = 1, stam_max do
        GuiZSet(Gui, 54)
        GuiImage(Gui, id(), x + spacing, y, empty, 1, GUI_SCALE, GUI_SCALE)
        w, h = GuiGetImageDimensions(Gui, empty, GUI_SCALE)
        x = x + w + GUI_SCALE
    end
    x, y = ax, ay
    for i = 1, stamina do
        GuiZSet(Gui, 53)
        GuiImage(Gui, id(), x + spacing, y, full, 1, GUI_SCALE, GUI_SCALE)
        w, h = GuiGetImageDimensions(Gui, full, GUI_SCALE)
        x = x + w + GUI_SCALE
    end
    x, y = ax, ay
    y = y + h + GUI_SCALE
    local time = GlobalsGetValue("NS_TIME", "???")
    local day = GlobalsGetValue("NS_DAY", "???")

    GuiText(Gui, spacing, y, day .. ": " .. time, GUI_SCALE, DEFAULT_FONT)
end