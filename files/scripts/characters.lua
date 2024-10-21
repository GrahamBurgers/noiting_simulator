--[[
Pronouns table is auto populated with the correct pronouns for each character
note that this is case sensitive (e.g. They vs they)

dofile("mods/noiting_simulator/files/scripts/characters.lua")
return Pronouns["Kolmisilma"][Him]
]]--
Name = string.lower(tostring(ModSettingGet("noiting_simulator.name")) or "")
Name_caps = Name:sub(1, 1):upper() .. Name:sub(2)
Pronouns = {
    -- MAJOR CHARACTERS (dateable)
    ["Stendari"] = {"he"},
    ["Ukko"] = {"he"},
    ["Stevari"] = {"he"},
    ["Kranuhiisi"] = {"he"},
    ["Polymage"] = {"she"},
    ["Sunseed"] = {"it"},
    ["Sun"] = {"she"},
    ["Dark Sun"] = {"he"},
    ["Jattimato"] = {"he"},
    ["Parantajahiisi"] = {"she"},
    ["3 Hamis"] = {"they"},
    ["Kummitus"] = {"it"},
    ["Kolmi"] = {"they"},
    ["Squidward"] = {"they"},
    ["Mecha"] = {"they"},
    ["Master"] = {"they"},
    ["Deer"] = {"it"},
    ["Leviathan"] = {"it"},
    -- MINOR CHARACTERS (not dateable)
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
SetRandomSeed(31415926, 53589793)
local plist = {
    ["he"]   = {["they"] = "he",    ["them"] = "him",  ["theirs"] = "his",    ["their"] = "his",
                ["They"] = "He",    ["Them"] = "Him",  ["Theirs"] = "His",    ["Their"] = "His",},
    ["she"]  = {["they"] = "she",   ["them"] = "her",  ["theirs"] = "hers",   ["their"] = "her",
                ["They"] = "She",   ["Them"] = "Her",  ["Theirs"] = "Hers",   ["Their"] = "Her"},
    ["they"] = {["they"] = "they",  ["them"] = "them", ["theirs"] = "theirs", ["their"] = "their",
                ["They"] = "They",  ["Them"] = "Them", ["Theirs"] = "Theirs", ["Their"] = "Their"},
    ["it"]   = {["they"] = "it",    ["them"] = "it",   ["theirs"] = "its",    ["their"] = "its",
                ["They"] = "It",    ["Them"] = "It",   ["Theirs"] = "Its",    ["Their"] = "Its",},
}
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

local function addPronouns(what)

end