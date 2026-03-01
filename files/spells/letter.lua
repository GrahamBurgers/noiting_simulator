local me = GetUpdatedEntityID()

local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent", "base_component")
local total = tonumber(ComponentGetValue2(GetUpdatedComponentID(), "script_polymorphing_to")) or 0
if not (vel and sprite and proj) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
if total < 1 then
	local direction = math.pi - math.atan2(vy, vx)
	local magnitude = math.sqrt(vx^2 + vy^2)

	local var = EntityGetFirstComponent(me, "VariableStorageComponent", "one_liner_direction")
	local dir = var and ComponentGetValue2(var, "value_float")

	local time = 35
	local correction_frames = 4
	local theta = (math.deg(direction) * math.pi / 180)
	local tick = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") or 0
	local add = 0.05
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
end

local x, y = EntityGetTransform(me)
local heart = EntityGetClosestWithTag(x, y, "heart")
local this = GetUpdatedComponentID()
local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if current ~= last then
    ComponentSetValue2(this, "limit_how_many_times_per_frame", current)
    ComponentSetValue2(GetUpdatedComponentID(), "script_polymorphing_to", tostring(total + 1))
    if total == 0 then
        -- paper time
		ComponentSetValue2(sprite, "rect_animation", "crumple")
		ComponentSetValue2(vel, "gravity_y", 200)
		local p1 = EntityGetFirstComponent(me, "ParticleEmitterComponent", "p1") or 0
		local p2 = EntityGetFirstComponent(me, "ParticleEmitterComponent", "p2") or 0
		ComponentSetValue2(p2, "is_emitting", false)

		ComponentSetValue2(p1, "offset", 0, 0)
		ComponentSetValue2(p1, "lifetime_min", 5)
		ComponentSetValue2(p2, "lifetime_min", 5)
		ComponentSetValue2(p1, "count_min", 8)
		ComponentSetValue2(p2, "count_max", 8)
		ComponentSetValue2(p1, "area_circle_radius", 2, 2)

		local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
        q.set_mult(me, "letter_crumple", 0.5, "dmg_mult_collision,dmg_mult_explosion")
	elseif total == 1 and heart and heart > 0 then
		-- jump
		local x2, y2 = EntityGetTransform(heart)
    	local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
		distance = math.min(125, distance)
		y2 = y2 - distance * 0.2 -- compensate for gravity

		SetRandomSeed(x2 + x, y2 + y)
        local angle = (math.pi - math.atan2((y2 - y), (x2 - x)))
		local len = 180 + distance
		vx = (-math.cos( angle ) * len)
		vy = (math.sin( angle ) * len)
		ComponentSetValue2(vel, "mVelocity", vx, vy)
	end
end