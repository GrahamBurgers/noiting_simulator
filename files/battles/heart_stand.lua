local heart = EntityGetWithName("Dummy")
local offset_y = 41.5
if heart and heart > 0 then
    local me = GetUpdatedEntityID()
    local x, y = EntityGetTransform(me)
    local x2, y2 = EntityGetTransform(heart)
    local vel = EntityGetFirstComponent(heart, "VelocityComponent")
    if vel then
        local xv, yv = ComponentGetValue2(vel, "mVelocity")
        xv = xv + (x - x2) / 5
        yv = yv + ((y - offset_y) - y2) / 5
        ComponentSetValue2(vel, "mVelocity", xv, yv)
    end
end