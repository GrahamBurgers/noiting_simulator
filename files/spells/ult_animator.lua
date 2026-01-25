local m = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local grow_time = math.floor(5 * 0.5 * 60) -- (frame_count) * frame_wait * 60
if m < grow_time or not (sprite and vel and proj) then return end
GameCreateParticle("spark_white", x, y, 60, 100, 100, true, true, true)
ComponentSetValue2(sprite, "rect_animation", "activated")
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local direction = math.pi - math.atan2(vy, vx)
local magnitude = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
-- print(ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame"))
local theta = (math.deg(direction) * math.pi / 180)
ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)
ComponentSetValue2(vel, "air_friction", 0)
ComponentSetValue2(proj, "play_damage_sounds", true)
EntitySetComponentsWithTagEnabled(me, "ult_enable", true)

local particle = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
for i = 1, #particle do
    ComponentSetValue2(particle[i], "mExPosition", x, y)
    ComponentSetValue2(particle[i], "m_last_emit_position", x, y)
end

EntityRemoveComponent(me, GetUpdatedComponentID())