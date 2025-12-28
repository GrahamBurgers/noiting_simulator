local me = GetUpdatedEntityID()
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if not vel then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local direction = math.pi - math.atan2(vy, vx)
local magnitude = math.sqrt(vx^2 + vy^2)

local var = EntityGetFirstComponent(me, "VariableStorageComponent", "one_liner_direction")
local dir = var and ComponentGetValue2(var, "value_float")

local time = 20
local correction_frames = 4
local theta = (math.deg(direction) * math.pi / 180)
local tick = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") or 0
local add = 0.18
if tick < time / correction_frames then
	add = add / (time / correction_frames)
elseif tick % time < (time / 2) then
	add = -add
end

if var and dir ~= 999999 then
	add = add / 5
	ComponentSetValue2(var, "value_float", dir + add)
end
ComponentSetValue2(vel, "mVelocity", -math.cos(theta + add) * magnitude, math.sin(theta + add) * magnitude)