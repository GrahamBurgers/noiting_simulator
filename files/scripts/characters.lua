--[[
dofile("mods/noiting_simulator/files/scripts/pronouns.lua")
return Pronouns["Kolmisilma"][1]
]]--
Pronouns = {
    -- MAJOR CHARACTERS (dateable)
    ["Stendari"] = {"he"},
    ["Ukko"] = {"he"},
    ["Stevari"] = {"he"},
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
    ["Kivi"] = {"it"},
    -- MINOR CHARACTERS (not dateable)
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
SetRandomSeed(31415926, 53589793)
local plist = {
    ["he"]   = {"he", "him", "his"},
    ["she"]  = {"she", "her", "hers"},
    ["they"] = {"they", "them", "theirs"},
    ["it"]   = {"it", "it", "its"},
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