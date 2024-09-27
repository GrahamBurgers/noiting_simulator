local LONGEST_WIDTH = 300
local TEXT_SIZE = 1.5
MAX_LINES = 10
local this = EntityGetFirstComponent(GameGetWorldStateEntity(), "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()

if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui, text, TEXT_SIZE)
    return w
end

function NewLine(text)
    local world = GameGetWorldStateEntity()
    local number = #(EntityGetComponent(world, "VariableStorageComponent", "noiting_sim_line") or {}) or 0
    EntityAddComponent2(world, "VariableStorageComponent", {
        _tags="noiting_sim_line",
        value_string="",
        name=text,
        value_int=number,
    })
    if number > MAX_LINES then
        -- remove the oldest line when over cap
        local comps = EntityGetComponent(world, "VariableStorageComponent", "noiting_sim_line") or {}
        for i = 1, #comps do
            ComponentSetValue2(comps[i], "value_int", ComponentGetValue2(comps[i], "value_int") - 1)
        end
        EntityRemoveComponent(world, comps[1])
    end
end

---@param src string
function AddLines(src)
    local space_size = sizeof(" ")
    local line_len = 0
    local line = ""
    local newlinetable = {}
    local i = 0
    -- support newline characters
    -- todo: slightly jank
    src = src:gsub("\n", " \n")
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
local function GetScene()
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
        AddLines(SCENE[line]["text"])
    end
end

local function NextLine(scene, track, start)
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

function Frame()
    GuiStartFrame(Gui)
    local file, line, charnum, track = GetScene()

    local LINES = {}
    local comps = EntityGetComponent(GameGetWorldStateEntity(), "VariableStorageComponent", "noiting_sim_line") or {}
    local tick = true
    for i = 1, #comps do
        -- advance the text of only the topmost unfinished line
        local name = ComponentGetValue2(comps[i], "name")
        local thing = ComponentGetValue2(comps[i], "value_string")
        local ticked = thing
        if tick and string.len(thing) < string.len(name) then
            ticked = thing .. name:sub(string.len(thing) + 1, string.len(thing) + 1)
            ComponentSetValue2(comps[i], "value_string", ticked)
            tick = false
        end
        LINES[#LINES+1] = ticked
    end
    local x, y = 100, 100
    for i = 1, #LINES do
        local text = LINES[i]
        if tick then
            if i == 1 then
                -- go to next line if enter pressed
                -- todo: special functionality here
                if InputIsKeyJustDown(40) then
                    NextLine(file, track, line)
                end
            elseif i == #LINES then
                if GameGetFrameNum() % 40 < 20 then
                    text = text .. ">"
                end
            end
        end
        GuiText(Gui, x, y, text, TEXT_SIZE)
        y = y + 15
    end
end