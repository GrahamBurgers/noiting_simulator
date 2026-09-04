local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local part = EntityGetFirstComponent(me, "ParticleEmitterComponent", "pin")
if not (proj and part) then return end
local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if current ~= last then
    ComponentSetValue2(this, "limit_how_many_times_per_frame", current)
    if current < last then
		ComponentSetValue2(this, "script_material_area_checker_success", "YUP")
    end
end
local pinned = ComponentGetValue2(this, "script_material_area_checker_success") == "YUP"

local frames = tonumber(ComponentGetValue2(this, "script_electricity_receiver_electrified"))
frames = math.max(-1, frames - (pinned and 1 or 0.33))
ComponentSetValue2(this, "script_electricity_receiver_electrified", tostring(frames))

ComponentSetValue2(part, "area_circle_radius", frames / 2, frames / 2)
ComponentSetValue2(part, "count_min", frames * 0.75)
ComponentSetValue2(part, "count_max", frames * 0.75)
ComponentSetValue2(part, "emitted_material_name", "spark_yellow")

local vel = EntityGetFirstComponent(me, "VelocityComponent")
if vel and pinned then
	if frames < 0 then
		ComponentSetValue2(vel, "terminal_velocity", 1000)
		EntityRemoveComponent(me, this)
		EntityRemoveComponent(me, part)
	else
		ComponentSetValue2(vel, "mVelocity", 0, 0)
		ComponentSetValue2(vel, "terminal_velocity", 0)
		ComponentSetValue2(part, "emitted_material_name", "spark_red")
		local x, y = EntityGetTransform(me)
		dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
		ProjHit(nil, nil, me, 1, x, y, nil, {charming = 1 / 60})
	end
end