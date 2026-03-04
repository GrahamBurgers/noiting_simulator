local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetClosestWithTag(x, y, "player_unit")
if (not player) then return end

local x2, y2 = EntityGetTransform(player)
if not (x2 and y2) then return end
local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
if (distance > 400) then
	EntitySetTransform(me, x2, y2)
	EntityApplyTransform(me, x2, y2)
end