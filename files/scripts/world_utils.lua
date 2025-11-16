--[[
return P("Parantajahiisi", {she = "She does something", he = "He does something", they = "They do something", it = "It does something"}
]]--
dofile_once("mods/noiting_simulator/settings.lua") -- ok i don't like putting the characters list in settings but it works
if (RELOAD or 0) ~= ModSettingGet("noiting_simulator.RELOAD") or 0 then
    dofile("mods/noiting_simulator/settings.lua")
    RELOAD = ModSettingGet("noiting_simulator.RELOAD")
end

CHARACTERS = CHARACTERS or {}

function P(character, type)
    for i = 1, #CHARACTERS do
        if character == CHARACTERS[i].id then
            local re = ModSettingGet("noiting_simulator.p_" .. CHARACTERS[i].id) or CHARACTERS[i].default
            for j = 1, 2 do
                if re == "He/Him" or re == "he" then re = type.he end
                if re == "She/Her" or re == "she" then re = type.she end
                if re == "They/Them" or re == "they" then re = type.they end
                if re == "It/Its" or re == "it" then re = type.it end
            end
            return re
        end
    end
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