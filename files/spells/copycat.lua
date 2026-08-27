local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local shooter = proj and ComponentGetValue2(proj, "mWhoShot")
if not (proj and vel and EntityGetIsAlive(shooter)) then return end
local x, y = EntityGetTransform(me)
local x2, y2 = EntityGetTransform(shooter)
y2 = y2 - 4
local gravity_y = math.abs(ComponentGetValue2(proj, "hit_particle_force_multiplier"))
local power = math.abs((ComponentGetValue2(proj, "speed_min") + ComponentGetValue2(proj, "speed_max")) / 50)
local vx, vy = ComponentGetValue2(vel, "mVelocity")
vy = (vy * 0.95) + gravity_y / -120
ComponentSetValue2(vel, "mVelocity", vx, vy + (y > y2 and -power or power))