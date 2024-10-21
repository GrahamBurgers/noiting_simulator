local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local child = EntityGetWithName("noiting_sim_handler")
local this = EntityGetFirstComponent(child, "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()
local px, py = EntityGetTransform(EntityGetWithTag("player_unit")[1])
if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

-- todo: these should be settable by the user
local TEXT_SIZE = 1.5
local MAX_LINES = 100
local TICKRATE = 1
local LINE_SPACING = 15
local SHADOW_OFFSET = 0.9

local screen_x, screen_y = GuiGetScreenDimensions(Gui)
local LONGEST_WIDTH = (screen_x / (TEXT_SIZE * 2))
local LONGEST_HEIGHT = (screen_y / (TEXT_SIZE * 3.5))

local bx, by = (screen_x / 4) - (LONGEST_WIDTH / 2), (screen_y / 2.7) - (LONGEST_HEIGHT / 2)
local bw, bh = LONGEST_WIDTH, LONGEST_HEIGHT

local noinfiniteloop = 0

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui, text:gsub("\n", ""):gsub("!S!", " "), TEXT_SIZE)
    return w
end

function NewLine(serialized)
    -- remove lines that are too old
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local age = ComponentGetValue2(comps[i], "value_float")
        ComponentSetValue2(comps[i], "value_float", age + 1)
        if age > MAX_LINES then
            EntityRemoveComponent(child, comps[1])
        elseif age == MAX_LINES then
            ComponentSetValue2(comps[i], "name", "[...]")
        end
    end
    EntityAddComponent2(child, "VariableStorageComponent", {
        _tags="noiting_sim_line",
        value_string=serialized,
        name="",
        value_float=1,
    })
end

---@param input table Should have a texts field
local function addLines(input)
    local src = ""
    for i = 1, #input["texts"] do
        input["texts"][i]["text"] = input["texts"][i]["text"]:gsub("\n", " \n ")
        src = src .. input["texts"][i]["text"]
    end
    input["full"] = src
    NewLine(smallfolk.dumps(input))
end

---@return string file
---@return number line
---@return number charnum
---@return number track
function GetScene()
    local file = ComponentGetValue2(this, "script_inhaled_material")
    local line = tonumber(ComponentGetValue2(this, "script_throw_item")) or 1
    local charnum = tonumber(ComponentGetValue2(this, "script_material_area_checker_failed")) or 1
    local track = tonumber(ComponentGetValue2(this, "script_material_area_checker_success")) or 1
    return file, line, charnum, track
end

---@param scene string? Source file for dialogue
---@param track number? Track to look for
---@param start number? Line to start looking from
local function nextLine(scene, track, start)
    -- default function for most lines
    scene = scene or ComponentGetValue2(this, "script_inhaled_material")
    start = (start or tonumber(ComponentGetValue2(this, "script_throw_item")) or 1) + 1
    dofile_once(scene)
    track = track or 1
    while start <= #SCENE do
        if SCENE[start]["track"] == track then
            SetScene(nil, start, 1, nil)
            break
        end
        start = start + 1
    end
end

---@param file string? Source file for dialogue
---@param line number? Source line in the file
---@param charnum number? Source character in the line
---@param track number? Dialogue track to continue on
function SetScene(file, line, charnum, track)
    if file then ComponentSetValue2(this, "script_inhaled_material", file) end
    if line then ComponentSetValue2(this, "script_throw_item", tostring(line)) end
    if charnum then ComponentSetValue2(this, "script_material_area_checker_failed", tostring(charnum)) end
    if track then ComponentSetValue2(this, "script_material_area_checker_success", tostring(track)) end
    file = file or GetScene()
    dofile_once(file)
    if SCENE and SCENE[line] then
        local behavior = SCENE[line]["behavior"] or "nextline"
        if behavior == "setscene" then
            local thing = SCENE[line]["setscene"]
            file = thing["file"] or file
            line = thing["line"] or line
            charnum = thing["charnum"] or charnum
            track = thing["track"] or track
            noinfiniteloop = noinfiniteloop + 1
            if noinfiniteloop > 99 then
                -- hit an infinite loop probably
                addLines({ text = GameTextGet("$ns_error_loop")})
                nextLine()
            else
                SetScene(file, line, charnum, track)
            end
        else
            addLines(SCENE[line])
            noinfiniteloop = 0
        end
    end
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

