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
    gradienttop = "mods/noiting_simulator/files/gui/gfx/grad_top.png",
    gradientbottom = "mods/noiting_simulator/files/gui/gfx/grad_bottom.png",
    buttonrevive = "mods/noiting_simulator/files/gui/gfx/button_revive.png",
    buttonforfeit = "mods/noiting_simulator/files/gui/gfx/button_forfeit.png",
    buttonrevive2 = "mods/noiting_simulator/files/gui/gfx/button_revive2.png",
    buttonforfeit2 = "mods/noiting_simulator/files/gui/gfx/button_forfeit2.png",
    buttonrevivenecro = "mods/noiting_simulator/files/gui/gfx/button_revivenecro.png",
    buttonback = "mods/noiting_simulator/files/gui/gfx/button_back.png",
    buttonfill = "mods/noiting_simulator/files/gui/gfx/button_fill.png",
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
        damagemax = 0,
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
        text = {},
        textframe = -999,
        persistent = {},
    }
    local guardmax = v.guardmax - v.damagemax
    local guard = guardmax - math.max(0, math.min(guardmax, v.guard - v.damagemax))

    if InputIsKeyJustDown(27) then
        dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
        StartBattle("dummy")
    end
    if InputIsKeyJustDown(15) then
        GlobalsSetValue("NS_PORTRAIT_SET", "hamis_happy")
    end
    if InputIsKeyJustDown(6) then
        dofile_once("mods/noiting_simulator/files/battles/start_battle.lua")
        StartBattle("healer")
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

        GuiZSet(Gui3, 26)

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
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.25, gfx.guardbar, 1, multiplier * (guard / guardmax), GUI_SCALE * mult)
        GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.75, gfx.tempobar, 1, multiplier * (v.tempo / v.tempomax), GUI_SCALE * mult)

        GuiZSet(Gui3, 16)
        if GameGetFrameNum() <= v.guardflashframe + 3 then
            GuiImage(Gui3, id(), thisx, framey + (frameh - texth * mult) * 0.25, gfx.guardflash, 1, multiplier * (guard / guardmax), GUI_SCALE * mult)
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

        -- dialogue
        if v.text and v.text[1] then
            local len = utf8.len(v.text[1])
            local tick = GameGetFrameNum() - v.textframe
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

        -- death
        GuiZSet(Gui3, -995)
        local deathtick = tonumber(GlobalsGetValue("NS_BATTLE_DEATHFRAME", "0"))
        if deathtick > 0 then
            local ck, rk = false, false
            local frames = GameGetFrameNum() - deathtick
            local players = EntityGetWithTag("player_unit") or {}
            for i = 1, #players do
                local controls = EntityGetFirstComponentIncludingDisabled(players[i], "ControlsComponent")
                local anim = EntityGetFirstComponentIncludingDisabled(players[i], "SpriteAnimatorComponent")
                local inv = EntityGetFirstComponentIncludingDisabled(players[i], "InventoryGuiComponent")
                if controls then
                    ComponentSetValue2(controls, "input_latency_frames", 2)
                    ck = ComponentGetValue2(controls, "mButtonDownDelayLineFire") == 1
                    rk = ComponentGetValue2(controls, "mButtonDownDelayLineThrow") == 1
                    ComponentSetValue2(controls, "mButtonDownDelayLineLeft", 0)
                    ComponentSetValue2(controls, "mButtonDownDelayLineRight", 0)
                    ComponentSetValue2(controls, "mButtonDownDelayLineUp", 0)
                    ComponentSetValue2(controls, "mButtonDownDelayLineDown", 0)
                    ComponentSetValue2(controls, "mButtonDownDelayLineFire", 0)
                    ComponentSetValue2(controls, "mButtonDownDelayLineFly", 0)
                    ComponentSetValue2(controls, "mButtonDownDelayLineThrow", 0)
                    ComponentSetValue2(controls, "mAimingVector", 0, 0)
                end
                local sprite = EntityGetFirstComponentIncludingDisabled(players[i], "SpriteComponent")
                if sprite and anim and inv then
                    ComponentSetValue2(sprite, "rect_animation", (frames == 1 and "knockout") or "")
                    ComponentSetValue2(inv, "mActive", false)
                    EntitySetComponentIsEnabled(players[i], anim, false)
                end
            end
            local gradient_scale = 2
            local res_x = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")) or 0
            local res_y = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")) or 0
            local px, py = EntityGetTransform(EntityGetWithTag("player_unit")[1])
            local cam_x, cam_y = GameGetCameraPos()
            local s_w, s_h = GuiGetScreenDimensions(Gui3)
            local vx = px - cam_x + res_x / 2
            local vy = py - cam_y + res_y / 2
            local gui_x = vx * s_w / res_x
            local gui_y = vy * s_h / res_y
            gui_y = gui_y - 4 -- player size

            local xr, yr = 0, 0
            local hold_frames = 120
            local necro = false
            if frames < 60 or (ck and rk) then
                ck = false rk = false
            end
            if v.name == "necrobot" and (v.hasrevived ~= true) and frames > 30 + hold_frames then
                ck = false rk = false
                necro = true
                Revframes = Revframes + 2.5
                SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
                xr, yr = Random(-1, 1) / 3, Random(-1, 1) / 3
            end
            Revframes = math.min(hold_frames, math.max(0.000001, Revframes and (Revframes + (ck and 1 or -2)) or 0))
            Forframes = math.min(hold_frames, math.max(0.000001, Forframes and (Forframes + (rk and 1 or -2)) or 0))

            local function reenable(player)
                local dmg = EntityGetFirstComponent(player, "DamageModelComponent")
                if dmg then ComponentSetValue2(dmg, "hp", ComponentGetValue2(dmg, "max_hp")) end
                local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
                if controls then ComponentSetValue2(controls, "enabled", true) end
                local anim = EntityGetFirstComponentIncludingDisabled(player, "SpriteAnimatorComponent")
                if anim then EntitySetComponentIsEnabled(player, anim, true) end
            end
            if Revframes >= 120 then
                -- REVIVE
                Revframes = 0
                EntityLoad("data/entities/particles/image_emitters/heart_effect.xml", px, py)
                GlobalsSetValue("NS_BATTLE_DEATHFRAME", "0")
                GameScreenshake(20)
                for i = 1, #players do
                    reenable(players[i])
                    LoadGameEffectEntityTo(players[i], "data/entities/misc/effect_protection_all_short.xml")
                end
                local wands = EntityGetWithTag("wand")
                for i = 1, #wands do
                    local ability = EntityGetFirstComponentIncludingDisabled(wands[i], "AbilityComponent")
                    if ability then
                        ComponentSetValue2(ability, "mReloadFramesLeft", GameGetFrameNum() + 60)
                        ComponentSetValue2(ability, "mReloadNextFrameUsable", GameGetFrameNum() + 60)
                    end
                end
                v.hasrevived = true
                GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
            elseif Forframes >= 120 then
                -- FORFEIT
                Forframes = 0
                v.persistent = v.persistent or {}
                v.persistent[v.name] = {damage = (v.guardmax - v.guard), damagemax = v.damagemax}
                GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
                GlobalsSetValue("NS_BATTLE_STATE", "FAIL")
                GlobalsSetValue("NS_IN_BATTLE", "0")
                GlobalsSetValue("NS_BATTLE_DEATHFRAME", "0")
                for i = 1, #players do
                    reenable(players[i])
                end
                local hearts = EntityGetWithTag("heart")
                for i = 1, #hearts do
                    EntityKill(hearts[i])
                end
            else
                local spacing = (800 / frames) + 14
                local buttonspacing = (800 / math.max(0, (frames * 0.5 - 30))) + 14
                local grw, grh = GuiGetImageDimensions(Gui3, gfx.gradienttop, gradient_scale)
                local xadd = ((frames * 0.5) % (gradient_scale * 8))
                GuiImage(Gui3, id(), gui_x + grw / -2 + xadd, gui_y - (grh + spacing), gfx.gradienttop, 1, gradient_scale, gradient_scale)
                GuiImage(Gui3, id(), gui_x + grw / -2 - xadd, gui_y + spacing, gfx.gradientbottom, 1, gradient_scale, gradient_scale)

                local butw, buth = GuiGetImageDimensions(Gui3, gfx.buttonback, gradient_scale)
                GuiZSet(Gui3, -996)
                GuiImage(Gui3, id(), gui_x + butw / -2, gui_y - (buth + buttonspacing), gfx.buttonback, 1, gradient_scale, gradient_scale)
                GuiImage(Gui3, id(), gui_x + butw / -2, gui_y + buttonspacing, gfx.buttonback, 1, gradient_scale, gradient_scale)

                GuiZSet(Gui3, -997)
                local rheight = gradient_scale * (Revframes / hold_frames) * (buth - 4) * 0.5
                GuiImage(Gui3, id(), (gui_x + butw / -2) + xr, (-gradient_scale + -rheight + gui_y - buttonspacing) + yr, gfx.buttonfill, 1, gradient_scale, rheight)
                local fheight = gradient_scale * (Forframes / hold_frames) * (buth - 4) * 0.5
                GuiImage(Gui3, id(), gui_x + butw / -2, -gradient_scale + -fheight + gui_y + buttonspacing + buth, gfx.buttonfill, 1, gradient_scale, fheight)

                GuiZSet(Gui3, -998)
                GuiImage(Gui3, id(), gui_x + butw / -2 + xr, gui_y - (buth + buttonspacing) + yr, (necro and gfx.buttonrevivenecro) or (ck and gfx.buttonrevive2) or gfx.buttonrevive, 1, gradient_scale, gradient_scale)
                GuiImage(Gui3, id(), gui_x + butw / -2, gui_y + buttonspacing, (rk and gfx.buttonforfeit2) or gfx.buttonforfeit, 1, gradient_scale, gradient_scale)
            end
        end
    end
end