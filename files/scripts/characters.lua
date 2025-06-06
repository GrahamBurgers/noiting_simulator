--[[
Pronouns table is auto populated with the correct pronouns for each character
note that this is case sensitive (e.g. They vs they)

dofile("mods/noiting_simulator/files/scripts/characters.lua")
return Pronouns["Kolmi"]["Him"]
]]--
local function caps(str)
    return str:sub(1, 1):upper() .. str:sub(2)
end
Name = string.lower(tostring(ModSettingGet("noiting_simulator.name")) or "")
Name_caps = caps(Name)
dofile_once("mods/noiting_simulator/settings.lua") -- ok i don't like putting the characters list in settings but it works
CHARACTERS = CHARACTERS or {}
Pronouns = {}
Name = {}

function Swap(character, type)
    local types = {
        -- stupid or genius?
        ["plural"] = function()
            if character["they"] == "they" then return true else return false end
        end,
        ["sibling"] = function()
            if character["they"] == "she" then return "sister"
            elseif character["they"] == "he" then return "brother"
            else return "sibling" end
        end,
        ["Sibling"] = function()
            if character["They"] == "She" then return "Sister"
            elseif character["They"] == "He" then return "Brother"
            else return "Sibling" end
        end,
        ["parent"] = function()
            if character["they"] == "she" then return "mother"
            elseif character["they"] == "he" then return "father"
            else return "parent" end
        end,
        ["Parent"] = function()
            if character["They"] == "She" then return "Mother"
            elseif character["They"] == "He" then return "Father"
            else return "Parent" end
        end,
    }
    if types[type] then return types[type] end
end
---@param name string
---@param max number
---@return number
function Geterate(name, max)
    -- get + iterate (for finding out how many times a scene has run)
    if name and max then
        local thing = tonumber(GlobalsGetValue("NS_GETERATE_" .. name, "0") or "0") or 0
        thing = math.min(thing + 1, max)
        GlobalsSetValue("NS_GETERATE_" .. name, tostring(thing))
        return thing
    end
    return 0
end
local plist = {
    ["He/Him"]    = {["they"] = "he",    ["them"] = "him",  ["theirs"] = "his",    ["their"] = "his",   ["they're"] = "he's",    ["themself"] = "himself",   ["they've"] = "he's",},
    ["She/Her"]   = {["they"] = "she",   ["them"] = "her",  ["theirs"] = "hers",   ["their"] = "her",   ["they're"] = "she's",   ["themself"] = "herself",   ["they've"] = "she's",},
    ["They/Them"] = {["they"] = "they",  ["them"] = "them", ["theirs"] = "theirs", ["their"] = "their", ["they're"] = "they're", ["themself"] = "themself",  ["they've"] = "they've",},
    ["It/Its"]    = {["they"] = "it",    ["them"] = "it",   ["theirs"] = "its",    ["their"] = "its",   ["they're"] = "it's",    ["themself"] = "itself",    ["they've"] = "it's",},
}
-- generate caps versions of pronouns
local new = {}
for q, r in pairs(plist) do
    local n = {}
    for i, j in pairs(r) do
        n[i] = j
        n[caps(i)] = caps(j)
    end
    new[q] = n
end
plist = new
local pp = {}
for j, i in pairs(plist) do
    pp[#pp+1] = j
end
for i = 1, #CHARACTERS do
    local thing = ModSettingGet("noiting_simulator.p_" .. CHARACTERS[i].id) or CHARACTERS[i].default
    Pronouns[CHARACTERS[i].id] = plist[thing]
    -- nicknames
    Name[CHARACTERS[i].id] = ModSettingGet("noiting_simulator.nick_" .. CHARACTERS[i].id) or CHARACTERS[i].name or CHARACTERS[i].id
end