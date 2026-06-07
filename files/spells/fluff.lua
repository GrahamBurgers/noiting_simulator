local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local shooter = proj and ComponentGetValue2(proj, "mWhoShot")
if not (proj and vel and shooter and EntityGetIsAlive(shooter)) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local x, y, dir = EntityGetTransform(me)
local x2, y2 = EntityGetTransform(shooter)
y2 = y2 - 4

local magnitude = math.sqrt(vx^2 + vy^2)
dir = dir - (0.05 + magnitude / 8000)

local distance = 15
local target_x = x2 + -math.cos(dir) * distance
local target_y = y2 + math.sin(dir) * distance

EntitySetTransform(me, x, y, dir)
ComponentSetValue2(vel, "mVelocity", vx / 1.5 + (target_x - x) * 2, vy / 1.5 + (target_y - y) * 2)

if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") == 0 then EntityAddChild(shooter, me) end