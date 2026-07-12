local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local stick_entity = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local stick_frames = tonumber(ComponentGetValue2(this, "script_polymorphing_to"))
local ticks = ComponentGetValue2(this, "mTimesExecuted")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
EntityAddTag(me, "sticky_held")
if ticks >= stick_frames then
	EntityRemoveTag(me, "sticky_held")
	local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "proj_enable")
	if sprite then ComponentSetValue2(sprite, "has_special_scale", false) end
	return
end

local size, magnitude = nil, nil
local x, y = nil, nil
if stick_entity and EntityHasTag(stick_entity, "heart") then
	x, y = EntityGetTransform(stick_entity)
	size = EntityGetFirstComponentIncludingDisabled(stick_entity, "VariableStorageComponent", "hitbox")
	if size then
		magnitude = ComponentGetValue2(size, "value_float")
	end
end
local x2 = tonumber(ComponentGetValue2(this, "script_electricity_receiver_switched"))
local y2 = tonumber(ComponentGetValue2(this, "script_electricity_receiver_electrified"))
local magni2de = tonumber(ComponentGetValue2(this, "script_interacting"))
if x2 then x = x2 end
if y2 then y = y2 end
if magni2de then magnitude = magni2de end

if magnitude and x and y and vel then
    -- Calculate the direction we're SUPPOSED??? to be facing
    local direction = tonumber(ComponentGetValue2(this, "script_material_area_checker_failed")) or 0
    local theta = (math.deg(direction) * math.pi / 180)
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
        ComponentSetValue2(sprite, "has_special_scale", true)
        ComponentSetValue2(sprite, "special_scale_x", -1)
        if cx < 0 and ComponentGetValue2(proj, "velocity_sets_y_flip") then
            -- will probably cause subtle issues somewhere down the line
            ComponentSetValue2(sprite, "special_scale_y", -1)
        end
    end
end