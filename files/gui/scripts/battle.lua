if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

local left = "mods/noiting_simulator/files/gui/gfx/bar_left.png"
local mid = "mods/noiting_simulator/files/gui/gfx/bar_middle.png"
local right = "mods/noiting_simulator/files/gui/gfx/bar_right.png"

return function()
    local max = tonumber(GlobalsGetValue("NS_BAR_MAX", "0"))
    local value = tonumber(GlobalsGetValue("NS_BAR_VALUE", "0"))
    local type = GlobalsGetValue("NS_BAR_TYPE", "CHARM")

    local left_w, left_h = GuiGetImageDimensions(Gui, left, GUI_SCALE)

    local text = ""
    local name = ""
    local fill_img, bg_img
    if type == "CHARM" then
        name = "Charm"
        text = tostring(value) .. "/" .. tostring(max)
        fill_img = "mods/noiting_simulator/files/gui/gfx/bar_charm.png"
        bg_img = "mods/noiting_simulator/files/gui/gfx/barbg_charm.png"
    end

    -- welcome to the toxic waste dump that is this code
    local x, y = (SCREEN_W * 0.5), BY - left_h - (Margin / 2)
    local _id = 40
    local function id()
        _id = _id + 1
        return _id
    end
    GuiStartFrame(Gui)
    local size_multiplier = 2 / GUI_SCALE
    local side_spacing = (GUI_SCALE / 4) * math.max(left_w * size_multiplier, size_multiplier * max)
    local mid_size = math.max(0, GUI_SCALE * (size_multiplier * max / 2) - left_w)

    -- BAR FRAME
    GuiZSet(Gui, 60)
    GuiImage(Gui, id(), (x + left_w / -2) - side_spacing, y, left, 1, GUI_SCALE, GUI_SCALE) -- left
    GuiImage(Gui, id(), x - mid_size / 2, y, mid, 1, mid_size, GUI_SCALE) -- middle
    GuiImage(Gui, id(), (x + left_w / -2) + side_spacing, y, right, 1, GUI_SCALE, GUI_SCALE) -- right

    -- TEXT
    GuiColorSetForNextWidget(Gui, 1, 1, 1, 0.8)
    local tw, th = GuiGetTextDimensions(Gui, text, GUI_SCALE, 0, DEFAULT_FONT)
    local shrinker = 1 / math.max(1, tw / (mid_size + left_w))
    tw, th = tw * shrinker, th * shrinker
    GuiText(Gui, x - (tw / 2) - (GUI_SCALE / -2 * shrinker), y - (th / 2) + (left_h / 2) - (GUI_SCALE / -2 * shrinker), text, GUI_SCALE * shrinker, DEFAULT_FONT)

    -- TOP TEXT
    local tw2, th2 = GuiGetTextDimensions(Gui, name, GUI_SCALE, 0, DEFAULT_FONT)
    GuiText(Gui, x - (tw2 / 2), y - th2 - ((Margin - 1) * -GUI_SCALE), name, GUI_SCALE, DEFAULT_FONT)

    -- BAR FILL
    GuiZSet(Gui, 65)
    local target = (mid_size + left_w)
    local fill = target * -(value / max)
    GuiImage(Gui, id(), x + ((fill / -2) * GUI_SCALE) - target / 2, y, fill_img, 1, fill, GUI_SCALE)

    -- BAR BG
    GuiZSet(Gui, 70)
    GuiImage(Gui, id(), x + ((target / -2) * GUI_SCALE) - -target / 2, y, bg_img, 1, target, GUI_SCALE)
end