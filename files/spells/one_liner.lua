local me = GetUpdatedEntityID()
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local var = EntityGetFirstComponent(me, "VariableStorageComponent", "one_liner_direction")
if not (vel and var) then return end
local direction = ComponentGetValue2(var, "value_float")
local vx, vy = ComponentGetValue2(vel, "mVelocity")
if direction == 999999 then
    -- store initial direction
    if vx ~= 0 and vy ~= 0 then
        direction = math.pi - math.atan2(vy, vx)
        ComponentSetValue2(var, "value_float", direction)
    end
else
    -- turn towards stored direction
    local magnitude = math.sqrt(vx^2 + vy^2)
    local theta = (math.deg(direction) * math.pi / 180)
    ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)
end