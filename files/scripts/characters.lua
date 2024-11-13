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
Pronouns = {
    -- MAJOR CHARACTERS
    ["Kolmi"] = {"they"},
    ["Stendari"] = {"he"},
    ["Ukko"] = {"he"},
    ["Stevari"] = {"he"},
    ["Snipuhiisi"] = {"he"},
    ["Polymage"] = {"she"},
    ["Sunseed"] = {"it"},
    ["Sun"] = {"she"},
    ["Dark Sun"] = {"he"},
    ["Jattimato"] = {"he"},
    ["Parantajahiisi"] = {"she"},
    ["3 Hamis"] = {"they"},
    ["Kummitus"] = {"it"},
    ["Squidward"] = {"they"},
    ["Mecha"] = {"they"},
    ["Master"] = {"they"},
    ["Deer"] = {"it"},
    ["Leviathan"] = {"it"},
    -- MINOR CHARACTERS
    ["Kivi"] = {"it"},
    ["Skoude"] = {"he"},
    ["Patsas"] = {"it"},
    ["Coward"] = {"she"},
    ["Swampling"] = {"they"},
    ["Friend"] = {"they"},
    ["Alchemist"] = {"they"},
    ["Dragon"] = {"they"},
    ["Tiny"] = {"they"},
    ["Cabbage"] = {"they"},
    ["Meat"] = {"it"},
    ["Forgotten"] = {"they"},
}

function Plural(pronoun, yes, no)
    if pronoun == "they" or pronoun == "They" then return yes
    else return no end
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
SetRandomSeed(31415926, 53589793)
local plist = {
    ["he"]   = {["they"] = "he",    ["them"] = "him",  ["theirs"] = "his",    ["their"] = "his",   ["they're"] = "he's",    ["themself"] = "himself",   ["they've"] = "he's",},
    ["she"]  = {["they"] = "she",   ["them"] = "her",  ["theirs"] = "hers",   ["their"] = "her",   ["they're"] = "she's",   ["themself"] = "herself",   ["they've"] = "she's",},
    ["they"] = {["they"] = "they",  ["them"] = "them", ["theirs"] = "theirs", ["their"] = "their", ["they're"] = "they're", ["themself"] = "themself",  ["they've"] = "they've",},
    ["it"]   = {["they"] = "it",    ["them"] = "it",   ["theirs"] = "its",    ["their"] = "its",   ["they're"] = "it's",    ["themself"] = "itself",    ["they've"] = "it's",},
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
local setting = ModSettingGet("noiting_simulator.pronouns")
local pp = {}
for j, i in pairs(plist) do
    pp[#pp+1] = j
end
for j, i in pairs(Pronouns) do
    if setting == "random" then
        Pronouns[j] = plist[pp[Random(1, #pp)]]
    elseif setting == "dev" then
        Pronouns[j] = plist[i[1]]
    else
        Pronouns[j] = plist[setting]
    end
end