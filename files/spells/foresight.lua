local m = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local grow_time = math.floor(5 * 0.3 * 60) -- (frame_count - 1) * frame_wait * 60
local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
if (m >= grow_time) or not (proj and particle and vel) then return end
q.add_mult(me, "foresight", 1 / grow_time, "dmg_mult_collision")
local new = q.get_mult_with_id(me, "foresight")
ComponentSetValue2(particle, "area_circle_radius", (new - 1) * 4, (new - 1) * 4)
ComponentSetValue2(particle, "count_min", new)
ComponentSetValue2(particle, "count_max", new)
ComponentSetValue2(particle, "attractor_force", new * -0.2)
ComponentSetValue2(vel, "mass", ComponentGetValue2(vel, "mass") + 0.001)
if m == grow_time - 1 then
    ComponentSetValue2(particle, "emitted_material_name", "magic_liquid_mana_regeneration")
    ComponentSetValue2(proj, "bounces_left", ComponentGetValue2(proj, "bounces_left") + 2)
end