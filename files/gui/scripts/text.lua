local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local utf8 = dofile_once("mods/noiting_simulator/files/scripts/utf8.lua")
local child = EntityGetWithName("ns_text_handler")
local this = EntityGetFirstComponentIncludingDisabled(child, "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()
local player, px, py, cc, invgui, chdata = 0, 0, 0, 0, 0, 0

Gui1 = Gui1 or GuiCreate()

function RecalcPlayer()
    local players = EntityGetWithTag("player_unit") or {}
    if #players > 0 then
        player = players[1]
        px, py = EntityGetTransform(player)
        cc = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent") or 0
        invgui = EntityGetFirstComponentIncludingDisabled(player, "InventoryGuiComponent") or 0
        chdata = EntityGetFirstComponentIncludingDisabled(player, "CharacterDataComponent") or 0
    end
    print("RECALC PLAYER")
end
RecalcPlayer()

function RecalcSettings()
    MAX_LINES = 99 -- ModSettingGet("noiting_simulator.max_lines")
    SHADOW_OFFSET = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_offset"))
    DEFAULT_FONT = tostring(ModSettingGetNextValue("noiting_simulator.font"))
    DEFAULT_SIZE = tonumber(ModSettingGetNextValue("noiting_simulator.text_size"))
    DEFAULT_TICKRATE = math.floor(tonumber(ModSettingGetNextValue("noiting_simulator.speed")) or 2)
    LINE_SPACING = DEFAULT_SIZE * ModSettingGetNextValue("noiting_simulator.line_spacing")
    SHADOWDARK = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_darkness"))
    FONT = DEFAULT_FONT
    TEXT_SIZE = DEFAULT_SIZE
    TICKRATE = DEFAULT_TICKRATE
    GUI_SCALE = tonumber(ModSettingGetNextValue("noiting_simulator.ui_scale")) or 2
    print("RECALC SETTINGS")
end
RecalcSettings()

Margin = 4

function RecalcScreen()
    SCREEN_W, SCREEN_H = GuiGetScreenDimensions(Gui1)
    LONGEST_WIDTH = (SCREEN_W * 0.8)
    LONGEST_HEIGHT = (SCREEN_H * 0.4)
    BW, BH = LONGEST_WIDTH, LONGEST_HEIGHT
    BX, BY = (SCREEN_W * 0.5) - (BW * 0.5), (SCREEN_H * 1) - BH - Margin
    BX_DEFAULT, BY_DEFAULT = BX, BY
    print("RECALC SCREEN")
end
RecalcScreen()

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui1, text:gsub("\n", ""):gsub("!S!", " "), TEXT_SIZE, LINE_SPACING, FONT)
    return w
end

---@param text string
---@return number
local function heightof(text)
    local w, h = GuiGetTextDimensions(Gui1, text:gsub("\n", ""):gsub("!S!", " "), TEXT_SIZE, LINE_SPACING, FONT)
    return h
end

