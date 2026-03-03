local me = GetUpdatedEntityID()
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not (vel and proj) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
vx = vx or 0
vy = vy or 0
local deg = {45, 90, 180}
local added_damage = {5, 8, 15}
local index = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
deg = deg[index]
added_damage = added_damage[index] / 25

local angle = math.deg(0 - math.atan2(vy, vx))
local dist = math.sqrt(vy ^ 2 + vx ^ 2)
angle = math.floor((angle + deg / 2) / deg) * deg
angle = math.rad(angle)

vx = math.cos( angle ) * dist
vy = 0 - math.sin( angle ) * dist

ComponentSetValue2(vel, "mVelocity", vx, vy)

local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
ComponentObjectSetValue2(proj, "damage_by_type", "fire", clever + added_damage)