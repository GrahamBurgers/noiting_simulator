local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local target = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local x2, y2 = EntityGetTransform(target)
if math.sqrt((x2 - x)^2 + (y2 - y)^2) > 6 then
	EntityRemoveComponent(me, this)
end