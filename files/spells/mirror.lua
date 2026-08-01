local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
if (not v) then return end

x = v.arena_x + (v.arena_x - x)
y = v.arena_y + (v.arena_y - y)

EntitySetTransform(me, x, y)

local spread_deg = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "spread_nonrandom_degrees")
if not spread_deg then
	spread_deg = EntityAddComponent2(me, "VariableStorageComponent", {
		_tags="spread_nonrandom_degrees",
		value_int=0,
	})
end
ComponentSetValue2(spread_deg, "value_int", ComponentGetValue2(spread_deg, "value_int") + 180)