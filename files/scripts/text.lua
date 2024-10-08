local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local child = EntityGetWithName("noiting_sim_handler")
local this = EntityGetFirstComponent(child, "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()
local px, py = EntityGetTransform(EntityGetWithTag("player_unit")[1])
if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

-- todo: these three should be settable by the user
local TEXT_SIZE = 1.5
local MAX_LINES = 100
local TICKRATE = 1
local LINE_SPACING = 15

local screen_x, screen_y = GuiGetScreenDimensions(Gui)
local LONGEST_WIDTH = (screen_x / (TEXT_SIZE * 2))
local LONGEST_HEIGHT = (screen_y / (TEXT_SIZE * 3.5))

local bx, by = (screen_x / 4) - (LONGEST_WIDTH / 2), (screen_y / 2.7) - (LONGEST_HEIGHT / 2)
local bw, bh = LONGEST_WIDTH, LONGEST_HEIGHT

local noinfiniteloop = 0

local function format(text)
    -- trims newlines and extra spaces
    return text:gsub(" \n", "\n"):gsub("\n ", "\n"):gsub("\n", "")
end

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui, format(text), TEXT_SIZE)
    return w
end

function NewLine(text, serialized)
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
        name=format(text),
        value_float=1,
    })
end

---@param input table Should have a text field
local function addLines(input)
    local src = input["text"]
    local serialized = smallfolk.dumps(input)
    local space_size = sizeof(" ")
    local line_len = 0
    local line = ""
    src = src:gsub("    ", ""):gsub("\n", " \n ")
    for word in src:gmatch("[^ ]+") do
        local cur_len = sizeof(word)
        -- auto break if too long
        if (line_len + cur_len >= LONGEST_WIDTH) or word:find("\n") then
            NewLine(line, serialized)
            line_len = cur_len + space_size
            line = word .. " "
        else
            line_len = line_len + cur_len + space_size
            line = line .. word .. " "
        end
    end
    NewLine(line, serialized)
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
        current["style"] = addToTable(current["style"], "grey")
        ComponentSetValue2(comps[i], "value_string", smallfolk.dumps(current))
    end
end

local function getColors(input, r, g, b, a)
    r, g, b, a = r or 1, g or 1, b or 1, a or 1
    local color_presets = {
        ["red"]    = function(r2, g2, b2, a2) return 0.8, 0, 0, 1.0 end,
        ["blue"]   = function(r2, g2, b2, a2) return 0, 0.6, 1.0, 1.0 end,
        ["grey"]   = function(r2, g2, b2, a2) return r2 - 0.4, g2 - 0.4, b2 - 0.4, a2 end,
        ["shadow"] = function(r2, g2, b2, a2) return r2 * 0.3, g2 * 0.3, b2 * 0.3, a2 end,
    }
    for i = 1, #input do
        if color_presets[input[i]] then
            r, g, b, a = color_presets[input[i]](r, g, b, a)
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
            local name = ComponentGetValue2(comps[i], "name")
            local thing = smallfolk.loads(ComponentGetValue2(comps[i], "value_string"))
            local amount = ComponentGetValue2(comps[i], "value_int")
            if tick and amount < string.len(name) then
                amount = amount + 1
                ComponentSetValue2(comps[i], "value_int", amount)
                tick = false
                GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_select", px, py)
            end
            local ticked = name:sub(1, amount)
            LINES[#LINES+1] = {["text"] = ticked, ["table"] = thing}
        end
        if tick == true then break end
    end
    local x, y = 0, 0
    GuiBeginScrollContainer(Gui, id(), bx, by, bw, bh, true, 2, 2)
    local choice = {}
    local last = #LINES
    for q = 1, last do
        local text = LINES[q]["text"] or ""
        local behavior = LINES[q]["table"]["behavior"] or "nextline"
        local style = LINES[q]["table"]["style"] or {}

        if tick and q == last then
            -- go to next line if enter pressed
            if behavior == "nextline" or behavior == "auto" then
                if keybinds["next"] or behavior == "auto" then
                    greyLines()
                    nextLine(file, track, line)
                    GamePlaySound( "data/audio/Desktop/ui.bank", "ui/streaming_integration/voting_start", px, py)
                else
                    if GameGetFrameNum() % 40 < 20 then
                        text = text .. ">"
                    end
                end
            elseif behavior == "choice" then
                choice = LINES[q]["table"]["choices"] or {}
            end
        end
        -- text
        local r, g, b, a = getColors(style)
        GuiColorSetForNextWidget(Gui, r, g, b, a)
        GuiZSet(Gui, 1)
        GuiText(Gui, x, y, text, TEXT_SIZE)
        -- text shadow
        local shadowed = style
        shadowed = addToTable(shadowed, "shadow")
        GuiColorSetForNextWidget(Gui, getColors(shadowed, r, g, b, a))
        GuiZSet(Gui, 2)
        GuiText(Gui, x + TEXT_SIZE * 0.9, y + TEXT_SIZE * 0.9, text, TEXT_SIZE)
        if not style["nolinebreak"] then
            y = y + LINE_SPACING
        end
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
    y = y + (2 * LINE_SPACING)
    for i = 1, #choice do
        local text = "[" .. choice[i]["name"] .. "]"
        local cx = x + addx * 2 + positions[choice[i]["location"] or "center"][1]
        local cy = y - positions[choice[i]["location"] or "center"][2]
        cx = cx - (GuiGetTextDimensions(Gui, text, TEXT_SIZE) / 2) -- center options
        GuiZSet(Gui, -12)
        GuiColorSetForNextWidget(Gui, getColors({"blue"}))
        -- text button
        local ck, rck = GuiButton(Gui, id(), cx, cy, text, TEXT_SIZE)
        if ck and choice[i]["gototrack"] then
            SetScene(nil, nil, nil, choice[i]["gototrack"])
            greyLines()
            nextLine()
        end
        -- text shadow
        GuiZSet(Gui, -10)
        GuiColorSetForNextWidget(Gui, getColors({"blue", "shadow"}))
        GuiText(Gui, cx + TEXT_SIZE * 0.9, cy + TEXT_SIZE * 0.9, text, TEXT_SIZE)
    end
    GuiEndScrollContainer(Gui)
end