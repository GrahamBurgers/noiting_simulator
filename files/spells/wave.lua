local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local particle = EntityGetFirstComponent(me, "SpriteParticleEmitterComponent")
if not (proj and sprite and particle) then return end
local size = ComponentGetValue2(proj, "blood_count_multiplier")
size = size + 0.4
ComponentSetValue2(proj, "blood_count_multiplier", size)
ComponentSetValue2(sprite, "special_scale_x", size / 8)
ComponentSetValue2(sprite, "special_scale_y", size / 8)
ComponentSetValue2(particle, "scale", size / 8, size / 8)