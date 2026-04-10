local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local part = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and part and vel) then return end
local player = ComponentGetValue2(proj, "mWhoShot")
local x, y = EntityGetTransform(player)
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local div = 0.3
vx = vx * div
vy = vy * div

EntitySetTransform(me, x, y)

local _, radius = ComponentGetValue2(part, "area_circle_radius")
ComponentSetValue2(part, "x_vel_min", vx)
ComponentSetValue2(part, "x_vel_max", vx)
ComponentSetValue2(part, "y_vel_min", vy)
ComponentSetValue2(part, "y_vel_max", vy)

local eligible = EntityGetInRadiusWithTag(x, y, radius or 0, "projectile") or {}
for i = 1, #eligible do
	local v = EntityGetFirstComponent(eligible[i], "VelocityComponent")
    if v then
        local x2, y2 = ComponentGetValue2(v, "mVelocity")
        x2 = x2 + vx * 0.05
        y2 = y2 + vy * 0.05
        ComponentSetValue2(v, "mVelocity", x2, y2)
    end
end