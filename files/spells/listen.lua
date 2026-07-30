local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
local enabled = v.text and v.text[1] and true or false

local me = GetUpdatedEntityID()
local c = EntityGetComponentIncludingDisabled(me, "HomingComponent", "listen") or {}
for i = 1, #c do
	EntitySetComponentIsEnabled(me, c[i], enabled)
end