local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local cutoff = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local scale = 0.75
local speed = 0.8
local lifetime_raw = 50
local lifetime = lifetime_raw - cutoff * 0.75
local fade_buffer = 1.5
local velocity_inherit_div = 150

local magnitude = tonumber(ComponentGetValue2(this, "script_electricity_receiver_electrified")) or 0
local theta = tonumber(ComponentGetValue2(this, "script_material_area_checker_failed")) or 0
local ticks_raw = ComponentGetValue2(this, "mTimesExecuted")
local ticks = math.max(0.1, ticks_raw - cutoff)
local momentum = math.min(1, ((-ticks * fade_buffer) / lifetime) + fade_buffer)

local vel_x = 0 - math.cos(theta) * speed --* momentum
local vel_y = math.sin(theta) * speed --* momentum
local target = tonumber(ComponentGetValue2(this, "script_material_area_checker_success")) or 0
local vel = target and target > 0 and EntityGetIsAlive(target) and EntityGetFirstComponent(target, "VelocityComponent")
if vel then
    local vx, vy = ComponentGetValue2(vel, "mVelocity")
    vel_x, vel_y = vel_x + vx / velocity_inherit_div, vel_y + vy / velocity_inherit_div
end

local sprite = EntityGetFirstComponent(me, "SpriteComponent")
if sprite then
    ComponentSetValue2(sprite, "alpha", momentum)
    local size = (math.sin(ticks / 2) / (ticks / 3)) * ((math.log(magnitude + 1.5)) / 8) + scale
    ComponentSetValue2(sprite, "special_scale_x", size)
    ComponentSetValue2(sprite, "special_scale_y", size)
end

local x, y = EntityGetTransform(me)
EntitySetTransform(me, x + vel_x, y + vel_y)

if ticks_raw > lifetime_raw * 0.75 then EntitySetName(me, "") end
if ticks > lifetime then EntityKill(me) end