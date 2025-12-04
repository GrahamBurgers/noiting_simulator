local me = GetUpdatedEntityID()
local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local player = EntityGetWithTag("player_unit") or {}
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent", "geek_out_bounce")
if not (proj and particle) then return end
ComponentSetValue2(particle, "is_emitting", false)
local wait = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", wait - 1)
if wait > 0 then return end
for i = 1, #player do
    if touchinghitbox(ComponentGetValue2(proj, "blood_count_multiplier"), player[i], true) then
        local x, y = EntityGetTransform(me)
        local vel = EntityGetFirstComponent(me, "VelocityComponent")
        local heart = EntityGetClosestWithTag(x, y, "heart")
        -- ping towards heart when we hit player
        if vel and heart and heart > 0 then
            local vx, vy = ComponentGetValue2(vel, "mVelocity")
            local x2, y2 = EntityGetTransform(heart)
            local magnitude = math.sqrt(vx^2 + vy^2)
            local direction = math.pi - math.atan2((y2 - y), (x2 - x))
            local vel_x = 0 - math.cos( direction ) * magnitude
            local vel_y = math.sin( direction ) * magnitude
            ComponentSetValue2(vel, "mVelocity", vel_x, vel_y)
            ComponentSetValue2(particle, "is_emitting", true)
            ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", 12)
            GamePlayAnimation(player[i], "kick_fast", 99)
            return
        end
    end
end