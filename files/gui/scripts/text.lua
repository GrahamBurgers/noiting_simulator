local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local utf8 = dofile_once("mods/noiting_simulator/files/scripts/utf8.lua")
local child = EntityGetWithName("ns_text_handler")
local this = EntityGetFirstComponent(child, "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()
local px, py, cc = 0, 0, nil

if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

function RecalcPlayer()
    local player = EntityGetWithTag("player_unit") or {}
    if #player > 0 then
        px, py = EntityGetTransform(player[1])
        cc = EntityGetFirstComponent(player[1], "ControlsComponent")
    end
    print("RECALC PLAYER")
end
RecalcPlayer()

function RecalcSettings()
    MAX_LINES = 100 -- ModSettingGet("noiting_simulator.max_lines")
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
    SCREEN_W, SCREEN_H = GuiGetScreenDimensions(Gui)
    LONGEST_WIDTH = (SCREEN_W * 0.8)
    LONGEST_HEIGHT = (SCREEN_H * 0.4)
    BW, BH = LONGEST_WIDTH, LONGEST_HEIGHT
    BX, BY = (SCREEN_W * 0.5) - (BW * 0.5) - Margin / 2, (SCREEN_H * 1) - (BH * 1) - (Margin * 2)
    print("RECALC SCREEN")
end
RecalcScreen()

-- constant strings
local c_arrow = [[>>>]]
local c_cutoff = "[...]"
local c_anytrack = "any"

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui, text:gsub("\n", ""):gsub("!S!", " "), TEXT_SIZE, LINE_SPACING, FONT)
    return w
end

---@param text string
---@return number
local function heightof(text)
    local w, h = GuiGetTextDimensions(Gui, text:gsub("\n", ""):gsub("!S!", " "), TEXT_SIZE, LINE_SPACING, FONT)
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
            current["full"] = c_cutoff
            current["texts"] = {{text = c_cutoff, style = {"white", "grey"}}}
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
            current["f"][j]["done"] = true
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
        if SCENE[start]["track"] == track or SCENE[start]["track"] == c_anytrack then
            SetScene(nil, start, nil, track)
            break
        end
        start = start + 1
    end
end

