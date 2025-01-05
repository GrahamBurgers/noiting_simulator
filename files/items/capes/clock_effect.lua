local me = GetUpdatedEntityID()
local multiply = 5
local divide = 1 / multiply
local tag = "ns_clock_slow"
local projcomp = EntityGetFirstComponent(me, "ProjectileComponent")

local function set(comp, attribute, multiplier)
    if comp then
        local num, two = ComponentGetValue2(comp, attribute)
        if two then
            ComponentSetValue2(comp, attribute, num * multiplier, two * multiplier)
        else
            ComponentSetValue2(comp, attribute, num * multiplier)
        end
    end
end
local function attributes(entity, mult, div)
    local p = EntityGetFirstComponent(entity, "ProjectileComponent")
    set(p, "lifetime", mult)
    set(p, "friction", div)
    set(p, "die_on_low_velocity_limit", div)
    local v = EntityGetFirstComponent(entity, "VelocityComponent")
    set(v, "gravity_x", div * div)
    set(v, "gravity_y", div * div)
    set(v, "air_friction", div)
    set(v, "mass", div)
    set(v, "liquid_drag", div)
    set(v, "mVelocity", div)
    local pa = EntityGetFirstComponent(entity, "ParticleEmitterComponent")
    set(pa, "emission_interval_min_frames", mult)
    set(pa, "emission_interval_max_frames", mult)
    local h = EntityGetFirstComponent(entity, "HomingComponent")
    set(h, "homing_targeting_coeff", div)
end

if projcomp then
    local lifetime = ComponentGetValue2(projcomp, "lifetime")
    if lifetime > 1 then
        local proj = EntityGetWithTag("projectile") or {}
        for i = 1, #proj do
            if not EntityHasTag(proj[i], tag) and EntityGetName(proj[i]) ~= "$ns_cape_effect" then
                EntityAddTag(proj[i], tag)
                attributes(proj[i], multiply, divide)
            end
        end
    else
        local slowed = EntityGetWithTag(tag) or {}
        for i = 1, #slowed do
            EntityRemoveTag(slowed[i], tag)
            attributes(slowed[i], divide, multiply)
        end
    end
end