local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not (vel and proj) then return end
local size = ComponentGetValue2(proj, "blood_count_multiplier") + 1
local fraction = ComponentGetValue2(proj, "lifetime") / 1
for i = 1, fraction do
	local x, y = EntityGetTransform(me)
	local vx, vy = ComponentGetValue2(vel, "mVelocity")
	local air_friction = ComponentGetValue2(vel, "air_friction")
	vx = vx - 0.016666567 * vx * air_friction
	vy = vy - 0.016666567 * vy * air_friction
	ComponentSetValue2(vel, "mVelocity", vx, vy)

	local lifetime = ComponentGetValue2(proj, "lifetime")
	ComponentSetValue2(proj, "lifetime", lifetime - 1)

	local dir = math.pi - math.atan2(vy, vx)
	local oldx, oldy = x, y
	x = x + vx / 60
	y = y + vy / 60
	EntitySetTransform(me, x, y, dir)
	for j = 1, size * 4 do
		SetRandomSeed(x + me + j, i + y + 403850)
		local rnd = Random(1, 360)
		GameCreateCosmeticParticle("glass_static", x + -math.cos(rnd) * size, y + math.sin(rnd) * size, 1, 0, 0, nil, 0.1, 0.5, true, false, true, true, 0, 90)
	end
	dofile("mods/noiting_simulator/files/spells/_base.lua")
	if (RaytracePlatforms(x, y, x + vx / 60, y + vy / 60) and not ComponentGetValue2(proj, "penetrate_world")) then
		EntitySetTransform(me, oldx, oldy, dir)
		break
	end
	if lifetime < 1 or EntityHasTag(me, "kill_now") or i > (60 * 60 * 10) then
		break
	end
end
EntityRemoveComponent(me, this)