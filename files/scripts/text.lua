local LONGEST_WIDTH = 140
local TEXT_SIZE = 1.5
CURRENT = ""
LINES = LINES or {}
LINES_REAL = LINES_REAL or {}
local this = EntityGetFirstComponent(GameGetWorldStateEntity(), "LuaComponent", "noiting_simulator") or GetUpdatedComponentID()

if Gui then GuiDestroy(Gui) end
Gui = GuiCreate()

---@param text string
---@return number
local function sizeof(text)
    local w = GuiGetTextDimensions(Gui, text, TEXT_SIZE)
    return w
end

---@param src string
function AddLines(src)
    local space_size = sizeof(" ")
    local line_len = 0
    local line = ""
    local nextnewline = false
    for word in src:gmatch("[^ ]+") do
        local cur_len = sizeof(word)
        if line_len + cur_len >= LONGEST_WIDTH or nextnewline then
            nextnewline = false
            table.insert(LINES_REAL, line)
            table.insert(LINES, "")
            if word:find("\n") then
                word = word:gsub("\n", "")
                nextnewline = true
            end
            line_len = cur_len + space_size
            line = word .. " "
        else
            line_len = line_len + cur_len + space_size
            line = line .. word .. " "
        end
    end
    table.insert(LINES_REAL, line)
    table.insert(LINES, "")
end

function SetScene(file, line)
    file = file or ComponentGetValue2(this, "script_inhaled_material")
    line = line or tonumber(ComponentGetValue2(this, "script_throw_item")) or 1
    dofile(file)
    ComponentSetValue2(this, "script_inhaled_material", file)
    ComponentSetValue2(this, "script_throw_item", line)
    AddLines(SCENE[line])
    Next()
end

function Advance()
    local thisline = tonumber(ComponentGetValue2(this, "script_throw_item") or "0")
    SetScene(nil, thisline + 1)
end

function Next()
    GuiStartFrame(Gui)
    local x, y = 100, 100
    local go = true
    for i = 1, #LINES_REAL do
        if i > 40 then
            table.remove(LINES_REAL, 1)
            table.remove(LINES_REAL, 1)
        else
            local length = string.len(LINES[i])
            if length < string.len(LINES_REAL[i]) and go then
                local char = LINES_REAL[i]:sub(length + 1, length + 1)
                LINES[i] = LINES[i] .. char
                go = false
            end
            GuiText(Gui, x, y, LINES[i], TEXT_SIZE)
            y = y + 15
        end
    end
    return go
end