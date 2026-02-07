local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if not (proj and vel) then return end

local arc = ComponentGetValue2(proj, "direction_nonrandom_rad") * -0.75
local duration = ComponentGetValue2(proj, "mStartingLifetime") - 5 -- grace period
local vx, vy = ComponentGetValue2(vel, "mVelocity")

local direction = math.pi - math.atan2(vy, vx)
local magnitude = math.sqrt(vx^2 + vy^2)
direction = direction + (arc / duration) * math.pi * 0.785

local theta = (math.deg(direction) * math.pi / 180)
ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)