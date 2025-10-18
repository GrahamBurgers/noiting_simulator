local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent", "geek_out_bounce")
if not (proj and particle) then return end
local current = ComponentGetValue2(proj, "bounces_left")
local last = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if current ~= last then
    ComponentSetValue2(this, "limit_how_many_times_per_frame", current)
    if current < last then
        -- +40% each bounce and min lifetime to 1 second
        ComponentSetValue2(proj, "damage_scale_max_speed", ComponentGetValue2(proj, "damage_scale_max_speed") + 0.4)
        ComponentSetValue2(proj, "lifetime", math.max(60, ComponentGetValue2(proj, "lifetime")))
        ComponentSetValue2(particle, "is_emitting", true)
    end
else
    ComponentSetValue2(particle, "is_emitting", false)
end