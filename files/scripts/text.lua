---@diagnostic disable: undefined-global
local child = EntityGetWithName("noiting_sim_handler")
local this = EntityGetFirstComponent(child, "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()
local px, py = EntityGetTransform(EntityGetWithTag("player_unit")[1])
local auto = false
if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

-- todo: these three should be settable by the user
local TEXT_SIZE = 1.5
local MAX_LINES = 100
local TICKRATE = 1

local screen_x, screen_y = GuiGetScreenDimensions(Gui)
local LONGEST_WIDTH = (screen_x / (TEXT_SIZE * 2))
local LONGEST_HEIGHT = (screen_y / (TEXT_SIZE * 3.5))

local bx, by = (screen_x / 4) - (LONGEST_WIDTH / 2), (screen_y / 2.7) - (LONGEST_HEIGHT / 2)
local bw, bh = LONGEST_WIDTH, LONGEST_HEIGHT

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

function NewLine(text, style)
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
        value_string=style,
        name=format(text),
        value_float=1,
    })
end

---@param src string
local function addLines(src, style)
    local space_size = sizeof(" ")
    local line_len = 0
    local line = ""
    src = src:gsub("    ", ""):gsub("\n", " \n ")
    for word in src:gmatch("[^ ]+") do
        local cur_len = sizeof(word)
        -- auto break if too long
        if (line_len + cur_len >= LONGEST_WIDTH) or word:find("\n") then
            NewLine(line, style)
            line_len = cur_len + space_size
            line = word .. " "
        else
            line_len = line_len + cur_len + space_size
            line = line .. word .. " "
        end
    end
    NewLine(line, style)
    if style:find("auto,") then
        auto = true
    end
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
    if SCENE and SCENE[line] and SCENE[line]["text"] then
        addLines(SCENE[line]["text"], SCENE[line]["style"] or "")
    end
end

local function nextLine(scene, track, start)
    -- default function for most lines
    dofile_once(scene)
    start = (start or 1) + 1
    track = track or 1
    while start <= #SCENE do
        if SCENE[start]["track"] == track then
            SetScene(nil, start, 1, nil)
            break
        end
        start = start + 1
    end
end

local function greyLines()
    -- turn previous lines grey when new lines are added
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local current = ComponentGetValue2(comps[i], "value_string")
        if not current:find("grey") then
            current = current .. "grey,"
        end
        ComponentSetValue2(comps[i], "value_string", current:gsub("auto,", ""))
    end
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
            local thing = ComponentGetValue2(comps[i], "value_string")
            local amount = ComponentGetValue2(comps[i], "value_int")
            if tick and amount < string.len(name) then
                amount = amount + 1
                ComponentSetValue2(comps[i], "value_int", amount)
                tick = false
                GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_select", px, py)
            end
            local ticked = name:sub(1, amount)
            LINES[#LINES+1] = {["text"] = ticked, ["style"] = thing}
        end
        if tick == true then break end
    end
    local x, y = 0, 0
    GuiBeginScrollContainer(Gui, id(), bx, by, bw, bh, true, 2, 2)
    local choices = {}
    for q = 1, #LINES do
        local text = LINES[q]["text"] or ""
        local behavior = LINES[q]["behavior"] or "nextline"
        local style = LINES[q]["style"] or ""

        if tick then
            if q == 1 then
                GamePrint(behavior)
                -- go to next line if enter pressed
                if behavior == "nextline" and (keybinds["next"] or auto) then
                    auto = false
                    greyLines()
                    nextLine(file, track, line)
                    GamePlaySound( "data/audio/Desktop/ui.bank", "ui/streaming_integration/voting_start", px, py)
                end
                if behavior == "choice" then
                    choices = LINES[q]["choices"] or {}
                end
            elseif q == #LINES then
                if GameGetFrameNum() % 40 < 20 then
                    text = text .. ">"
                end
            end
        end
        -- text
        local color = {["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1}
        if style:find("blue,") then
            color["r"] = 0.0
            color["g"] = 0.4
            color["b"] = 1.0
        end
        if style:find("grey,") then
            color["r"] = color["r"] - 0.4
            color["g"] = color["g"] - 0.4
            color["b"] = color["b"] - 0.4
        end
        local function cap(num, low, high)
            return math.max(math.min(num, high), low)
        end
        color["r"] = cap(color["r"], 0, 1)
        color["g"] = cap(color["g"], 0, 1)
        color["b"] = cap(color["b"], 0, 1)
        color["a"] = cap(color["a"], 0, 1)
        GuiColorSetForNextWidget(Gui, color["r"], color["g"], color["b"], color["a"])
        GuiZSet(Gui, 1)
        GuiText(Gui, x, y, text, TEXT_SIZE)
        -- text shadow
        GuiColorSetForNextWidget(Gui, color["r"] * 0.2, color["g"] * 0.2, color["b"] * 0.2, color["a"])
        GuiZSet(Gui, 2)
        GuiText(Gui, x + TEXT_SIZE * 0.9, y + TEXT_SIZE * 0.9, text, TEXT_SIZE)
        if not style:find("nolinebreak,") then
            y = y + 15
        end
    end
    GuiEndScrollContainer(Gui)
    local positions = {
        ["middle"]        = {bx, by},
        ["left"]          = {bx - (screen_x / 8), by},
        ["right"]         = {bx + (screen_x / 8), by},
        ["up"]            = {bx, by + (screen_y / 8)},
        ["down"]          = {bx, by - (screen_y / 8)},
        ["top_left"]      = {bx - (screen_x / 8), by},
        ["top_right"]     = {bx - (screen_x / 8), by},
        ["bottom_left"]   = {bx - (screen_x / 8), by},
        ["bottom_right"]  = {bx - (screen_x / 8), by},
    }
    for i = 1, #choices do
        local ck, rck = GuiButton(Gui, id(), positions[choices[i]["location"]][1], positions[choices[i]["location"]][2], choices[i]["name"])
        if ck and choices[i]["function"] then
            choices[i]["function"]()
        end
    end
end