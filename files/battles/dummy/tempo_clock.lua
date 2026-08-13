local tempo = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = storage and smallfolk.loads(storage)
if storage and storage ~= "" and v and v.name == "dummy" then
	v.tempolevel = tempo
	GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
end