---@param input table Should have a texts field
function AddLines(input)
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

    -- GlobalsSetValue("NS_DEBUG", smallfolk.dumps(input))

    local i = 1
    local texts = ""
    if input["texts"] then
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
                local _, defaultheight = GuiGetTextDimensions(Gui, "!", DEFAULT_SIZE, LINE_SPACING, FONT)
                TEXT_SIZE = DEFAULT_SIZE * (text[i]["size"] or 1)
                for word in words:gmatch("[^ ]+") do
                    word = word:gsub("!S!", " ")
                    local cur_len = sizeof(word)
                    if line_len + cur_len >= LONGEST_WIDTH or word:find("\n") then
                        -- Start a new line if line is too long or we hit a newline character
                        f[#f+1] = {text = texts, style = style, x = x - sizeof(texts), y = (y + heightof(texts) / defaultheight), hover = hover,
                        size = TEXT_SIZE, forcetickrate = text[i]["forcetickrate"], dontcut = text[i]["dontcut"], click = text[i]["click"]}

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
                size = TEXT_SIZE, forcetickrate = text[i]["forcetickrate"], dontcut = text[i]["dontcut"], click = text[i]["click"]}
            end
            x = 0
            i = i + 1
        end
    end

    if (f and #f > 0) or (src and src ~= "") then
        NewLine(smallfolk.dumps({f = f, full = src, behavior = input["behavior"], choices = input["choices"], gototrack = input["gototrack"],}))
    end
end

---@param file string? Source file for dialogue
---@param line number? Source line in the file
---@param charnum number? Source character in the line
---@param track string? Dialogue track to continue on
function SetScene(file, line, charnum, track)
    local file2, line2, charnum2, track2 = GetScene()
    if file    then ComponentSetValue2(this, "script_inhaled_material", file) else file = file2 end
    if line    then ComponentSetValue2(this, "script_throw_item", tostring(line)) else line = line2 end
    if charnum then ComponentSetValue2(this, "script_material_area_checker_failed", tostring(charnum)) else charnum = charnum2 end
    if track   then ComponentSetValue2(this, "script_material_area_checker_success", track) else track = track2 end
    dofile(file)
    -- print("FILE: " .. file .. ", LINE: " .. line .. ", CHARNUM: " .. charnum .. ", TRACK:" .. track)
    if SCENE and SCENE[line] then
        if SCENE[line]["track"] ~= track and SCENE[line]["track"] ~= c_anytrack then
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
                greyLines()
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
        ["yellow"]   = function(r2, g2, b2, a2) return 1.00, 1.00, 0.69, 1.00 end, -- used by the game for hover (sort of)
        -- characters
        ["kolmi"]          = function(r2, g2, b2, a2) return 0.65, 0.95, 0.85, 1.00 end,
        ["parantajahiisi"] = function(r2, g2, b2, a2) return 0.90, 0.80, 1.00, 1.00 end,
        ["stendari"]       = function(r2, g2, b2, a2) return 1.00, 0.70, 0.70, 1.00 end,
        ["snipuhiisi"]     = function(r2, g2, b2, a2) return 1.00, 0.85, 0.70, 1.00 end,
        ["ukko"]           = function(r2, g2, b2, a2) return 0.75, 0.90, 1.00, 1.00 end,
        ["3 hamis"]        = function(r2, g2, b2, a2) return 1.00, 0.80, 1.00, 1.00 end,
        -- modifiers
        ["grey"]    = function(r2, g2, b2, a2) return r2 * 0.5, g2 * 0.5, b2 * 0.5, a2 end,
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

SKIP = 0
NEXT = 0
return function()
    local sw, sh = GuiGetScreenDimensions(Gui)
    if sw ~= SCREEN_W or sh ~= SCREEN_H then
        RecalcScreen()
        SCREEN_W, SCREEN_H = sw, sh
    end
    if GlobalsGetValue("NS_SETTING_RECALC", "0") == "1" then
        RecalcSettings()
        GlobalsSetValue("NS_SETTING_RECALC", "0")
    end
    if not (cc and ComponentGetEntity(cc) > 0) then
        cc = 0
        RecalcPlayer()
    end
    -- local locked = (vs and ComponentGetValue2(vs, "value_bool")) or false
    local _id = 20
    local function id()
        _id = _id + 1
        return _id
    end

    GuiStartFrame(Gui)
    local file, line, charnum, track = GetScene()
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    -- TODO: keybinds in mod settings
    local keybinds = {
        ["skip"] = SKIP > 0 or (cc and (cc > 0) and ComponentGetValue2(cc, "mButtonDownKick") or false),
        ["next"] = NEXT > 0 or (cc and (cc > 0) and (ComponentGetValue2(cc, "mButtonFrameInteract") == GameGetFrameNum()) or false),
    }
    SKIP = SKIP - 1
    NEXT = NEXT - 1

    local done = true
    local tick = math.max(1, TICKRATE)
    LINES = {}
    for i = 1, #comps do
        -- advance the text of only the topmost unfinished line
        local thing = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
        local amount = ComponentGetValue2(comps[i], "value_int")
        local full = utf8.len(thing["full"])
        if amount < full then
            if (TICKRATE >= 0 or (GameGetFrameNum() % (TICKRATE * -1) == 0) or keybinds["skip"]) then
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

    -- draw black background
    GuiZSetForNextWidget(Gui, 30)
    GuiImage(Gui, id(), BX - Margin / 2, BY - Margin / 2, "mods/noiting_simulator/files/gfx/1px_black.png", 1, BW + Margin * 2, BH + Margin * 2)

    GuiZSetForNextWidget(Gui, 10)
    GuiOptionsAddForNextWidget(Gui, 9) -- GamepadDefaultWidget
    -- draw container
    GuiBeginScrollContainer(Gui, id(), BX, BY, BW, BH, true, 2, 2)
    local x, y, yadd, yadd2 = 0, 0, 0, 0
    local choice = {}
    local last = #LINES
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
        if q == last then
            local arrow = "hide"
            local lastline = LINES[q]["table"]
            local choices = lastline["choices"]
            local behavior = lastline["behavior"] or "nextline"
            if done then
                track = lastline["gototrack"] or track
                -- go to next line if enter pressed
                if choices or hasclick then
                    arrow = "gone"
                    choice = choices or {}
                elseif behavior == "none" then
                    arrow = "hide"
                elseif behavior == "wait" then
                    -- advance when conditional
                    -- can't serialize functions so have to dofile unfortunately
                    dofile(file)
                    if SCENE[line]["waitfor"] == true then
                        nextLine(file, track, line)
                    end
                elseif (behavior == "nextline" or behavior == "auto") then
                    arrow = "show"
                    if keybinds["next"] or behavior == "auto" then
                        -- normal advancement
                        nextLine(file, track, line)
                        GamePlaySound("data/audio/Desktop/ui.bank", "ui/streaming_integration/voting_start", px, py)
                    end
                end
            end
            if arrow ~= "gone" then
                -- draw advancement arrow
                local w, h = GuiGetTextDimensions(Gui, c_arrow, DEFAULT_SIZE)
                f[#f+1] = {text = c_arrow, dontcut = true, x = LONGEST_WIDTH - w, y = h, size = DEFAULT_SIZE, clickskip = true}
                -- hide it if the player can't advance (also blink)
                if not (arrow == "show" and GameGetFrameNum() % 40 > 20) then
                    f[#f].style = {"invis"}
                end
            end
        end

        for j = 1, #f do
            if f[j]["clickskip"] then
                -- draw arrows always on bottom
                f[j]["y"] = f[j]["y"] + (yadd2 or yadd)
                if done then
                    -- clickable skip arrow
                    GuiColorSetForNextWidget(Gui, 0, 0, 0, -1)
                    GuiZSet(Gui, 7)
                    local lmb, rmb = GuiButton(Gui, id(), f[j]["x"], f[j]["y"], f[j]["text"], f[j]["size"], FONT)
                    if lmb or rmb then NEXT = 1 end
                    if rmb then SKIP = 3 end
                end
            else
                f[j]["y"] = f[j]["y"] + yadd
            end
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
            GuiZSet(Gui, 8)

            -- Text display
            local r, g, b, a = getColors(f[j]["style"])
            GuiColorSetForNextWidget(Gui, r, g, b, a)
            if click and (not f[j]["done"]) and utf8.len(f[j]["text"]) > 1 then
                -- THIS IS CLICKABLE
                if click["appearif"] ~= false then -- always true if not specified
                    local lmb, rmb = GuiButton(Gui, id(), f[j]["x"], f[j]["y"], f[j]["text"], f[j]["size"], FONT)
                    if lmb or rmb then
                        if click["clickableif"] ~= false then -- always true if not specified
                            SetScene(file, click["gotoline"] or line + 1, click["charnum"] or charnum, click["gototrack"] or track)
                            if rmb then SKIP = 3 end
                        else
                            GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", px, py)
                        end
                    else
                        -- display clicker box
                        GuiZSet(Gui, 11)
                        local _, _, hover, lx, ly, w, h = GuiGetPreviousWidgetInfo(Gui)
                        if hover and click["clickableif"] ~= false then
                            r, g, b, a = getColors({"yellow"})
                        elseif hover then
                            r, g, b, a = getColors({"red"})
                        end

                        -- move underlines outside the box otherwise scrollbar becomes super long
                        local wx, wy = lx, ly + h - (f[j]["size"] * 2)
                        GuiColorSetForNextWidget(Gui, r, g, b, a)
                        GuiOptionsAddForNextWidget(Gui, 15) -- Layout_NoLayouting
                        GuiImage(Gui, id(), wx, wy, "mods/noiting_simulator/files/gui/gfx/1px_white.png", 1, w, f[j]["size"])

                        GuiColorSetForNextWidget(Gui, getColors({"shadow"}, r, g, b, a))
                        GuiZSet(Gui, 12)
                        wx, wy = wx + f[j]["size"] * SHADOW_OFFSET, wy + f[j]["size"] * SHADOW_OFFSET
                        GuiOptionsAddForNextWidget(Gui, 15) -- Layout_NoLayouting
                        GuiImage(Gui, id(), wx, wy, "mods/noiting_simulator/files/gui/gfx/1px_white.png", 1, w, f[j]["size"])
                    end
                else
                    -- Hide it completely
                    f[j]["text"] = ""
                end
            else
                -- DEFAULT BEHAVIOR
                GuiText(Gui, f[j]["x"], f[j]["y"], f[j]["text"], f[j]["size"], FONT)
            end

            -- Hover text (implemented even if we might not use it)
            -- GuiTooltip(Gui, (f[j]["id"] or "") .. f[j]["text"], "x: " .. tostring(f[j]["x"]) .. ", y: " .. tostring(f[j]["y"]) .. ", yadd: " .. tostring(yadd))
            if f[j]["hover"] then
                GuiTooltip(Gui, f[j]["hover"], "")
            end

            -- Text invis (so box doesn't bump)
            GuiColorSetForNextWidget(Gui, getColors({"invis"}))
            GuiZSet(Gui, 9)
            GuiText(Gui, f[j]["x"], f[j]["y"], invis, f[j]["size"], FONT)

            -- Text shadow
            GuiColorSetForNextWidget(Gui, getColors({"shadow"}, r, g, b, a))
            GuiZSet(Gui, 10)
            GuiText(Gui, f[j]["x"] + f[j]["size"] * SHADOW_OFFSET, f[j]["y"] + f[j]["size"] * SHADOW_OFFSET, f[j]["text"], f[j]["size"], FONT)
            yadd2 = f[j]["y"]
        end
        yadd = yadd2 + LINE_SPACING
        y = y + LINE_SPACING
    end

    local addx = BW / 4
    local addy = BH / 6
    local left, middle, right = 0, 0, 0
    y = yadd --+ (addy / 2)

    -- GuiImage(Gui, id(), x, y, "data/ui_gfx/1px_white.png", 1, LONGEST_WIDTH, 1)
    _id = _id + 20 -- not necessary
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
            GuiOptionsAdd(Gui, 16) -- Align_HorizontalCenter
        elseif choice[i]["position"] == "middle" then
            cy = cy - middle
            middle = middle - addy
            GuiOptionsAdd(Gui, 16) -- Align_HorizontalCenter
        elseif choice[i]["position"] == "right" then
            cx = cx + addx
            cy = cy - right
            right = right - addy
            GuiOptionsAdd(Gui, 16) -- Align_HorizontalCenter
        end
        local style = choice[i]["style"] or {"interact"}
        style = choice[i]["staminacost"] or style
        GuiZSet(Gui, 6)
        GuiColorSetForNextWidget(Gui, getColors(style))
        -- text button
        local lmb, rmb = GuiButton(Gui, id(), cx, cy, text, TEXT_SIZE, FONT)
        if lmb or rmb then
            if true then -- conditionals here later
                SetScene(file, choice[i]["gotoline"] or line + 1, choice[i]["charnum"] or charnum, choice[i]["gototrack"] or track)
                if rmb then SKIP = 3 end
            else
                GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", px, py)
            end
        end
        -- text shadow
        GuiZSet(Gui, 7)
        style[#style+1] = "shadow"
        GuiColorSetForNextWidget(Gui, getColors(style))
        GuiOptionsAddForNextWidget(Gui, 29) -- TextRichRendering: what does this do?
        GuiText(Gui, cx + TEXT_SIZE * SHADOW_OFFSET, cy + TEXT_SIZE * SHADOW_OFFSET, text, TEXT_SIZE, FONT)
    end
    GuiEndScrollContainer(Gui)
end