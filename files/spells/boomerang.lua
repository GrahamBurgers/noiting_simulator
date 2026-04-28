local me = GetUpdatedEntityID()
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local shooter = proj and ComponentGetValue2(proj, "mWhoShot")
if not (proj and vel and shooter) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local magnitude = math.sqrt(vx^2 + vy^2)
if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") == 0 then
	if vx < 0 then
		ComponentSetValue2(proj, "angular_velocity", -ComponentGetValue2(proj, "angular_velocity"))
	end
	ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", magnitude)
else
	magnitude = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
end
local x, y = EntityGetTransform(me)
local x2, y2 = EntityGetTransform(shooter)
y2 = y2 - 4

local power = (2 * magnitude) / ComponentGetValue2(proj, "mStartingLifetime")
local direction = math.pi - math.atan2((y2 - y), (x2 - x))
vx = vx + (0 - math.cos( direction ) * power)
vy = vy + (math.sin( direction ) * power)

ComponentSetValue2(vel, "mVelocity", vx, vy)