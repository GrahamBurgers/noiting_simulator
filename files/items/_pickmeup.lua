local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit")
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
if (not player) or (not item) then return end

if ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame") == 1 then
	local inv = EntityGetWithName("inventory_quick")
	EntitySetName(inv, "inventory_quick2")
	ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", 0)
end
local x2, y2 = EntityGetTransform(player)
local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
if (EntityGetRootEntity(me) ~= me) then
	if item and ComponentGetValue2(item, "auto_pickup") == true then
		ComponentSetValue2(item, "auto_pickup", false)
		local inv = EntityGetWithName("inventory_quick2")
		if inv and inv > 0 then
			EntitySetName(inv, "inventory_quick")
			ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", 1)
		end
	end
elseif (ComponentGetValue2(item, "auto_pickup") == true) or (distance > 600) then
	ComponentSetValue2(item, "auto_pickup", true)
	EntitySetTransform(me, x2, y2)
	EntityApplyTransform(me, x2, y2)
end