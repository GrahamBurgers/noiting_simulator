Gui3 = Gui3 or GuiCreate()

local gfx = {
    frame = "mods/noiting_simulator/files/gui/gfx/frame.png",
    frameback = "mods/noiting_simulator/files/gui/gfx/frameback.png",
    edgeleft = "mods/noiting_simulator/files/gui/gfx/frameleft.png",
    edgeright = "mods/noiting_simulator/files/gui/gfx/frameright.png",
    edgemid = "mods/noiting_simulator/files/gui/gfx/framemid.png",
    divider = "mods/noiting_simulator/files/gui/gfx/framedivider.png",
    cute = "data/ui_gfx/inventory/icon_damage_melee.png",
    charming = "data/ui_gfx/inventory/icon_damage_slice.png",
    clever = "data/ui_gfx/inventory/icon_damage_fire.png",
    comedic = "data/ui_gfx/inventory/icon_damage_ice.png",
    guard = "mods/noiting_simulator/files/gui/gfx/charm.png",
    tempo = "mods/noiting_simulator/files/gui/gfx/tempo.png",
    guardbar = "mods/noiting_simulator/files/gui/gfx/guardbar.png",
    tempobar = "mods/noiting_simulator/files/gui/gfx/tempobar.png",
    guardback = "mods/noiting_simulator/files/gui/gfx/guardback.png",
    tempoback = "mods/noiting_simulator/files/gui/gfx/tempoback.png",
    guardfont = "mods/noiting_simulator/files/fonts/guardbar.xml",
    tempofont = "mods/noiting_simulator/files/fonts/tempobar.xml",
    guardflash = "mods/noiting_simulator/files/gui/gfx/guardflash.png",
    tempoflash = "mods/noiting_simulator/files/gui/gfx/tempoflash.png",
}
Portrait = GlobalsGetValue("NS_PORTRAIT", "hamis_idle")
PFrame = 1

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

