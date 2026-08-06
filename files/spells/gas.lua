local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local part = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
local vel =  EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and part and vel) then return end
local ticks = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local size = ComponentGetValue2(proj, "blood_count_multiplier")
size = size + (math.log((ticks * 5) + 1) / 50)
ComponentSetValue2(proj, "blood_count_multiplier", size)

ComponentSetValue2(part, "area_circle_radius", 0, size)
ComponentSetValue2(part, "count_min", 4 + size * 0.75)
ComponentSetValue2(part, "count_max", 4 + size * 0.75)

local vx, vy = ComponentGetValue2(vel, "mVelocity")
local magnitude = math.sqrt(vx^2 + vy^2)
ComponentSetValue2(part, "x_vel_min", magnitude * -0.25)
ComponentSetValue2(part, "x_vel_max", magnitude * -0.25)