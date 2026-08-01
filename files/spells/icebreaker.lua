local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local var = EntityGetFirstComponent(me, "VariableStorageComponent", "spread_nonrandom_degrees")
if not (proj and vel and var) then return end

local value = ComponentGetValue2(var, "value_string")
local arc = math.rad((value == "hi_im_75" and 75) or (value == "hi_im_not_75" and -75) or 0) * -0.75
local duration = ComponentGetValue2(proj, "mStartingLifetime") - 5 -- grace period
local vx, vy = ComponentGetValue2(vel, "mVelocity")

local direction = math.pi - math.atan2(vy, vx)
local magnitude = math.sqrt(vx^2 + vy^2)
direction = direction + (arc / duration) * math.pi * 0.785

local theta = (math.deg(direction) * math.pi / 180)
ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)