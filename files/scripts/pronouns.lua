--[[
dofile("mods/noiting_simulator/files/scripts/pronouns.lua")
return Pronouns["Kolmisilma"][1]
]]--
local plist = {
    ["he"]   = {"he", "him", "his"},
    ["she"]  = {"she", "her", "hers"},
    ["they"] = {"they", "them", "theirs"},
    ["it"]   = {"it", "it", "its"},
}
local pp = {"he", "she", "they", "it"}
Pronouns = {
    -- MAJOR CHARACTERS (dateable)
    ["Stendari"] = {"he"},
    ["Ukko"] = {"he"},
    ["Stevari"] = {"he"},
    ["Skoude"] = {"he"},
    ["Muodonmuutosmestari"] = {"she"},
    ["Star Child"] = {"it"},
    ["Sun"] = {"she"},
    ["Dark Sun"] = {"he"},
    ["Jattimato"] = {"he"},
    ["Parantajahiisi"] = {"she"},
    ["3 Hamis"] = {"they"},
    ["Kummitus"] = {"it"},
    -- MINOR CHARACTERS
    ["Kolmisilma"] = {"they"},
    ["Patsas"] = {"it"},
    ["Coward"] = {"she"},
    ["Swampling"] = {"they"},
}
SetRandomSeed(31415926, 53589793)
local setting = ModSettingGet("noiting_simulator.pronouns")
for j, i in pairs(Pronouns) do
    if setting == "random" then
        Pronouns[j] = plist[pp[Random(1, #pp)]]
    elseif setting == "dev" then
        Pronouns[j] = plist[i[1]]
    else
        Pronouns[j] = plist[setting]
    end
end