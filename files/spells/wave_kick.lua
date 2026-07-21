local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local particle = EntityGetFirstComponent(me, "SpriteParticleEmitterComponent")
if not (proj and sprite and particle) then return end
local size = ComponentGetValue2(proj, "blood_count_multiplier")
size = size - 0.2
if size < 0.5 then
	EntityKill(me)
end
ComponentSetValue2(proj, "blood_count_multiplier", size)
ComponentSetValue2(sprite, "special_scale_x", 0)
ComponentSetValue2(sprite, "special_scale_y", 0)
ComponentSetValue2(particle, "scale", size / 8, size / 8)