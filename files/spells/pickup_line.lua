local me = GetUpdatedEntityID()
local particles = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (particles and vel) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
vx = math.abs(vx or 0) / 25
vy = math.abs(vy or 0) / 25
ComponentSetValue2(particles, "count_min", vx + vy)
ComponentSetValue2(particles, "count_max", vx + vy)