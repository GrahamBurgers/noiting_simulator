local DEFAULT_FONT = "mods/noiting_simulator/files/gfx/fonts/default.xml"

if Gui2 then GuiDestroy(Gui2) end
Gui2 = GuiCreate()

local GUI_SCALE = 3
local screen_x, screen_y = GuiGetScreenDimensions(Gui2)

local empty = "mods/noiting_simulator/files/gui/gfx/empty.png"
local full = "mods/noiting_simulator/files/gui/gfx/full.png"

function Frame2()
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
    GuiStartFrame(Gui2)
    local w, h = 0, 0
    for i = 1, stam_max do
        GuiZSet(Gui2, 54)
        GuiImage(Gui2, id(), x + spacing, y, empty, 1, GUI_SCALE, GUI_SCALE)
        w, h = GuiGetImageDimensions(Gui2, empty, GUI_SCALE)
        x = x + w + GUI_SCALE
    end
    x, y = ax, ay
    for i = 1, stamina do
        GuiZSet(Gui2, 53)
        GuiImage(Gui2, id(), x + spacing, y, full, 1, GUI_SCALE, GUI_SCALE)
        w, h = GuiGetImageDimensions(Gui2, full, GUI_SCALE)
        x = x + w + GUI_SCALE
    end
    x, y = ax, ay
    y = y + h + GUI_SCALE
    local time = GlobalsGetValue("NS_TIME", "???")
    local day = GlobalsGetValue("NS_DAY", "???")
    GuiText(Gui2, spacing, y, day .. ": " .. time, GUI_SCALE, DEFAULT_FONT)
end