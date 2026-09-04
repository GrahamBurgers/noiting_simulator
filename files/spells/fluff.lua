local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local shooter = proj and ComponentGetValue2(proj, "mWhoShot")
if not (proj and vel and shooter and EntityGetIsAlive(shooter)) then return end

local vx, vy = ComponentGetValue2(vel, "mVelocity")
local magnitude = math.sqrt(vx^2 + vy^2)
if ComponentGetValue2(this, "mTimesExecuted") == 0 then
	if vx > 0 then
		ComponentSetValue2(proj, "angular_velocity", -ComponentGetValue2(proj, "angular_velocity"))
	end
end

local distance = 4 + (magnitude / 50)

local x, y = EntityGetTransform(me)
local x2, y2 = EntityGetTransform(shooter)
local direction = math.pi - math.atan2(vy, vx)
local theta = (math.deg(direction) * math.pi / 180)
theta = theta + ComponentGetValue2(proj, "angular_velocity")

local target_x = x2 + -math.cos(theta) * distance
local target_y = y2 + math.sin(theta) * distance

x = x + (target_x - x) / 6
y = y + (target_y - y) / 6

EntitySetTransform(me, x, y)
ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)

if ComponentGetValue2(this, "mTimesExecuted") == 0 then EntityAddChild(shooter, me) end