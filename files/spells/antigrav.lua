local me = GetUpdatedEntityID()
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not (vel and proj) then return end
ComponentSetValue2(vel, "air_friction", ComponentGetValue2(vel, "air_friction") - 0.4)
ComponentSetValue2(proj, "hit_particle_force_multiplier", -ComponentGetValue2(proj, "hit_particle_force_multiplier"))