local function greyLines()
    -- turn previous lines grey when new lines are added
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local current = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
        for j = 1, #current["texts"] do
            current["texts"][j]["style"] = addToTable(current["texts"][j]["style"], "grey")
        end
        ComponentSetValue2(comps[i], "value_string", smallfolk.dumps(current))
    end
end

local function getColors(input, r, g, b, a)
    r, g, b, a = r or 1, g or 1, b or 1, a or 1
    local color_presets = {
        ["white"]   = function(r2, g2, b2, a2) return 1.0, 1.0, 1.0, 1.0 end,
        ["red"]     = function(r2, g2, b2, a2) return 0.8, 0.0, 0.0, 1.0 end,
        ["blue"]    = function(r2, g2, b2, a2) return 0.0, 0.6, 1.0, 1.0 end,
        ["green"]   = function(r2, g2, b2, a2) return 0.0, 1.0, 0.4, 1.0 end,
        ["stamina"] = function(r2, g2, b2, a2) return 0.1, 0.9, 0.2, 1.0 end,
        ["info"]    = function(r2, g2, b2, a2) return 0.3, 0.6, 0.8, 1.0 end,
        ["grey"]    = function(r2, g2, b2, a2) return r2 - 0.4, g2 - 0.4, b2 - 0.4, a2 end,
        ["shadow"]  = function(r2, g2, b2, a2) return r2 * 0.3, g2 * 0.3, b2 * 0.3, a2 end,
    }
    local grey = false
    input = input or {"white"}
    for i = 1, #input do
        if color_presets[input[i]] then
            r, g, b, a = color_presets[input[i]](r, g, b, a)
            if input[i] == "grey" then
                grey = true
            end
        else
            print("error: no color " .. input[i])
        end
    end

    return
    (r > 1 and 1) or (r < 0 and 0) or r,
    (g > 1 and 1) or (g < 0 and 0) or g,
    (b > 1 and 1) or (b < 0 and 0) or b,
    (a > 1 and 1) or (a < 0 and 0) or a
end

