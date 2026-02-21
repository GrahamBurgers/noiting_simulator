local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent", "geek_out_bounce")
if not (proj and particle) then return end
local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if current ~= last then
    ComponentSetValue2(this, "limit_how_many_times_per_frame", current)
    if current < last then
        -- +50% each bounce
        q.add_mult(me, "geek_out", 0.5, "dmg_mult_collision,dmg_mult_explosion")
        ComponentSetValue2(particle, "is_emitting", true)
    end
else
    ComponentSetValue2(particle, "is_emitting", false)
end