local turn_divider = 12
local delay_frames = 6

local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local ticks = ComponentGetValue2(this, "mTimesExecuted")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if (not vel) or (ticks < delay_frames) then return end

local vx, vy = ComponentGetValue2(vel, "mVelocity")
local direction = math.pi - math.atan2(vy or 0, vx or 0)

local magnitude = math.sqrt(vx^2 + vy^2)
local theta = (math.deg(direction) * math.pi / 180)

local turn_amount = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if ticks == delay_frames and -math.cos(theta) < 0 then
	turn_amount = -turn_amount
end
local turn_deg = turn_amount / turn_divider
turn_amount = turn_amount - turn_deg
ComponentSetValue2(this, "limit_how_many_times_per_frame", turn_amount)

theta = theta + math.rad(turn_deg)

ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)