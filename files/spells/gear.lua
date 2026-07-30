local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if not (proj and vel and ComponentGetValue2(proj, "bounces_left") <= 0) then return end

local frictiony = ComponentGetValue2(this, "script_electricity_receiver_switched")
local last_wall_frame = ComponentGetValue2(this, "execute_times")
if last_wall_frame == -1 then
	last_wall_frame = GameGetFrameNum()
end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local magnitude = math.sqrt(vx^2 + vy^2)
local first_mag = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if first_mag == -1 then
	first_mag = magnitude
	ComponentSetValue2(this, "limit_how_many_times_per_frame", first_mag)
end
for i = 1, 95 do
	if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") == 0 and vx < 0 then
		ComponentSetValue2(proj, "angular_velocity", -ComponentGetValue2(proj, "angular_velocity"))
	end
	local size = ComponentGetValue2(proj, "blood_count_multiplier")

	local rotation_speed = ComponentGetValue2(proj, "angular_velocity") / 90
	local dir = math.pi - math.atan2(vy, vx)

	if i == 1 and last_wall_frame >= GameGetFrameNum() - 1 then
		dir = dir - rotation_speed * 3
	end
	local nx, ny = -math.cos(dir), math.sin(dir)

	local wall, hit_x, hit_y = RaytracePlatforms(x, y, x + (nx * size), y + (ny * size))
	if wall then
		last_wall_frame = GameGetFrameNum()
		-- local distance = math.sqrt((x - hit_x)^2 + (y - hit_y)^2)
		dir = dir + rotation_speed
		vx, vy = (-math.cos(dir)) * magnitude, (math.sin(dir)) * magnitude
		ComponentSetValue2(vel, "mVelocity", vx, vy)
	else
		break
	end
end
if last_wall_frame >= GameGetFrameNum() - 2 then
	EntityAddTag(me, "ignore_gravity")
else
	EntityRemoveTag(me, "ignore_gravity")
end
local threshold = first_mag * 3
local throttle = 1
if magnitude > threshold and frictiony == "0" then
	ComponentSetValue2(this, "script_electricity_receiver_switched", "1")
	ComponentSetValue2(vel, "air_friction", ComponentGetValue2(vel, "air_friction") + throttle)
	-- print("THROTTLING!")
elseif magnitude < threshold and frictiony == "1" then
	ComponentSetValue2(this, "script_electricity_receiver_switched", "0")
	ComponentSetValue2(vel, "air_friction", ComponentGetValue2(vel, "air_friction") - throttle)
	-- print("nvm!")
end
ComponentSetValue2(this, "execute_times", last_wall_frame)