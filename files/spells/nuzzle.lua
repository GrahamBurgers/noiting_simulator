local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local radius = 30
local heart = EntityGetInRadiusWithTag(x, y, radius * 2, "heart") or {}
local player = EntityGetRootEntity(me)
local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")

local types = {cute = 0.04}
dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")

for j = 1, #heart do
	if touchinghitbox(radius, heart[j], true) then
		local x2, y2 = EntityGetTransform(heart[j])
		DamageHeart(heart[j], types, 1, player, nil, x, y, false)

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
	end
end