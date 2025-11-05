Gui3 = Gui3 or GuiCreate()

local gfx = {
    frame = "mods/noiting_simulator/files/gui/gfx/frame.png",
    frameback = "mods/noiting_simulator/files/gui/gfx/frameback.png",
    edgeleft = "mods/noiting_simulator/files/gui/gfx/frameleft.png",
    edgeright = "mods/noiting_simulator/files/gui/gfx/frameright.png",
    edgemid = "mods/noiting_simulator/files/gui/gfx/framemid.png",
    divider = "mods/noiting_simulator/files/gui/gfx/framedivider.png",
    cute = "mods/noiting_simulator/files/gui/gfx/dmg_cute.png",
    charming = "mods/noiting_simulator/files/gui/gfx/dmg_charming.png",
    clever = "mods/noiting_simulator/files/gui/gfx/dmg_clever.png",
    comedic = "mods/noiting_simulator/files/gui/gfx/dmg_comedic.png",
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
local buffer = 2 -- seconds to finish dialogue after it's done printing

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local utf8 = dofile_once("mods/noiting_simulator/files/scripts/utf8.lua")

function AddDialogue(v, name)
    local dialogue = dofile_once("mods/noiting_simulator/files/battles/dialogue.lua")
    if dialogue[v.name] and dialogue[v.name][name] then
        if #v.text == 0 then v.textframe = GameGetFrameNum() end
        v.text[#v.text+1] = dialogue[v.name][name]
    end
end

return function()
    -- grab the values we need
    local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
    local v = string.len(storage) > 0 and smallfolk.loads(storage) or {
        guard = 0,
        guardmax = 0,
        tempolevel = 0,
        tempo = 0,
        tempomax = 0, -- when tempo reaches tempomax, tempo level goes up by 1
        tempodebt = 0, -- used for clever damage
        tempogain = 0,
        tempomaxboost = 1,
        tempo_dmg_mult = 1,
        fire_multiplier = 1,
        burn_multiplier = 1,
        cute = 1,
        charming = 1,
        clever = 1,
        comedic = 1,
        charming_boost = 1,
        guardflashframe = -1,
        tempoflashframe = -1,
        cuteflashframe = -1,
        charmingflashframe = -1,
        cleverflashframe = -1,
        comedicflashframe = -1,
        amulet = nil,
        amuletgem = nil,
        text = {},
        textframe = -999,
    }
    local guard = v.guardmax - math.max(0, math.min(v.guardmax, v.guard))

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

        local function color(r, g, b, type, frame)
            if GameGetFrameNum() > frame + 6 then
                local brightness = 0.75 + (type * 0.25)
                r = (r / 255) * brightness
                g = (g / 255) * brightness
                b = (b / 255) * brightness

                GuiColorSetForNextWidget(Gui3, math.min(r, 1), math.min(g, 1), math.min(b, 1), 1)
            end
        end

        local multx = BX - Margin + iconmargin + iconw / 2

        color(238, 165, 240, v.cute * v.charming_boost, v.cuteflashframe)
        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 0, gfx.cute, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l1 = GuiGetPreviousWidgetInfo(Gui3)

        color(225, 207, 122, v.charming, v.charmingflashframe)
        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 1, gfx.charming, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l2 = GuiGetPreviousWidgetInfo(Gui3)

        color(165, 190, 240, v.clever * v.charming_boost, v.cleverflashframe)
        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 2, gfx.clever, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l3 = GuiGetPreviousWidgetInfo(Gui3)

        color(120, 217, 145, v.comedic * v.charming_boost, v.comedicflashframe)
        GuiImage(Gui3, id(), BX - Margin + iconmargin, iconmargin + framey + (iconh * mult) * 3, gfx.comedic, 1, (GUI_SCALE * mult), (GUI_SCALE * mult))
        local _, _, _, _, l4 = GuiGetPreviousWidgetInfo(Gui3)

        color(238, 165, 240, v.cute * v.charming_boost, v.cuteflashframe)
        GuiText(Gui3, multx, l1 - GUI_SCALE, string.format("|%i%%", (v.cute * v.charming_boost) * 100), GUI_SCALE * mult, PIXEL_FONT)

        color(225, 207, 122, v.charming, v.charmingflashframe)
        GuiText(Gui3, multx, l2 - GUI_SCALE, string.format("|%i%%", v.charming * 100), GUI_SCALE * mult, PIXEL_FONT)

        color(165, 190, 240, v.clever * v.charming_boost, v.cleverflashframe)
        GuiText(Gui3, multx, l3 - GUI_SCALE, string.format("|%i%%", (v.clever * v.charming_boost) * 100), GUI_SCALE * mult, PIXEL_FONT)

        color(120, 217, 145, v.comedic * v.charming_boost, v.comedicflashframe)
        GuiText(Gui3, multx, l4 - GUI_SCALE, string.format("|%i%%", (v.comedic * v.charming_boost) * 100), GUI_SCALE * mult, PIXEL_FONT)

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
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.25, gfx.guardbar, 1, multiplier * (guard / v.guardmax), GUI_SCALE * mult)
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.75, gfx.tempobar, 1, multiplier * (v.tempo / v.tempomax), GUI_SCALE * mult)

        GuiZSet(Gui3, 16)
        if GameGetFrameNum() <= v.guardflashframe + 3 then
            GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.25, gfx.guardflash, 1, multiplier * (guard / v.guardmax), GUI_SCALE * mult)
        end
        if GameGetFrameNum() <= v.tempoflashframe + 3 then
            GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.75, gfx.tempoflash, 1, multiplier, GUI_SCALE * mult)
        end

        GuiZSet(Gui3, 15)
        -- texts
        local fontw, fonth = GuiGetImageDimensions(Gui3, gfx.guard, GUI_SCALE)
        local guardt = tostring(math.ceil(guard))
        local gtw, gth = GuiGetTextDimensions(Gui3, guardt, GUI_SCALE * mult, 2, gfx.guardfont, true)
        local tempot = "LV." .. v.tempolevel -- tostring(((v.tempo / v.tempomax) * 100)) .. "%"
        local ttw, tth = GuiGetTextDimensions(Gui3, tempot, GUI_SCALE * mult, 2, gfx.tempofont, true)
        GuiColorSetForNextWidget(Gui3, 1, 1, 1, 0.7)
        GuiText(Gui3, thisx + (gtw / -2) + (multiplier / 2), -0.05 + framey + (frameh - fonth * mult) * 0.25, guardt, GUI_SCALE * mult, gfx.guardfont, true)
        GuiColorSetForNextWidget(Gui3, 1, 1, 1, 0.7)
        GuiText(Gui3, thisx + (ttw / -2) + (multiplier / 2), -0.05 + framey + (frameh - fonth * mult) * 0.75, tempot, GUI_SCALE * mult, gfx.tempofont, true)

        -- charge
        if v.amulet then
            local scale = GUI_SCALE / 2
            local x, y = 178, 29.5
            local am = "mods/noiting_simulator/files/gui/gfx/amulets/a_" .. v.amulet .. ".png"
            local amw, amh = GuiGetImageDimensions(Gui3, am, scale)
            GuiImage(Gui3, id(), x, y - amh / 2, am, 1, scale, scale)
            if v.amuletgem then
                local gm = "mods/noiting_simulator/files/gui/gfx/amulets/g_" .. v.amuletgem .. ".png"
                GuiZSet(Gui3, 16)
                GuiImage(Gui3, id(), x, y - amh / 2, gm, 1, scale, scale)
            end
        end

        -- dialogue
        if v.text and v.text[1] then
            local len = utf8.len(v.text[1])
            local tick = GameGetFrameNum() - v.textframe
            GamePrint("TICK: " .. tostring(tick))
            if tick > len + buffer * 60 then
                table.remove(v.text, 1)
                v.textframe = GameGetFrameNum()
                GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
            end
            if v.text and v.text[1] then
                len = utf8.len(v.text[1])
                tick = GameGetFrameNum() - v.textframe
                GuiText(Gui3, 90, 90, utf8.sub(v.text[1], 1, tick), 1, DEFAULT_FONT, true)
            end
        end
    end
end