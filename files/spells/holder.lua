local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
if not (proj and vel) then return end
local shooter = ComponentGetValue2(proj, "mWhoShot")
local controls = shooter and EntityGetFirstComponent(shooter, "ControlsComponent")
local inv = EntityGetFirstComponent(shooter, "Inventory2Component")
local wand = inv and ComponentGetValue2(inv, "mActiveItem")
if not wand then return end
local x2, y2 = EntityGetTransform(wand)

if ComponentGetValue2(this, "mTimesExecuted") == 0 then
    local vx, vy = ComponentGetValue2(vel, "mVelocity")
    local magnitude = math.sqrt(vx^2 + vy^2)
    ComponentSetValue2(this, "limit_how_many_times_per_frame", magnitude)
elseif controls then
    local magnitude = ComponentGetValue2(this, "limit_how_many_times_per_frame")
    local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
    local direction = math.pi - math.atan2(dy, dx)
    local hotspot = EntityGetFirstComponentIncludingDisabled(wand, "HotspotComponent", "shoot_pos")

    local vx, vy = -math.cos(direction) * magnitude, math.sin(direction) * magnitude
    if hotspot then
        magnitude = magnitude + ComponentGetValue2(hotspot, "offset") * 60
    end

    EntitySetTransform(me, x2 + (-math.cos(direction) * magnitude / 60) - vx / 60, y2 + (math.sin(direction) * magnitude / 60) - vy / 60)
    ComponentSetValue2(vel, "mVelocity", vx, vy)

    local one_liner = EntityGetFirstComponent(me, "VariableStorageComponent", "one_liner_direction")
    if one_liner then
        ComponentSetValue2(one_liner, "value_float", direction)
    end
    if ComponentGetValue2(proj, "lifetime") < ComponentGetValue2(proj, "mStartingLifetime") / 2 then
        EntityRemoveComponent(me, this)
    end
end