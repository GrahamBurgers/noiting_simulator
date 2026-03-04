local me = GetUpdatedEntityID()
dofile_once("mods/noiting_simulator/files/items/_list.lua")
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local items = smallfolk.loads(GlobalsGetValue("NS_ITEMS", "{}")) or {}
local x, y = EntityGetTransform(me)
local spacing = 22
x = x + (spacing / -2) * (#items - 1)
for i = 1, #items do
	SpawnItem(items[i], x, y)
	x = x + spacing
end
GlobalsSetValue("NS_ITEMS", smallfolk.dumps({}))
EntityKill(me)