return function()
    -- grab the values we need
    local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
    local v = string.len(storage) > 0 and smallfolk.loads(storage) or {
        guard = 0,
        guardmax = 0,
        tempolevel = 0,
        tempo = 0,
        tempomax = 0, -- when tempo reaches tempomax, tempo level goes up by 1
        cute = 1,
        charming = 1,
        clever = 1,
        comedic = 1,
        charming_boost = 1,
        guardflashframe = -1,
        tempoflashframe = -1,
    }
    v.guard = v.guardmax - math.max(0, math.min(v.guardmax, v.guard))
    v.tempo = math.max(0, math.min(v.tempomax, v.tempo))

    if InputIsKeyJustDown(27) then
        dofile_once("mods/noiting_simulator/files/battles/battles.lua")
        StartBattle("Dummy")
    end
    if InputIsKeyJustDown(15) then
        GlobalsSetValue("NS_PORTRAIT_SET", "hamis_happy")
    end
    if InputIsKeyJustDown(6) then
        dofile_once("mods/noiting_simulator/files/battles/battles.lua")
        StartBattle("Parantajahiisi")
    end
    if InputIsKeyDown(11) then
        GUI_SCALE = GUI_SCALE - 0.01
        GamePrint("Gui scale: " .. tostring(GUI_SCALE))
    end
    if InputIsKeyJustDown(13) then
        GUI_SCALE = tonumber(ModSettingGetNextValue("noiting_simulator.ui_scale")) or 2
        GamePrint("Gui scale: " .. tostring(GUI_SCALE))
    end
    if InputIsKeyDown(14) then
        GUI_SCALE = GUI_SCALE + 0.01
        GamePrint("Gui scale: " .. tostring(GUI_SCALE))
    end
    dofile_once("mods/noiting_simulator/files/gui/gfx/portraits/_portraits.lua")
    local _id = 1
    local function id()
        _id = _id + 1
        return _id
    end
    if Portrait and PORTRAITS[Portrait] then
        local this = PORTRAITS[Portrait]
        local image = ""
        local toset = GlobalsGetValue("NS_PORTRAIT_SET", "")
        if toset and toset ~= "" and (PORTRAITS[Portrait].priority <= PORTRAITS[toset].priority) and (toset ~= Portrait or Portrait.override_self == true) then
            GlobalsSetValue("NS_PORTRAIT_SET", "")
            GlobalsSetValue("NS_PORTRAIT", toset)
            Portrait = toset
            PFrame = 1
        end
        local j = PFrame
        PFrame = PFrame + 1
        for i = 1, #this.frames do
            j = j - this.frames[i].duration
            if j <= 0 then
                image = this.frames[i].file
                break
            end
            if i == #this.frames then
                if this.next_animation then
                    Portrait = this.next_animation
                end
                image = PORTRAITS[Portrait].frames[1].file
                PFrame = 1
            end
        end
        image = "mods/noiting_simulator/files/gui/gfx/portraits/" .. image
        GuiStartFrame(Gui3)
        GuiOptionsAdd(Gui3, 2) -- NonInteractive
        local framew, frameh = GuiGetImageDimensions(Gui3, gfx.frame, GUI_SCALE)
        local framex, framey = (SCREEN_W / 2) - (framew / 2), BY - frameh - Margin
        local portraitw, portraith = GuiGetImageDimensions(Gui3, image, GUI_SCALE)
        local portraitx, portraity = (SCREEN_W / 2) - (portraitw / 2) + 0.1, (BY - portraith - Margin) - (frameh - portraith) / 2 + 0.1
        local edgew, edgeh = GuiGetImageDimensions(Gui3, gfx.edgeright, GUI_SCALE)
        -- frame background
        GuiZSet(Gui3, 45)
        GuiImage(Gui3, id(), framex, framey, gfx.frameback, 1, GUI_SCALE, GUI_SCALE)
        -- animated portrait
        GuiZSet(Gui3, 35)
        GuiImage(Gui3, id(), portraitx, portraity, image, 1, GUI_SCALE, GUI_SCALE)
        -- frame
        GuiZSet(Gui3, 30)
        GuiImage(Gui3, id(), framex, framey, gfx.frame, 1, GUI_SCALE, GUI_SCALE)
        -- edges
        GuiImage(Gui3, id(), framex + framew, framey, gfx.edgeleft, 1, GUI_SCALE, GUI_SCALE)
        local _, _, _, x1 = GuiGetPreviousWidgetInfo(Gui3)
        GuiImage(Gui3, id(), framex - edgew, framey, gfx.edgeright, 1, GUI_SCALE, GUI_SCALE)

        GuiImage(Gui3, id(), BX - Margin, framey, gfx.edgeleft, 1, GUI_SCALE, GUI_SCALE)
        local _, _, _, x2 = GuiGetPreviousWidgetInfo(Gui3)
        GuiImage(Gui3, id(), BX + BW - edgew + Margin, framey, gfx.edgeright, 1, GUI_SCALE, GUI_SCALE)

        -- inner
        GuiZSet(Gui3, 31)
        GuiImage(Gui3, id(), framex - edgew, framey, gfx.edgemid, 1, -(x1 - x2) + portraitw + edgew + edgew + GUI_SCALE, GUI_SCALE)
        GuiImage(Gui3, id(), BX + BW - edgew + Margin, framey, gfx.edgemid, 1, -(x1 - x2) + portraitw + edgew + edgew + GUI_SCALE, GUI_SCALE)

        -- damage types
        GuiZSet(Gui3, 25)
        local iconw, iconh = GuiGetImageDimensions(Gui3, gfx.cute, GUI_SCALE)
        local iconmargin = iconh / 4
        local mult = 1 / ((iconh * 4) / (framew - iconmargin * 2))
        local tw, th = GuiGetTextDimensions(Gui3, "100%", (GUI_SCALE * mult), 0, PIXEL_FONT)
        th = th - 2 -- dead space in font

        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 0, gfx.cute, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l1 = GuiGetPreviousWidgetInfo(Gui3)
        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 1, gfx.charming, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l2 = GuiGetPreviousWidgetInfo(Gui3)
        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 2, gfx.clever, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l3 = GuiGetPreviousWidgetInfo(Gui3)
        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 3, gfx.comedic, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l4 = GuiGetPreviousWidgetInfo(Gui3)

        local function color(r, g, b, type)
            local brightness = 0.5 + (type * 0.5)
            r = (r / 255) * brightness
            g = (g / 255) * brightness
            b = (b / 255) * brightness

            GuiColorSetForNextWidget(Gui3, math.min(r, 1), math.min(g, 1), math.min(b, 1), 1)
        end
        local multx = BX - Margin + iconmargin + iconw / 2

        color(238, 165, 240, v.cute * v.charming_boost)
        GuiText(Gui3, multx, l1 - GUI_SCALE, string.format("|%i%%", (v.cute * v.charming_boost) * 100), GUI_SCALE * mult, PIXEL_FONT)
        GuiTooltip(Gui3, "$ns_desc_cute", "")

        color(225, 207, 122, v.charming)
        GuiText(Gui3, multx, l2 - GUI_SCALE, string.format("|%i%%", v.charming * 100), GUI_SCALE * mult, PIXEL_FONT)
        GuiTooltip(Gui3, "$ns_desc_charming", "")

        color(165, 190, 240, v.clever * v.charming_boost)
        GuiText(Gui3, multx, l3 - GUI_SCALE, string.format("|%i%%", (v.clever * v.charming_boost) * 100), GUI_SCALE * mult, PIXEL_FONT)
        GuiTooltip(Gui3, "$ns_desc_clever", "")

        color(120, 217, 145, v.comedic * v.charming_boost)
        GuiText(Gui3, multx, l4 - GUI_SCALE, string.format("|%i%%", (v.comedic * v.charming_boost) * 100), GUI_SCALE * mult, PIXEL_FONT)
        GuiTooltip(Gui3, "$ns_desc_comedic", "")

        local multw = GuiGetTextDimensions(Gui3, "|200%", GUI_SCALE * mult, 2, PIXEL_FONT, true)

        -- divider
        local divw, divh = GuiGetImageDimensions(Gui3, gfx.divider, GUI_SCALE)
        GuiImage(Gui3, id(), multx + multw, framey, gfx.divider, 1, GUI_SCALE, GUI_SCALE)

        -- "GUARD" and "TEMPO"
        local textw, texth = GuiGetImageDimensions(Gui3, gfx.guard, GUI_SCALE)
        mult = texth / ((frameh / 2) + iconmargin * 4)
        GuiImage(Gui3, id(), multx + multw + divw, framey + (frameh - texth * mult) * 0.25, gfx.guard, 1, GUI_SCALE * mult, GUI_SCALE * mult)
        GuiImage(Gui3, id(), multx + multw + divw, framey + (frameh - texth * mult) * 0.75, gfx.tempo, 1, GUI_SCALE * mult, GUI_SCALE * mult)

        -- Guard and tempo bars
        local thisx = multx + multw + divw + iconmargin + textw * mult
        local max_x = (SCREEN_W / 2) - (portraitw / 2) - edgew
        local multiplier = (max_x - thisx)
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.25, gfx.guardback, 1, multiplier, GUI_SCALE * mult)
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.75, gfx.tempoback, 1, multiplier, GUI_SCALE * mult)

        GuiZSet(Gui3, 20)
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.25, gfx.guardbar, 1, multiplier * (v.guard / v.guardmax), GUI_SCALE * mult)
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.75, gfx.tempobar, 1, multiplier * (v.tempo / v.tempomax), GUI_SCALE * mult)

        GuiZSet(Gui3, 16)
        if GameGetFrameNum() <= v.guardflashframe + 3 then
            GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.25, gfx.guardflash, 1, multiplier * (v.guard / v.guardmax), GUI_SCALE * mult)
        end
        if GameGetFrameNum() <= v.tempoflashframe + 3 then
            GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.75, gfx.tempoflash, 1, multiplier, GUI_SCALE * mult)
        end

        GuiZSet(Gui3, 15)
        -- texts
        local fontx = multx + multw + divw + iconmargin
        local fontw, fonth = GuiGetImageDimensions(Gui3, gfx.guard, GUI_SCALE)
        local guardt = tostring(math.ceil(v.guard))
        local gtw, gth = GuiGetTextDimensions(Gui3, guardt, GUI_SCALE * mult, 2, gfx.guardfont, true)
        local tempot = "LV." .. v.tempolevel -- tostring(((v.tempo / v.tempomax) * 100)) .. "%"
        local ttw, tth = GuiGetTextDimensions(Gui3, tempot, GUI_SCALE * mult, 2, gfx.tempofont, true)
        GuiColorSetForNextWidget(Gui3, 1, 1, 1, 0.8)
        GuiText(Gui3, thisx + (gtw / -2) + (multiplier / 2), -0.05 + framey + (frameh - fonth * mult) * 0.25, guardt, GUI_SCALE * mult, gfx.guardfont, true)
        GuiColorSetForNextWidget(Gui3, 1, 1, 1, 0.8)
        GuiText(Gui3, thisx + (ttw / -2) + (multiplier / 2), -0.05 + framey + (frameh - fonth * mult) * 0.75, tempot, GUI_SCALE * mult, gfx.tempofont, true)
    end
end