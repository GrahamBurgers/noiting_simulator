local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local index = ComponentGetValue2(this, "limit_how_many_times_per_frame")
if not (vel and proj) then return end
if index == -999 then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
vx = vx or 0
vy = vy or 0
local deg = {45, 90, 180}
local added_damage = {8, 10, 15}
deg = deg[index]
added_damage = added_damage[index] / 25

local angle = math.deg(0 - math.atan2(vy, vx))
local dist = math.sqrt(vy ^ 2 + vx ^ 2)
angle = math.floor((angle + deg / 2) / deg) * deg
angle = math.rad(angle)

vx = math.cos( angle ) * dist
vy = 0 - math.sin( angle ) * dist

local spread_deg = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "spread_nonrandom_degrees")
if spread_deg then
	local direction = math.pi - math.atan2(vy, vx)
	local magnitude = math.sqrt(vx^2 + vy^2)
	local theta = (math.deg(direction) * math.pi / 180)
	local add = math.rad(ComponentGetValue2(spread_deg, "value_int"))
	theta = theta + add
	vx, vy = -math.cos(theta) * magnitude, math.sin(theta) * magnitude
end

ComponentSetValue2(vel, "mVelocity", vx, vy)
local x, y = EntityGetTransform(me)
EntitySetTransform(me, x, y, -angle)

local var = EntityGetFirstComponent(me, "VariableStorageComponent", "one_liner_direction")
if var then
    ComponentSetValue2(var, "value_float", angle + math.pi)
end

if EntityHasTag(me, "is_held") then return end

local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
ComponentObjectSetValue2(proj, "damage_by_type", "fire", clever + added_damage)
ComponentSetValue2(this, "limit_how_many_times_per_frame", -999)