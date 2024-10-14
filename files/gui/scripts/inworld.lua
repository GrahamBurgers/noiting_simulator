-- stamina renderer
local stamina = tonumber(GlobalsGetValue("NS_STAMINA_VALUE", "3"))
local stam_max = (GlobalsGetValue("NS_STAMINA_MAX", "5"))
local anims = GlobalsGetValue("NS_STAMINA_ANIMS")

if Gui2 then GuiDestroy(Gui2) end
Gui2 = GuiCreate()

local GUI_SCALE = 3
local screen_x, screen_y = GuiGetScreenDimensions(Gui)

local empty_filepath = "mods/noiting_simulator/files/gui/gfx/b_e.png"

function Frame2()
    local x, y = screen_x / 4, screen_y / 5
    local _id = 40
    local function id()
        _id = _id + 1
        return _id
    end
    for i = 1, stam_max do
        GuiImage(Gui2, id(), x, y, empty_filepath, 1, GUI_SCALE, GUI_SCALE)
        local w, h = GuiGetImageDimensions(Gui2, empty_filepath, GUI_SCALE)
        x = x + w + GUI_SCALE
    end
end