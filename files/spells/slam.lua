local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local player = EntityGetRootEntity(me)
local data = EntityGetFirstComponent(player, "CharacterDataComponent")
local platforming = EntityGetFirstComponent(player, "CharacterPlatformingComponent")
local controls = EntityGetFirstComponent(player, "ControlsComponent")
local stacks = EntityGetWithTag("active_slam") or {}
if not (data and controls and platforming and me == stacks[1]) then return end
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
local types = {cute = 0.2}

local vx, vy = ComponentGetValue2(data, "mVelocity")
local slamming_frames = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local is_grounded = ComponentGetValue2(data, "is_on_ground")
local is_hitting_heart
local sparkle_count = 6 * #stacks
local slam_speed = 200 + (100 * #stacks)
local fly_recovery_div = 120 / #stacks

if slamming_frames > 0 then
	local hearts = EntityGetWithTag("heart")
	for i = 1, #hearts do
		local hitting_this_heart = touchinghitbox(2, hearts[i], true)
		is_hitting_heart = is_hitting_heart or hitting_this_heart
		if hitting_this_heart then
			local x, y = EntityGetTransform(hearts[i])
			DamageHeart(hearts[i], types, 1, player, nil, x, y, false)
		end
	end
end

local max_speed_default = 350 -- ??
if slamming_frames < 0 then
	ComponentSetValue2(this, "limit_how_many_times_per_frame", slamming_frames + 1)
elseif is_grounded or is_hitting_heart then
	if slamming_frames >= 10 then
		Shoot({file = "mods/noiting_simulator/files/spells/sparkle.xml", count = sparkle_count, deg_between = 180 / sparkle_count, target = "UP", whoshot = player, comedic_multiplier = 0})
	end
	if is_hitting_heart then
		ComponentSetValue2(data, "mVelocity", vx, -slam_speed)
		ComponentSetValue2(this, "limit_how_many_times_per_frame", -30)
	else
		ComponentSetValue2(this, "limit_how_many_times_per_frame", 0)
	end
	ComponentSetValue2(platforming, "velocity_max_y", max_speed_default)
elseif (slamming_frames == 0 and ComponentGetValue2(controls, "mButtonFrameDown") == GameGetFrameNum()) or slamming_frames > 0 then
	ComponentSetValue2(data, "mFlyingTimeLeft", ComponentGetValue2(data, "mFlyingTimeLeft") + ComponentGetValue2(data, "fly_time_max") / fly_recovery_div)
	ComponentSetValue2(this, "limit_how_many_times_per_frame", slamming_frames + 1)
	ComponentSetValue2(data, "mVelocity", vx, slam_speed)
	ComponentSetValue2(platforming, "velocity_max_y", math.max(max_speed_default, slam_speed))
	if slamming_frames % 3 == 0 then
		Shoot({file = "mods/noiting_simulator/files/spells/sparkle.xml", target = "UP", count = 1, whoshot = player, comedic_multiplier = 0})
	end
end