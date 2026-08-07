local me = GetUpdatedEntityID()
local root = EntityGetRootEntity(me)

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
if not v then return end

local inv2comp = EntityGetFirstComponentIncludingDisabled(root, "Inventory2Component")
local activeitem = inv2comp and ComponentGetValue2(inv2comp, "mActiveItem")
local hotspot = activeitem and activeitem > 0 and EntityGetFirstComponentIncludingDisabled(activeitem, "HotspotComponent")
if hotspot then
	local wx, wy, rot = EntityGetTransform(activeitem)
	rot = rot + math.pi

	local ox, oy = ComponentGetValue2(hotspot, "offset")
	local vx, vy = math.cos(rot) * ox, math.sin(rot) * ox
	wx = wx - vx
	wy = wy - vy

	wx = v.arena_x + (v.arena_x - wx)
	wy = v.arena_y + (v.arena_y - wy)

	local speed = 0
	while speed <= 5 do
		GameCreateCosmeticParticle("ice_acid_static", wx, wy, 8, vx * speed, vy * speed, 0, 0.02, 0.06, true, true, false, false, 0, 0)
		speed = speed + 1
	end
end