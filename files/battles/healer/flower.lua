local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local target_x = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local target_y = ComponentGetValue2(this, "limit_to_every_n_frame")

local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local particle = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
local collision = EntityGetFirstComponentIncludingDisabled(me, "CollisionTriggerComponent")
if EntityHasTag(me, "growed") and sprite then
	local drop = EntityGetInRadiusWithTag(x, y, 8, "water_drop")
	if target_x == 0 and #drop > 0 then
		EntityKill(drop[1])
		ComponentSetValue2(this, "limit_how_many_times_per_frame", 300)
		ComponentSetValue2(sprite, "rect_animation", "huge")
	elseif target_x > 0 then
		ComponentSetValue2(this, "limit_how_many_times_per_frame", target_x - 1)
		y = y + ((target_y - 126) - y) / 20

		local node_count = 13
		local node_px_between = 10
		local node_fire_frames = 14
		if target_x % node_fire_frames == 0 then
			local node_index = node_count - (target_x / node_fire_frames)
			if node_index <= node_count then
				local offset_x = -7
				local offset_y = -2 + node_px_between * node_index
				local aim = "LEFT"
				if node_index % 2 == 0 then
					offset_x = -offset_x
					aim = "RIGHT"
				end
				if offset_y > 0 then
					dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
					Shoot({file = "mods/noiting_simulator/files/battles/healer/thornball.xml", x = x + offset_x, y = y + offset_y, target = aim, do_muzzle_flash = true})
				end
			end
		end
	else
		y = math.min(target_y, (y + (target_y - y) / 40) + 0.1)
	end

	EntitySetTransform(me, x, y, 0)
elseif sprite and proj and vel and collision and particle then
	x = x + (target_x - x) / 20
	if y >= target_y then
		y = target_y
		EntityAddTag(me, "growed")
		EntitySetComponentIsEnabled(me, collision, true)
		EntitySetComponentIsEnabled(me, particle, true)
		ComponentSetValue2(sprite, "rect_animation", "grow")
		ComponentSetValue2(vel, "terminal_velocity", 0)
		ComponentSetValue2(this, "limit_how_many_times_per_frame", 0)
	end
	EntitySetTransform(me, x, y, 0)
end