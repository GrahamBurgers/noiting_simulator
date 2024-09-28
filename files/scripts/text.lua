---@diagnostic disable: undefined-global
local LONGEST_WIDTH = 300
local TEXT_SIZE = 1.5
local MAX_LINES = 20
local TICKRATE = 1
local child = EntityGetWithName("noiting_sim_handler")
local this = EntityGetFirstComponent(child, "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()
local px, py = EntityGetTransform(EntityGetWithTag("player_unit")[1])

if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui, text:gsub("\n", ""), TEXT_SIZE)
    return w
end

function NewLine(text)
    -- remove lines that are too old
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}
    for i = 1, #comps do
        local age = ComponentGetValue2(comps[i], "value_int")
        ComponentSetValue2(comps[i], "value_int", age + 1)
        if age > MAX_LINES then
            EntityRemoveComponent(child, comps[1])
        end
    end
    -- remove spaces at the start of strings (todo: this shouldn't be necessary)
    EntityAddComponent2(child, "VariableStorageComponent", {
        _tags="noiting_sim_line",
        value_string="",
        name=text:gsub("^%s+", ""),
        value_int=1,
        value_float=1,
    })
end

---@param src string
local function addLines(src)
    local space_size = sizeof(" ")
    local line_len = 0
    local line = ""
    local newlinetable = {}
    local i = 0
    -- support newline characters
    -- todo: slightly jank
    src = src:gsub("\n", " \n") -- add in some to split words
    for word in src:gmatch("[^ ]+") do
        i = i + 1
        local count = 0
        local cur_len = sizeof(word)
        if word:find("\n") then
            word, count = word:gsub("\n", "")
        end
        newlinetable[#newlinetable+1] = count
        local herecount = newlinetable[i] or 0
        for j = 1, herecount do
            NewLine("")
            cur_len = 0
        end
        -- auto break if too long
        if (line_len + cur_len >= LONGEST_WIDTH) or herecount > 0 then
            NewLine(line)
            line_len = cur_len + space_size
            line = word .. " "
        else
            line_len = line_len + cur_len + space_size
            line = line .. word .. " "
        end
    end
    NewLine(line)
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
        addLines(SCENE[line]["text"])
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
        ComponentSetValue2(comps[i], "value_float", 0.6)
    end
end

function Frame()
    GuiStartFrame(Gui)
    local file, line, charnum, track = GetScene()
    local comps = EntityGetComponent(child, "VariableStorageComponent", "noiting_sim_line") or {}

    local tick
    -- right shift or left shift to skip line (would be funny to use math.huge instead of 999 but probably bad idea)
    for j = 1, ((InputIsKeyDown(225) or InputIsKeyDown(229)) and 999) or TICKRATE do
        tick = true
        LINES = {}
        for i = 1, #comps do
            -- advance the text of only the topmost unfinished line
            local name = ComponentGetValue2(comps[i], "name")
            local thing = ComponentGetValue2(comps[i], "value_string")
            local grey = ComponentGetValue2(comps[i], "value_float")
            local ticked = thing
            if tick and string.len(thing) < string.len(name) then
                ticked = thing .. name:sub(string.len(thing) + 1, string.len(thing) + 1)
                ComponentSetValue2(comps[i], "value_string", ticked)
                tick = false
                GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_select", px, py)
            end
            LINES[#LINES+1] = {["text"] = ticked, ["grey"] = grey}
        end
        if tick == true then break end
    end
    local x, y = 100, 40
    for q = 1, #LINES do
        local text = LINES[q]["text"]
        local behavior = LINES[q]["behavior"] or "nextline"
        if tick then
            if q == 1 then
                -- go to next line if enter pressed
                if behavior == "nextline" and InputIsKeyJustDown(40) then
                    greyLines()
                    nextLine(file, track, line)
                    GamePlaySound( "data/audio/Desktop/ui.bank", "ui/streaming_integration/voting_start", px, py)
                end
            elseif q == #LINES then
                if GameGetFrameNum() % 40 < 20 then
                    text = text .. ">"
                end
            end
        end
        -- text
        GuiColorSetForNextWidget(Gui, LINES[q]["grey"], LINES[q]["grey"], LINES[q]["grey"], 1)
        GuiZSet(Gui, 4)
        GuiText(Gui, x, y, text, TEXT_SIZE)
        -- text shadow
        GuiColorSetForNextWidget(Gui, 0.2, 0.2, 0.2, 1)
        GuiZSet(Gui, 5)
        GuiText(Gui, x + TEXT_SIZE * 0.9, y + TEXT_SIZE * 0.9, text, TEXT_SIZE)
        y = y + 15
    end
end