local m = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local particle = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")

local zap_time = 0.65
local zap_speed = 15
local zap_duration = 8
local radius = 16
if not (proj and vel and particle and sprite) then return end

local function chuck(vx, vy, lifetime)
    local projs = EntityGetInRadiusWithTag(x, y, radius, "projectile") or {}
    for i = 1, #projs do
        if projs[i] ~= me then
            local x2, y2 = EntityGetTransform(projs[i])
            local proj2 = EntityGetFirstComponent(projs[i], "ProjectileComponent")
            local vel2 = EntityGetFirstComponent(projs[i], "VelocityComponent")
            if vel2 then
                local vx2, vy2 = ComponentGetValue2(vel2, "mVelocity")
                ComponentSetValue2(vel2, "mVelocity", (vx * 0.75 + vx2 * 0.25), (vy * 0.75 + vy2 * 0.25))
            end
            if proj2 then
                ComponentSetValue2(proj2, "lifetime", math.max(lifetime, ComponentGetValue2(proj2, "lifetime")))
                EntitySetTransform(projs[i], (x * 0.05 + x2 * 0.95), (y * 0.05 + y2 * 0.95))
            end
        end
    end
end

local a = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "intuition_a")
local b = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "intuition_b")
local lifetime = ComponentGetValue2(proj, "mStartingLifetime") - m
local thres1 = math.floor(ComponentGetValue2(proj, "mStartingLifetime") * zap_time)
local thres2 = math.floor(ComponentGetValue2(proj, "mStartingLifetime") * zap_time) - zap_duration
local vx, vy = ComponentGetValue2(vel, "mVelocity")
if lifetime == thres1 then
    vx, vy = vx * zap_speed, vy * zap_speed
    ComponentSetValue2(vel, "mVelocity", vx, vy)
    chuck(vx, vy, lifetime)

    if a then EntitySetComponentIsEnabled(me, a, false) end
    if b then
        EntitySetComponentIsEnabled(me, b, true)
        ComponentSetValue2(b, "mExPosition", x, y)
    end

    ComponentSetValue2(proj, "damage_scale_max_speed", ComponentGetValue2(proj, "damage_scale_max_speed") + 1)
elseif lifetime < thres1 and lifetime > thres2 then
    chuck(vx, vy, lifetime)
elseif lifetime == thres2 then
    ComponentSetValue2(vel, "mVelocity", vx / (zap_speed / 2), vy / (zap_speed / 2))
    ComponentSetValue2(sprite, "rect_animation", "zap")
    EntityRefreshSprite(me, sprite)

    if a then
        EntitySetComponentIsEnabled(me, a, true)
        ComponentSetValue2(a, "mExPosition", x, y)
    end
    if b then EntitySetComponentIsEnabled(me, b, false) end

    ComponentSetValue2(proj, "damage_scale_max_speed", ComponentGetValue2(proj, "damage_scale_max_speed") - 1)
end