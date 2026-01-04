local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent", "entice")
if not particle then return end
local radius = ComponentGetValue2(particle, "count_min") * 4
local force = ComponentGetValue2(particle, "velocity_always_away_from_center")

local projs = EntityGetInRadiusWithTag(x, y, radius + 2, "projectile") or {}
for i = 1, #projs do
	local vel2 = EntityGetFirstComponent(projs[i], "VelocityComponent")
	if projs[i] ~= me and vel2 then
		local x2, y2 = EntityGetTransform(projs[i])
    	local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
		local direction = math.pi - math.atan2((y2 - y), (x2 - x))
		local final = force * (distance / radius) / 30

		EntitySetTransform(projs[i], x2 + final * -math.cos(direction), y2 + final * math.sin(direction))

		local vx, vy = ComponentGetValue2(vel2, "mVelocity")
        vx = vx + final * -math.cos(direction)
        vy = vy + final * math.sin(direction)
		ComponentSetValue2(vel2, "mVelocity", vx, vy)
	end
end