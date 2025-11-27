local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local stick_entity = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local stick_frames = ComponentGetValue2(this, "execute_times")
local ticks = ComponentGetValue2(this, "mTimesExecuted")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local size = EntityGetFirstComponentIncludingDisabled(stick_entity, "VariableStorageComponent", "hitbox")
if size and stick_entity and EntityHasTag(stick_entity, "heart") and vel then
    -- Calculate the direction we're SUPPOSED??? to be facing
    local x, y = EntityGetTransform(stick_entity)
    local direction = tonumber(ComponentGetValue2(this, "script_material_area_checker_failed")) or 0
    local theta = (math.deg(direction) * math.pi / 180)
    local magnitude = (ComponentGetValue2(size, "value_float"))
    local final = (-magnitude * ticks^2 + 2 * stick_frames * magnitude * ticks) / stick_frames^2 -- EVIL!!!!

    -- apply and try to fix weird issues....
    local speed = tonumber(ComponentGetValue2(this, "script_material_area_checker_success")) or 0
    local cx, cy = -math.cos(theta) * speed, math.sin(theta) * speed
    local fx, fy = x + -math.cos(theta) * final, y + math.sin(theta) * final
    EntitySetTransform(me, fx, fy, 1.5 * math.pi - math.atan2(cx, cy))
    ComponentSetValue2(vel, "mVelocity", cx, cy)

    -- where are our trails???
    local particle = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
    for i = 1, #particle do
        ComponentSetValue2(particle[i], "mExPosition", fx, fy)
        ComponentSetValue2(particle[i], "m_last_emit_position", fx, fy)
    end

    -- cosmetic
    local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "proj_enable")
    local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
    if sprite and proj then
        if ticks == 0 then EntitySetComponentIsEnabled(me, sprite, true) end
        if cx < 0 and ComponentGetValue2(proj, "velocity_sets_y_flip") then
            -- will probably cause subtle issues somewhere down the line
            ComponentSetValue2(sprite, "has_special_scale", true)
            ComponentSetValue2(sprite, "special_scale_y", -1)
        end
    end
end