---@param input table
---@param add any
-- Adds a thing to a table unless it already exists, also turns nil into {}
local function addToTable(input, add)
    input = input or {}
    local go = true
    for i = 1, #input do
        if input[i] == add then
            go = false
        end
    end
    if go then
        input[#input+1] = add
    end
    return input
end

local function meetCharacter(id)
    dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
    if ModSettingGet("noiting_simulator.met_" .. id) ~= true then
        ModSettingSet("noiting_simulator.met_" .. id, true)
        for i = 1, #CHARACTERS do
            if CHARACTERS[i].id == id then
                AddLines({texts = {{text = [[You've met ]] .. (CHARACTERS[i].name or id) .. "! "
                .. Pronouns[id]["They've"] .. [[ been added to your mod settings menu.]], style = {"info"}}}})
                break
            end
        end
    end
end

--[[ scrapped overworld
local player2 = EntityGetWithName("ns_player_overworld")
local vs = EntityGetFirstComponent(player2, "VariableStorageComponent")
function LockPlayer(bool)
    if vs then ComponentSetValue2(vs, "value_bool", bool) end
end
]]--

function NewLine(serialized)
    -- remove lines that are too old
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local age = ComponentGetValue2(comps[i], "value_float")
        ComponentSetValue2(comps[i], "value_float", age + 1)
        if age > MAX_LINES then
            EntityRemoveComponent(child, comps[1])
        elseif age == MAX_LINES then
            local current = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
            current["full"] = "[...]"
            current["texts"] = {{text = "[...]", style = {"white", "grey"}}}
            ComponentSetValue2(comps[i], "value_string", smallfolk.dumps(current))
        end
    end
    EntityAddComponent2(child, "VariableStorageComponent", {
        _tags="noiting_sim_line",
        value_string=serialized,
        name="",
        value_float=1,
    })
end

---@return string file
---@return number line
---@return number charnum
---@return string track
function GetScene()
    local file = ComponentGetValue2(this, "script_inhaled_material")
    local line = tonumber(ComponentGetValue2(this, "script_throw_item")) or 1
    local charnum = tonumber(ComponentGetValue2(this, "script_material_area_checker_failed")) or 1
    local track = ComponentGetValue2(this, "script_material_area_checker_success") or "main"
    return file, line, charnum, track
end

local function greyLines()
    -- turn previous lines grey when new lines are added
    -- also auto because it should be skipped anyway
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local current = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
        -- current["behavior"] = "auto"
        for j = 1, #current["f"] do
            current["f"][j]["style"] = addToTable(current["f"][j]["style"], "grey")
            current["f"][j]["done"] = (current["f"][j]["done"] or 0) + 1
        end
        ComponentSetValue2(comps[i], "value_string", smallfolk.dumps(current))
    end
end

---@param scene string? Source file for dialogue
---@param track string? Track to look for
---@param start number? Line to start looking from
local function nextLine(scene, track, start)
    -- default function for most lines
    scene = scene or ComponentGetValue2(this, "script_inhaled_material")
    start = (start or tonumber(ComponentGetValue2(this, "script_throw_item")) or 1) + 1
    dofile(scene)
    track = track or "main"
    while start <= #SCENE do
        if (SCENE[start]["track"] == track or SCENE[start]["track"] == "any" or SCENE[start]["track"] == nil) and (SCENE[start]["onlyif"] ~= false) then
            SetScene(nil, start, nil, track)
            break
        end
        start = start + 1
    end
end

---@param input table Should have a texts field
function AddLines(input)
    dofile_once("mods/noiting_simulator/files/scripts/characters.lua")
    local src = ""
    local f = {}
    local x, y, line_len = 0, 0, 0

    if input["func"] then
        input["func"]()
        input["func"] = nil
    end
    if input["meet"] then
        meetCharacter(input["meet"])
    end
    input["track"] = input["track"] or "main"

    local i = 1
    local texts = ""
    if input["texts"] then
        greyLines()
        GlobalsSetValue("NS_SCROLL", "0")
        while i <= #input["texts"] do
            local text = (input["textfunc"] and input["textfunc"]()) or input["texts"]
            if text and text[i]["text"] then
                text[i]["text"] = text[i]["text"]:gsub("\n", " \n "):gsub("\n ", "\n")
                src = src .. text[i]["text"]
                text[i]["text"] = text[i]["text"]:gsub(" ", "!S! ")
                texts = ""
                local words = text[i]["text"] or ""
                local style = text[i]["style"] or {"white"}
                local hover = text[i]["hover"]
                local color, name
                if text[i]["character"] then
                    for j = 1, #CHARACTERS do
                        if CHARACTERS[j].id == text[i]["character"] then
                            color = CHARACTERS[j].color
                            name = CHARACTERS[j].name or CHARACTERS[j].id
                            break
                        end
                    end
                end
                local _, defaultheight = GuiGetTextDimensions(Gui1, "!", DEFAULT_SIZE, LINE_SPACING, FONT)
                TEXT_SIZE = DEFAULT_SIZE * (text[i]["size"] or 1)
                for word in words:gmatch("[^ ]+") do
                    word = word:gsub("!S!", " ")
                    local cur_len = sizeof(word)
                    if line_len + cur_len >= LONGEST_WIDTH or word:find("\n") then
                        -- Start a new line if line is too long or we hit a newline character
                        f[#f+1] = {text = texts:gsub('%s*$', ''), style = style, x = x - sizeof(texts), y = (y + heightof(texts) / defaultheight), hover = hover,
                        size = TEXT_SIZE, forcetickrate = text[i]["forcetickrate"], dontcut = text[i]["dontcut"], click = text[i]["click"], character = text[i]["character"],
                        color = color, name = name}

                        y = y + LINE_SPACING
                        line_len = cur_len
                        texts = word:gsub("\n", "")
                        x = line_len
                    else
                        -- Add a word to the current line
                        line_len = line_len + cur_len
                        texts = texts .. word
                        x = line_len
                    end
                end
                f[#f+1] = {text = texts, style = style, x = x - sizeof(texts), y = (y + heightof(texts) / defaultheight), hover = hover,
                size = TEXT_SIZE, forcetickrate = text[i]["forcetickrate"], dontcut = text[i]["dontcut"], click = text[i]["click"], character = text[i]["character"],
                color = color, name = name}
            end
            x = 0
            i = i + 1
        end
    end

    if (f and #f > 0) or (src and src ~= "") then
        NewLine(smallfolk.dumps({f = f, full = src, behavior = input["behavior"], choices = input["choices"], set = input["set"]}))
    end
end

---@param file string? Source file for dialogue
---@param line number? Source line in the file
---@param charnum number? Source character in the line
---@param track string? Dialogue track to continue on
function SetScene(file, line, charnum, track)
    local file2, line2, charnum2, track2 = GetScene()
    print("Called SetScene: FILE: " .. (file or "nil") .. ", LINE: " .. (line or "nil") .. ", CHARNUM: " .. (charnum or "nil") .. ", TRACK:" .. (track or "nil"))
    if file    then ComponentSetValue2(this, "script_inhaled_material", file) else file = file2 end
    if line    then ComponentSetValue2(this, "script_throw_item", tostring(line)) else line = line2 end
    if charnum then ComponentSetValue2(this, "script_material_area_checker_failed", tostring(charnum)) else charnum = charnum2 end
    if track   then ComponentSetValue2(this, "script_material_area_checker_success", track) else track = track2 end
    dofile(file)
    if SCENE and SCENE[line] then
        if (SCENE[line]["onlyif"] == false) or (SCENE[line]["track"] ~= track and SCENE[line]["track"] ~= "any" and SCENE[line]["track"] ~= nil) then
            -- if line we were sent to is not on this track, search forward
            -- print("SEARCHING")
            nextLine(file, track, line)
        else
            local behavior = SCENE[line]["behavior"] or "nextline"
            local ss = SCENE[line]["setscene"]
            if ss then
                local default = ss["file"] and ((ss["filepath"] or "mods/noiting_simulator/files/scenes/") .. ss["file"])
                file = default or file
                line = ss["line"] or 1
                charnum = ss["charnum"] or 1
                track = ss["track"] or "main"
                SetScene(file, line, charnum, track)
            elseif behavior == "freeplayer" then
                -- scrapped overworld LockPlayer(false)
            else
                AddLines(SCENE[line])
            end
        end
    end
end

function Track(track)
    local file, line, charnum, _ = GetScene()
    nextLine(file, track, line)
end

local function getColors(input, r, g, b, a)
    r, g, b, a = r or 1, g or 1, b or 1, a or 1
    local color_presets = {
        -- general
        ["white"]    = function(r2, g2, b2, a2) return 1.00, 1.00, 1.00, 1.00 end,
        ["red"]      = function(r2, g2, b2, a2) return 0.80, 0.00, 0.00, 1.00 end,
        ["green"]    = function(r2, g2, b2, a2) return 0.00, 1.00, 0.40, 1.00 end,
        ["stamina"]  = function(r2, g2, b2, a2) return 0.10, 0.90, 0.20, 1.00 end,
        ["location"] = function(r2, g2, b2, a2) return 0.55, 0.90, 1.00, 1.00 end,
        ["info"]     = function(r2, g2, b2, a2) return 0.25, 0.45, 0.65, 1.00 end,
        ["interact"] = function(r2, g2, b2, a2) return 0.10, 0.80, 0.70, 1.00 end,
        ["yellow"]   = function(r2, g2, b2, a2) return 1.00, 1.00, 0.69, 1.00 end, -- closest to the color used by the game for hover
        -- modifiers
        ["grey"]    = function(r2, g2, b2, a2) return r2 * 0.7, g2 * 0.7, b2 * 0.7, a2 end,
        ["shadow"]  = function(r2, g2, b2, a2) return r2 * SHADOWDARK, g2 * SHADOWDARK, b2 * SHADOWDARK, a2 end,
        ["black"]   = function(r2, g2, b2, a2) return r2 * 0.0, g2 * 0.0, b2 * 0.0, a2 end,
        ["invis"]   = function(r2, g2, b2, a2) return 0, 0, 0, -1 end, -- 0 doesn't work for alpha for some reason
    }
    input = input or {"white"}
    for i = 1, #input do
        if color_presets[input[i]] then
            r, g, b, a = color_presets[input[i]](r, g, b, a)
        else
            print("error: no color '" .. input[i] .. "'")
        end
    end

    return
    (r > 1 and 1) or (r < 0 and 0) or r,
    (g > 1 and 1) or (g < 0 and 0) or g,
    (b > 1 and 1) or (b < 0 and 0) or b,
    (a > 1 and 1) or a
end

CANSCROLLUP, CANSCROLLDOWN = false, false
SKIP, NEXT, LEFT, RIGHT, UP, DOWN = 0, 0, 0, 0, 0, 0
BATTLETWEEN = 0

return function()
    if not (cc and ComponentGetEntity(cc) > 0) then
        RecalcPlayer()
    end
    local inbattle = GlobalsGetValue("NS_IN_BATTLE", "0") == "1"
    if inbattle then
        BATTLETWEEN = BATTLETWEEN + (1 - BATTLETWEEN) / 10
        EntitySetComponentIsEnabled(player, invgui, true)
        EntitySetComponentIsEnabled(player, chdata, true)
    else
        BATTLETWEEN = BATTLETWEEN + (0 - BATTLETWEEN) / 10
        EntitySetComponentIsEnabled(player, invgui, false)
        EntitySetComponentIsEnabled(player, chdata, false)
    end
    BY = BY_DEFAULT + ((BH + Margin * 2) * BATTLETWEEN)
    local sw, sh = GuiGetScreenDimensions(Gui1)
    if sw ~= SCREEN_W or sh ~= SCREEN_H then
        RecalcScreen()
        SCREEN_W, SCREEN_H = sw, sh
    end
    if GlobalsGetValue("NS_SETTING_RECALC", "0") == "1" then
        RecalcSettings()
        GlobalsSetValue("NS_SETTING_RECALC", "0")
    end
    local _id = 20
    local function id()
        _id = _id + 1
        return _id
    end

    GuiStartFrame(Gui1)
    GuiOptionsAdd(Gui1, 8) -- HandleDoubleClickAsClick; spammable buttons
    local file, line, charnum, track = GetScene()
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    if cc and GameGetFrameNum() % 2 == 0 then
        -- hold to zoooom
        if (ComponentGetValue2(cc, "mButtonDownRight")) and (ComponentGetValue2(cc, "mButtonFrameRight") < GameGetFrameNum() - 30) then
            RIGHT = 1
        end
        if (ComponentGetValue2(cc, "mButtonDownLeft")) and (ComponentGetValue2(cc, "mButtonFrameLeft") < GameGetFrameNum() - 30) then
            LEFT = 1
        end
    end
    local keybinds = {
        ["skip"]  = not inbattle and (SKIP  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonDownKick") or ComponentGetValue2(cc, "mButtonDownThrow")) or false)),
        ["next"]  = not inbattle and (NEXT  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameInteract") == GameGetFrameNum()) or false)),
        ["left"]  = not inbattle and (LEFT  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameLeft") == GameGetFrameNum()))),
        ["right"] = not inbattle and (RIGHT > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameRight") == GameGetFrameNum()))),
        ["up"]    = not inbattle and (UP    > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameUp") == GameGetFrameNum()))),
        ["down"]  = not inbattle and (DOWN  > 0 or (cc > 0 and (ComponentGetValue2(cc, "mButtonFrameDown") == GameGetFrameNum()))),
    }
    SKIP, NEXT, LEFT, RIGHT, UP, DOWN = SKIP - 1, NEXT - 1, LEFT - 1, RIGHT - 1, UP - 1, DOWN - 1

    local done = true
    local tick = math.max(1, TICKRATE)
    LINES = {}
    for i = 1, #comps do
        -- advance the text of only the topmost unfinished line
        local thing = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
        local amount = ComponentGetValue2(comps[i], "value_int")
        local full = utf8.len(thing["full"])
        if amount < full then
            if (TICKRATE >= 0 or (GameGetFrameNum() % (TICKRATE * -1) == 0) or keybinds["skip"]) and GameGetFrameNum() > 60 then
                if thing["behavior"] == "instant" or keybinds["skip"] then
                    amount = full
                elseif tick > 0 then
                    done = false
                    local reallen = utf8.len(utf8.sub(thing["full"], amount + 1, amount + tick))
                    amount = amount + reallen
                    tick = tick - reallen
                end
                ComponentSetValue2(comps[i], "value_int", amount)
                GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_select", px, py)
            else
                done = false
            end
        end
        LINES[#LINES+1] = {["table"] = thing, ["amount"] = amount}
    end
    -- if we reach the end and not ticked, we know we've reached the end of text
    local character, name
    local color = {113, 113, 113, 255}

    GuiZSetForNextWidget(Gui1, 10)
    GuiOptionsAddForNextWidget(Gui1, 9) -- GamepadDefaultWidget
    -- draw container
    local last = #LINES

    local x, y, yadd = BX, BY, 0
    local history = tonumber(GlobalsGetValue("NS_HISTORY", "0"))
    local scroll = tonumber(GlobalsGetValue("NS_SCROLL", "0"))
    if done then
        if keybinds["left"] and history + 1 < last then
            history = history + 1
            GlobalsSetValue("NS_HISTORY", tostring(history))
            GlobalsSetValue("NS_SCROLL", "0")
            keybinds["left"] = false
        elseif keybinds["right"] and history > 0 then
            history = history - 1
            GlobalsSetValue("NS_HISTORY", tostring(history))
            GlobalsSetValue("NS_SCROLL", "0")
            scroll = 0
            keybinds["right"] = false
        end
    end

    if CANSCROLLUP and keybinds["up"] then
        scroll = scroll + 1
        GlobalsSetValue("NS_SCROLL", tostring(scroll))
    end
    if CANSCROLLDOWN and keybinds["down"] then
        scroll = scroll - 1
        GlobalsSetValue("NS_SCROLL", tostring(scroll))
    end
    CANSCROLLUP, CANSCROLLDOWN = false, false

    local topline_y = BY + LINE_SPACING + Margin / 2
    local bottomline_y = BY + (LONGEST_HEIGHT - LINE_SPACING) + Margin / 2

    local cango = false
    for q = 1, last do
        local f = LINES[q]["table"]["f"] or {}

        -- text rendering
        local charc = LINES[q]["amount"]
        local hasclick = false
        for i = 1, #f do
            if f[i]["click"] then hasclick = true break end
        end

        -- behavior
        -- GamePrint("charc: " .. tostring(charc))
        if q == last - history then
            local lastline = LINES[q]["table"]
            local behavior = lastline["behavior"] or "nextline"
            if done then -- text is done typing, this runs continuously
                if lastline["set"] then
                    file = lastline["set"]["file"] or file
                    line = lastline["set"]["lineadd"] and (track + lastline["set"]["lineadd"]) or lastline["set"]["line"] or line
                    track = lastline["set"]["track"] or track
                    charnum = lastline["set"]["charnum"] or charnum
                end

                -- go to next line if enter pressed
                if not hasclick then
                    if behavior == "wait" and history == 0 then
                        -- advance when conditional
                        -- can't serialize functions so have to dofile unfortunately
                        dofile(file)
                        if SCENE[line]["waitfor"] == true then
                            nextLine(file, track, line)
                        end
                    elseif history == 0 then
                        if ((behavior == "nextline" and keybinds["right"]) or behavior == "auto") then
                            -- normal advancement
                            nextLine(file, track, line)
                            GamePlaySound("data/audio/Desktop/ui.bank", "ui/streaming_integration/voting_start", px, py)
                        else
                            cango = true
                        end
                    end
                end
            end

            --[[debug: gui pointer cursor
            Qx, Qy = Qx or 0, Qy or 0
            local speed = 2
            if InputIsKeyDown(225) or InputIsKeyDown(229) then speed = speed * 2 end
            if InputIsKeyDown(224) or InputIsKeyDown(228) then speed = speed * 0.25 end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownDown") then Qy = Qy + speed end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownUp") then Qy = Qy - speed end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownLeft") then Qx = Qx - speed end
            if cc > 0 and ComponentGetValue2(cc, "mButtonDownRight") then Qx = Qx + speed end
            GuiImage(Gui1, id(), Qx, Qy, "mods/noiting_simulator/files/gui/gfx/1px_white.png", 1, 1, 1)
            GuiText(Gui1, Qx, Qy, tostring(Qx) .. ", " .. tostring(Qy), 1, FONT)
            GuiText(Gui1, Qx, Qy + LINE_SPACING, "BX: " .. tostring(BX) .. ", BY: " .. tostring(BY), 1, FONT)
            GuiText(Gui1, Qx, Qy + LINE_SPACING * 2, "BW: " .. tostring(BW) .. ", BH: " .. tostring(BH), 1, FONT)
            ]]--

            for j = 1, #f do
                f[j]["x"] = f[j]["x"] + BX
                f[j]["y"] = f[j]["y"] + BY + Margin / 2 + LINE_SPACING + (scroll * LINE_SPACING)
                local click = f[j]["click"]
                -- Typing animation
                local invis = f[j]["text"]
                if not (f[j]["dontcut"]) then
                    local ocharc = charc
                    f[j]["text"] = utf8.sub(f[j]["text"], 1, charc)
                    charc = charc - utf8.len(f[j]["text"])
                    if charc == 0 and ocharc > 0 then
                        -- this is the text we're currently on
                        TICKRATE = f[j]["forcetickrate"] or DEFAULT_TICKRATE
                    end
                end
                GuiZSet(Gui1, 8)

                -- Text display
                if (f[j]["done"] or 0) == history then -- display correct text or history if specified
                    character = f[j]["character"] or character
                    color = f[j]["color"] or color
                    name = f[j]["name"] or name
                    local wid_x, wid_y = GuiGetTextDimensions(Gui1, f[j]["text"], f[j]["size"], LINE_SPACING, FONT)
                    local toolow = f[j]["y"] + wid_y / 4 + LINE_SPACING / 2 > bottomline_y
                    local toohigh = f[j]["y"] - wid_y / 4 + LINE_SPACING / 2 < topline_y

                    if not (toolow or toohigh) then -- only display if not over lines
                        local r, g, b, a = getColors(f[j]["style"])
                        GuiColorSetForNextWidget(Gui1, r, g, b, a)
                        if click then
                            -- THIS IS CLICKABLE
                            if click["appearif"] ~= false then -- always true if not specified
                                if history ~= 0 then
                                    GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
                                    r, g, b, a = getColors({"interact", "grey"})
                                else
                                    r, g, b, a = getColors({"interact"})
                                end
                                GuiColorSetForNextWidget(Gui1, r, g, b, a)
                                local lmb, rmb = GuiButton(Gui1, id(), f[j]["x"], f[j]["y"], f[j]["text"], f[j]["size"], FONT)
                                if lmb or rmb then
                                    if click["clickableif"] ~= false then -- always true if not specified
                                        SetScene(click["file"] or file, (click["lineadd"] and (line + click["lineadd"])) or click["line"] or line, click["charnum"] or charnum, click["track"] or track)
                                        if rmb then SKIP = 3 end
                                    else
                                        GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", px, py)
                                    end
                                else
                                    -- display clicker box
                                    GuiZSet(Gui1, 11)
                                    local _, _, hover, lx, ly, w, h = GuiGetPreviousWidgetInfo(Gui1)
                                    if history == 0 then
                                        if hover and click["clickableif"] ~= false then
                                            r, g, b, a = getColors({"yellow"})
                                        elseif hover then
                                            r, g, b, a = getColors({"red"})
                                        end
                                    end

                                    local wx, wy = lx, ly + h - (f[j]["size"] * 2)
                                    GuiColorSetForNextWidget(Gui1, r, g, b, a)
                                    GuiImage(Gui1, id(), wx, wy, "mods/noiting_simulator/files/gui/gfx/1px_white.png", 1, w, f[j]["size"])

                                    GuiColorSetForNextWidget(Gui1, getColors({"shadow"}, r, g, b, a))
                                    GuiZSet(Gui1, 12)
                                    wx, wy = wx + f[j]["size"] * SHADOW_OFFSET, wy + f[j]["size"] * SHADOW_OFFSET
                                    GuiImage(Gui1, id(), wx, wy, "mods/noiting_simulator/files/gui/gfx/1px_white.png", 1, w, f[j]["size"])
                                end
                            else
                                -- Hide it completely
                                f[j]["text"] = ""
                            end
                        else
                            -- DEFAULT BEHAVIOR
                            GuiText(Gui1, f[j]["x"], f[j]["y"], f[j]["text"], f[j]["size"], FONT)
                            --[[ debug: text alignment bars
                            local _, _, hover = GuiGetPreviousWidgetInfo(Gui1)

                            local alpha = 0.2
                            if hover then GuiColorSetForNextWidget(Gui1, 1, 0.8, 0.8, 1) alpha = 1 else GuiColorSetForNextWidget(Gui1, 1, 0.6, 0.6, 1) end
                            GuiImage(Gui1, id(), x, f[j]["y"] + wid_y / 4 + LINE_SPACING / 2, "mods/noiting_simulator/files/gui/gfx/1px_white.png", alpha, BW, f[j]["size"])
                            if hover then GuiColorSetForNextWidget(Gui1, 0.8, 0.8, 1, 1) alpha = 1 else GuiColorSetForNextWidget(Gui1, 0.6, 0.6, 1, 1) end
                            GuiImage(Gui1, id(), x, f[j]["y"] - wid_y / 4 + LINE_SPACING / 2, "mods/noiting_simulator/files/gui/gfx/1px_white.png", alpha, BW, f[j]["size"])
                            ]]--
                        end

                        -- Hover text (implemented even if we might not use it)
                        -- GuiTooltip(Gui1, tostring(j) .. f[j]["text"], "x: " .. tostring(f[j]["x"]) .. ", y: " .. tostring(f[j]["y"]) .. ", yadd: " .. tostring(yadd))
                        if f[j]["hover"] then
                            GuiTooltip(Gui1, f[j]["hover"], "")
                        end

                        -- Text invis (so box doesn't bump)
                        GuiColorSetForNextWidget(Gui1, getColors({"invis"}))
                        GuiZSet(Gui1, 9)
                        GuiText(Gui1, f[j]["x"], f[j]["y"], invis, f[j]["size"], FONT)

                        -- Text shadow
                        GuiColorSetForNextWidget(Gui1, getColors({"shadow"}, r, g, b, a))
                        GuiZSet(Gui1, 12)
                        GuiText(Gui1, f[j]["x"] + f[j]["size"] * SHADOW_OFFSET, f[j]["y"] + f[j]["size"] * SHADOW_OFFSET, f[j]["text"], f[j]["size"], FONT)
                        yadd = yadd + LINE_SPACING
                        -- y = y + LINE_SPACING
                    else
                        if toohigh then CANSCROLLUP = true end
                        if toolow then CANSCROLLDOWN = true end
                    end
                end

            end
        end

        --[[
        x = BX
        local addx = BW / 4
        local addy = BH / 6
        local left, middle, right = 0, 0, 0
        y = BY + yadd + LINE_SPACING + Margin / 2 --+ (addy / 2)

        -- GuiImage(Gui1, id(), x, y, "data/ui_gfx/1px_white.png", 1, LONGEST_WIDTH, 1)
        _id = _id + 20 -- not necessary?
        for i = 1, #choice do
            TEXT_SIZE = DEFAULT_SIZE * (choice[i]["size"] or 1)
            local text = choice[i]["name"]
            local cx = x + addx * 2
            local cy = y
            if choice[i]["position"] == "leftmost" then
                cx = x
                cy = y
            elseif choice[i]["position"] == "left" then
                cx = cx - addx
                cy = cy - left
                left = left - addy
            elseif choice[i]["position"] == "middle" then
                cy = cy - middle
                middle = middle - addy
            elseif choice[i]["position"] == "right" then
                cx = cx + addx
                cy = cy - right
                right = right - addy
            end
            local style = choice[i]["style"] or {"interact"}
            style = choice[i]["staminacost"] or style
            GuiZSet(Gui1, 6)
            GuiColorSetForNextWidget(Gui1, getColors(style))
            -- text button
            if history ~= 0 then
                GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
            end
            GuiOptionsAddForNextWidget(Gui1, 16) -- Align_HorizontalCenter
            local lmb, rmb = GuiButton(Gui1, id(), cx, cy, text, TEXT_SIZE, FONT)
            if lmb or rmb then
                if true then -- conditionals here later
                    SetScene(file, choice[i]["set"]["line"] or line + 1, choice[i]["charnum"] or charnum, choice[i]["set"]["track"] or track)
                    if rmb then SKIP = 3 end
                else
                    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", px, py)
                end
            end
            -- text shadow
            GuiZSet(Gui1, 7)
            style[#style+1] = "shadow"
            GuiColorSetForNextWidget(Gui1, getColors(style))
            GuiOptionsAddForNextWidget(Gui1, 29) -- TextRichRendering: what does this do?
            GuiOptionsAddForNextWidget(Gui1, 16) -- Align_HorizontalCenter
            GuiText(Gui1, cx + TEXT_SIZE * SHADOW_OFFSET, cy + TEXT_SIZE * SHADOW_OFFSET, text, TEXT_SIZE, FONT)
        end
    ]]--
    end

    -- draw black background and box
    GuiZSetForNextWidget(Gui1, 30)
    GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
    local boxfile = character and ("mods/noiting_simulator/files/gui/gfx/boxes/" .. character .. ".png") or "mods/noiting_simulator/files/gui/gfx/boxes/box.png"
    GuiImageNinePiece(Gui1, id(), BX - Margin / 2, BY - Margin / 2, BW + Margin, BH + Margin, 1, boxfile)

    local r, g, b, a = color[1] / 255, color[2] / 255, color[3] / 255, color[4] / 255

    -- additional box elements

    GuiColorSetForNextWidget(Gui1, r, g, b, a)
    GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
    GuiImage(Gui1, id(), BX, bottomline_y, "mods/noiting_simulator/files/gui/gfx/boxes/1px_white.png", 1, LONGEST_WIDTH, 1)
    GuiOptionsAddForNextWidget(Gui1, 2) -- NonInteractive
    GuiColorSetForNextWidget(Gui1, r, g, b, a)
    GuiImage(Gui1, id(), BX, topline_y, "mods/noiting_simulator/files/gui/gfx/boxes/1px_white.png", 1, LONGEST_WIDTH, 1)

    local nx, ny = BX + Margin / 2, topline_y
    local w, h = GuiGetTextDimensions(Gui1, "<", TEXT_SIZE * 1.25, LINE_SPACING, FONT)
    local bigw = GuiGetTextDimensions(Gui1, "-1", TEXT_SIZE * 1.25, LINE_SPACING, FONT)
    ny = ny - h
    if name then
        GuiOptionsAddForNextWidget(Gui1, 16) -- Align_HorizontalCenter
        GuiColorSetForNextWidget(Gui1, r, g, b, a)
        GuiText(Gui1, BX + Margin / 2 + BW / 2, ny + Margin / 2, name, TEXT_SIZE * 1.25, FONT)
    end

    _id = _id + 30
    if last - history > 1 and done then
        -- LEFT
        GuiColorSetForNextWidget(Gui1, r, g, b, a)
        local lmb, rmb = GuiButton(Gui1, id(), nx, ny, "<", TEXT_SIZE * 1.25, FONT)
        LEFT = (lmb and 1) or (rmb and 5) or LEFT
    end
    nx = nx + w
    local rightid = id()
    if history ~= 0 or cango then
        -- NUMBER
        local text = tostring(0 - history)
        if history == 0 then
            nx = nx + bigw
            GuiColorSetForNextWidget(Gui1, 255 / 255, 235 / 255, 120 / 255, 255 / 255)
        else
            GuiColorSetForNextWidget(Gui1, r, g, b, a)
            GuiText(Gui1, nx, ny, text, TEXT_SIZE * 1.25, FONT)
            GuiColorSetForNextWidget(Gui1, r, g, b, a)
            w, h = GuiGetTextDimensions(Gui1, text, TEXT_SIZE * 1.25, LINE_SPACING, FONT)
            nx = nx + w
        end

        -- RIGHT
        local lmb, rmb = GuiButton(Gui1, rightid, nx, ny, ">", TEXT_SIZE * 1.25, FONT)
        RIGHT = (lmb and 1) or (rmb and 5) or RIGHT
    end
    nx, ny = BX + Margin / 2, bottomline_y

    w, h = GuiGetTextDimensions(Gui1, "^", TEXT_SIZE * 1.25, LINE_SPACING, FONT)
    if CANSCROLLDOWN then
        -- DOWN
        GuiColorSetForNextWidget(Gui1, r, g, b, a)
        local lmb, rmb = GuiButton(Gui1, id(), nx, ny, "↓", TEXT_SIZE * 1.25, FONT)
        DOWN = (lmb and 1) or (rmb and 5) or DOWN
    end
    nx = nx + w

    if scroll < 0 then
        local text = tostring(0 - scroll)
        GuiColorSetForNextWidget(Gui1, r, g, b, a)
        GuiText(Gui1, nx, ny, text, TEXT_SIZE * 1.25, FONT)
        w, h = GuiGetTextDimensions(Gui1, text, TEXT_SIZE * 1.25, LINE_SPACING, FONT)
        nx = nx + w

        -- UP
        GuiColorSetForNextWidget(Gui1, r, g, b, a)
        local lmb, rmb = GuiButton(Gui1, id(), nx, ny, "^", TEXT_SIZE * 1.25, FONT)
        UP = (lmb and 1) or (rmb and 5) or UP
    end
end