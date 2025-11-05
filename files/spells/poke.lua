local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent", "poke")
if not (proj and particle) then return end
if ComponentGetValue2(this, "mTimesExecuted") == 1 then
    local others = EntityGetComponent(me, "LuaComponent", "poke") or {}
    for i = 1, #others do
        if others[i] ~= this then
            EntityRemoveComponent(me, others[i])
        end
    end
    ComponentSetValue2(this, "script_polymorphing_to", tostring(#others))
end
local total = tonumber(ComponentGetValue2(this, "script_polymorphing_to"))
local count = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local player = ComponentGetValue2(proj, "mWhoShot")
local threshold = 80 * count / total
local x2, y2 = EntityGetTransform(me)
local x, y = EntityGetTransform(player)
local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if distance > threshold and count <= total and vel then
    -- accelerate
    local vx, vy = ComponentGetValue2(vel, "mVelocity")
    local direction = math.pi - math.atan2(vy, vx)
    local magnitude = math.sqrt(vx^2 + vy^2) * 0.95 + 60
    local theta = (math.deg(direction) * math.pi / 180)
    ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)

    ComponentSetValue2(proj, "lifetime", ComponentGetValue2(proj, "lifetime") + 8)

    -- do the bounce
    ComponentSetValue2(this, "limit_how_many_times_per_frame", count + 1)
    local bouncy = EntityGetComponent(me, "LuaComponent", "bounce_effect") or {}
    for i = 1, #bouncy do
        ComponentSetValue2(bouncy[i], "limit_how_many_times_per_frame", ComponentGetValue2(bouncy[i], "limit_how_many_times_per_frame") + 1)
    end
    ComponentSetValue2(particle, "is_emitting", true)
else
    ComponentSetValue2(particle, "is_emitting", false)
end