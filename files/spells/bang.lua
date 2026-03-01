local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end
local x, y = EntityGetTransform(me)
dofile_once("data/scripts/lib/utilities.lua")
SetRandomSeed(me + proj + GetUpdatedComponentID(), GameGetFrameNum())

local how_many = 12
local angle_inc = (2 * math.pi) / how_many
local theta = Random(math.pi * -100, math.pi * 100) / 100

for q = 1, how_many do
	local speed = Random(155, 175)
	local vel_x = math.cos(theta) * speed
	local vel_y = math.sin(theta) * speed
	theta = theta + angle_inc
	shoot_projectile_from_projectile(me, "mods/noiting_simulator/files/spells/sparkle.xml", x + vel_x / 120, y + vel_y / 120, vel_x, vel_y)
end