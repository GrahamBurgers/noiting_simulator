local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local frame = GameGetFrameNum()
if ComponentGetValue2(this, "mTimesExecuted") == 0 then
	local str = "castcute" .. tostring(frame)
	EntityAddTag(me, str)
	ComponentSetValue2(this, "script_material_area_checker_success", str)
else
	local tag = ComponentGetValue2(this, "script_material_area_checker_success")
	local radius = 16
	local entities = EntityGetInRadiusWithTag(x, y, radius, tag)
	for i = 1, #entities do
		local vel2 = EntityGetFirstComponent(entities[i], "VelocityComponent")
		local x2, y2 = EntityGetTransform(entities[i])
    	local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
		if entities[i] ~= me and vel2 and distance > 2 then
			local direction = math.pi - math.atan2((y2 - y), (x2 - x))
			local force = -0.5
			local final = force

			EntitySetTransform(entities[i], x2 + final * -math.cos(direction), y2 + final * math.sin(direction))

			local vx, vy = ComponentGetValue2(vel2, "mVelocity")
			vx = vx + final * -math.cos(direction)
			vy = vy + final * math.sin(direction)
			ComponentSetValue2(vel2, "mVelocity", vx, vy)
		end
	end
end