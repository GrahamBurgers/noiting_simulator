local me = GetUpdatedEntityID()

local last_damage_frame = tonumber(GlobalsGetValue("LAST_DAMAGE_TAKEN_FRAME"))
local retorts = EntityGetWithTag("retort")
if me ~= retorts[1] then return end