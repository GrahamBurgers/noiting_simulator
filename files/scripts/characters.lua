--[[
Pronouns table is auto populated with the correct pronouns for each character
note that this is case sensitive (e.g. They vs they)

dofile("mods/noiting_simulator/files/scripts/characters.lua")
return Pronouns["Kolmisilma"]["Him"]
]]--
Name = string.lower(tostring(ModSettingGet("noiting_simulator.name")) or "")
Name_caps = Name:sub(1, 1):upper() .. Name:sub(2)
Pronouns = {
    -- MAJOR CHARACTERS (dateable)
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
    ["he"]   = {["they"] = "he",    ["them"] = "him",  ["theirs"] = "his",    ["their"] = "his",   ["they're"] = "he's",    ["themself"] = "himself",   ["they've"] = "he's",
                ["They"] = "He",    ["Them"] = "Him",  ["Theirs"] = "His",    ["Their"] = "His",   ["They're"] = "He's",    ["Themself"] = "Himself",   ["They've"] = "He's",},
    ["she"]  = {["they"] = "she",   ["them"] = "her",  ["theirs"] = "hers",   ["their"] = "her",   ["they're"] = "she's",   ["themself"] = "herself",   ["they've"] = "she's",
                ["They"] = "She",   ["Them"] = "Her",  ["Theirs"] = "Hers",   ["Their"] = "Her",   ["They're"] = "She's",   ["Themself"] = "Herself",   ["They've"] = "She's",},
    ["they"] = {["they"] = "they",  ["them"] = "them", ["theirs"] = "theirs", ["their"] = "their", ["they're"] = "they're", ["themself"] = "themself",  ["they've"] = "they've",
                ["They"] = "They",  ["Them"] = "Them", ["Theirs"] = "Theirs", ["Their"] = "Their", ["They're"] = "They're", ["Themself"] = "Themself",  ["They've"] = "They've",},
    ["it"]   = {["they"] = "it",    ["them"] = "it",   ["theirs"] = "its",    ["their"] = "its",   ["they're"] = "it's",    ["themself"] = "itself",    ["they've"] = "it's",
                ["They"] = "It",    ["Them"] = "It",   ["Theirs"] = "Its",    ["Their"] = "Its",   ["They're"] = "It's",    ["Themself"] = "Itself",    ["They've"] = "It's",},
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