function Frame()
    local _id = 20
    local function id()
        _id = _id + 1
        return _id
    end

    GuiStartFrame(Gui)
    local x, y = 0, 0
    local file, line, charnum, track = GetScene()
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    local keybinds = {
        ["skip"] = InputIsKeyDown(225) or InputIsKeyDown(229),
        ["next"] = InputIsKeyJustDown(40)
    }
    local tick
    -- right shift or left shift to skip line (would be funny to use math.huge instead of 999 but probably bad idea)
    for j = 1, ((keybinds["skip"] and 999) or TICKRATE) do
        tick = true
        LINES = {}
        for i = 1, #comps do
            -- advance the text of only the topmost unfinished line
            local thing = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
            local amount = ComponentGetValue2(comps[i], "value_int")
            if tick and amount < string.len(thing["full"]) then
                if thing["behavior"] == "instant" then
                    amount = string.len(thing["full"])
                else
                    amount = amount + 1
                end
                ComponentSetValue2(comps[i], "value_int", amount)
                tick = false
                GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_select", px, py)
            end
            LINES[#LINES+1] = {["table"] = thing, ["amount"] = amount}
        end
        if tick == true then break end
    end
    GuiBeginScrollContainer(Gui, id(), bx, by, bw, bh, true, 2, 2)
    local choice = {}
    local last = #LINES
    for q = 1, last do
        local text = LINES[q]["table"]["texts"] or {}
        local behavior = LINES[q]["table"]["behavior"] or "nextline"

        if tick and q == last then
            -- go to next line if enter pressed
            if LINES[q]["table"]["choices"] then
                choice = LINES[q]["table"]["choices"] or {}
            elseif behavior == "nextline" or behavior == "auto" then
                if keybinds["next"] or behavior == "auto" then
                    greyLines()
                    nextLine(file, track, line)
                    GamePlaySound("data/audio/Desktop/ui.bank", "ui/streaming_integration/voting_start", px, py)
                else
                    if GameGetFrameNum() % 40 < 20 then
                        text[#text+1] = {text = [[ >]]}
                    end
                end
            end
        end
        -- text
        local i = 1
        local line_len = 0
        local texts = ""
        local f = {}
        local charc = LINES[q]["amount"]
        while i <= #text do
            texts = ""
            local words = text[i]["text"] or ""
            local style = text[i]["style"] or {"white"}
            local hover = text[i]["hover"]
            words = words:gsub("\n ", "\n"):gsub(" ", "!S! ")
            for word in words:gmatch("[^ ]+") do
                word = word:gsub("!S!", " ")
                local cur_len = sizeof(word)
                if line_len + cur_len >= LONGEST_WIDTH or word:find("\n") then
                    x = 0
                    f[#f+1] = {text = texts, style = style, x = x, y = y, hover = hover}

                    y = y + LINE_SPACING
                    line_len = cur_len
                    texts = word:gsub("\n", "")
                    x = line_len
                else
                    line_len = line_len + cur_len
                    texts = texts .. word
                    x = line_len
                end
            end
            f[#f+1] = {text = texts, style = style, x = x - sizeof(texts), y = y, hover = hover}
            x = 0
            i = i + 1
        end
        x = 0
        for j = 1, #f do
            -- Typing animation
            f[j]["text"] = f[j]["text"]:sub(1, charc)
            charc = charc - string.len(f[j]["text"])
            GuiZSet(Gui, 1)

            -- Text display
            local r, g, b, a = getColors(f[j]["style"])
            GuiColorSetForNextWidget(Gui, r, g, b, a)
            GuiText(Gui, f[j]["x"], f[j]["y"], f[j]["text"], TEXT_SIZE)

            -- Hover text
            GuiTooltip(Gui, f[j]["text"], "x: " .. tostring(f[j]["x"]) .. ", y: " .. tostring(f[j]["y"]))
            if f[j]["hover"] then
                GuiTooltip(Gui, f[j]["hover"], "")
            end

            -- Text shadow
            GuiColorSetForNextWidget(Gui, getColors({"shadow"}, r, g, b, a))
            GuiZSet(Gui, 3)
            GuiText(Gui, f[j]["x"] + TEXT_SIZE * SHADOW_OFFSET, f[j]["y"] + TEXT_SIZE * SHADOW_OFFSET, f[j]["text"], TEXT_SIZE)
        end
        y = y + LINE_SPACING
    end

    local addx = LONGEST_WIDTH / 4
    local addy = LONGEST_HEIGHT / 6
    local positions = {
        ["center"]      = {0, 0},
        ["left"]        = {-addx, 0},
        ["right"]       = {addx, 0},
        ["top"]         = {0, addy},
        ["bottom"]      = {0, -addy},
        ["topleft"]     = {-addx, addy},
        ["topright"]    = {addx, addy},
        ["bottomleft"]  = {-addx, -addy},
        ["bottomright"] = {addx, -addy},
    }
    -- GuiImage(Gui, id(), x, y, "data/ui_gfx/1px_white.png", 1, LONGEST_WIDTH, 1)
    local stamina = tonumber(GlobalsGetValue("NS_STAMINA_VALUE", "0"))
    y = y + LINE_SPACING
    for i = 1, #choice do
        local text = "[" .. choice[i]["name"] .. "]"
        local cx = x + addx * 2 + positions[choice[i]["location"] or "center"][1]
        local cy = y - positions[choice[i]["location"] or "center"][2]
        cx = cx - (GuiGetTextDimensions(Gui, text, TEXT_SIZE) / 2) -- center options
        local style = {"blue"}
        local canselect = true
        if choice[i]["staminacost"] then
            if stamina >= choice[i]["staminacost"] then
                style = {"stamina"}
            else
                style = {"red"}
                canselect = false
            end
        end
        GuiZSet(Gui, -12)
        GuiColorSetForNextWidget(Gui, getColors(style))
        -- text button
        local ck, rck = GuiButton(Gui, id(), cx, cy, text, TEXT_SIZE)
        if ck and choice[i]["gototrack"] then
            if canselect then
                SetScene(nil, nil, nil, choice[i]["gototrack"])
                greyLines()
                nextLine(nil, choice[i]["gototrack"], nil)
                if choice[i]["staminacost"] then
                    stamina = stamina - choice[i]["staminacost"]
                    GlobalsSetValue("NS_STAMINA_VALUE", tostring(stamina))
                end
            else
                GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", px, py)
            end
        end
        -- text shadow
        GuiZSet(Gui, -10)
        style[#style+1] = "shadow"
        GuiColorSetForNextWidget(Gui, getColors(style))
        GuiText(Gui, cx + TEXT_SIZE * SHADOW_OFFSET, cy + TEXT_SIZE * SHADOW_OFFSET, text, TEXT_SIZE)
    end
    GuiEndScrollContainer(Gui)
end