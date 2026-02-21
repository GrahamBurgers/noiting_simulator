local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local heart = EntityGetClosestWithTag(x, y, "heart") or 0
local radius = 30
local player = EntityGetRootEntity(me)
if heart == 0 then return end

local x2, y2 = EntityGetTransform(heart)
local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
if distance > radius then return end

local types = {cute = 0.04}
dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
DamageHeart(heart, types, 1, player, nil, x, y, false)

local force = 15

local projs = EntityGetWithTag("projectile") or {}
for i = 1, #projs do
	local proj2 = EntityGetFirstComponent(projs[i], "ProjectileComponent")
	local vel2 = EntityGetFirstComponent(projs[i], "VelocityComponent")
	if proj2 and vel2 and (player == ComponentGetValue2(proj2, "mWhoShot")) then
		local x3, y3 = EntityGetTransform(projs[i])
		local direction = math.pi - math.atan2((y2 - y3), (x2 - x3))

		local vx, vy = ComponentGetValue2(vel2, "mVelocity")
        vx = vx + force * -math.cos(direction)
        vy = vy + force * math.sin(direction)
		ComponentSetValue2(vel2, "mVelocity", vx, vy)
	end
end