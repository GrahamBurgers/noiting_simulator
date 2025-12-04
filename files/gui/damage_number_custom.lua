local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local cutoff = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local scale = 0.75
local speed = 0.8
local lifetime = 45 - cutoff
local fade_buffer = 1.5

local magnitude = tonumber(ComponentGetValue2(this, "script_electricity_receiver_electrified")) or 0
local theta = tonumber(ComponentGetValue2(this, "script_material_area_checker_failed")) or 0
local ticks = ComponentGetValue2(this, "mTimesExecuted") - cutoff
local momentum = math.min(1, ((-ticks * fade_buffer) / lifetime) + fade_buffer)

local vel_x = 0 - math.cos(theta) * speed --* momentum
local vel_y = math.sin(theta) * speed --* momentum

local sprite = EntityGetFirstComponent(me, "SpriteComponent")
if sprite then
    ComponentSetValue2(sprite, "alpha", momentum)
    local size = (math.sin(ticks / 2) / (ticks / 3)) * ((magnitude + 0.2) / 25) + scale
    ComponentSetValue2(sprite, "special_scale_x", size)
    ComponentSetValue2(sprite, "special_scale_y", size)
end

local x, y = EntityGetTransform(me)
EntitySetTransform(me, x + vel_x, y + vel_y)

if ticks > lifetime then EntityKill(me) end