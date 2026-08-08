local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent")
local ticks = ComponentGetValue2(this, "mTimesExecuted")
local shooter = proj and ComponentGetValue2(proj, "mWhoShot")
if not (proj and vel and sprite and EntityGetIsAlive(shooter)) then return end
SetRandomSeed(x + ticks, y + ticks)
y = y + 1

local vx, vy = ComponentGetValue2(vel, "mVelocity")
local magnitude = math.sqrt(vx^2 + vy^2)
local x2, y2 = EntityGetTransform(shooter)
y2 = y2 - 2
x2 = x2
local direction = math.atan2((y2 - y), (x2 - x))
local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
vx, vy = -math.cos(direction), -math.sin(direction)

local drain = 1/250 + (1/4000 * ticks)
local dmg = EntityGetFirstComponent(shooter, "DamageModelComponent")
local hp = dmg and ComponentGetValue2(dmg, "hp") or 0
--[[
if Last_hp and Last_hp < hp then -- pause acceleration on heal. Somewhat strange with regen.
	ComponentSetValue2(this, "mTimesExecuted", -15) -- this seems like a bad idea
end
]]--
Last_hp = hp
drain = math.min(hp - 0.04, drain)

local min_distance = 20
local max_distance = min_distance + hp * 10

if (dmg and hp > 0.04) and distance <= max_distance then
	ComponentSetValue2(dmg, "hp", hp - drain)
	ComponentSetValue2(proj, "collide_with_shooter_frames", ComponentGetValue2(proj, "collide_with_shooter_frames") + 1)
	GameCreateCosmeticParticle("spark_green", x2 + Random(-3, 3), y2 + Random(-3, 3), 1, vx * (distance * 2), vy * (distance * 2), 0, 0.47, 0.47, true, true, false, false, 0, 0)

	local expl = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
	ComponentObjectSetValue2(proj, "config_explosion", "explosion_radius", expl + drain * 8)

	local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
	ComponentObjectSetValue2(proj, "damage_by_type", "ice", comedic + drain * 0.5)

	local size = ComponentGetValue2(proj, "blood_count_multiplier")
	ComponentSetValue2(proj, "blood_count_multiplier", size + drain * 1.5)

	ComponentSetValue2(sprite, "special_scale_x", size / 6)
	ComponentSetValue2(sprite, "special_scale_y", size / 6)
else
	EntityRemoveComponent(me, this)
	return
end
direction = direction + math.pi
ComponentSetValue2(vel, "mVelocity", vx * magnitude, vy * magnitude)
local spread_deg = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "spread_nonrandom_degrees")
if spread_deg then
	direction = direction + math.rad(ComponentGetValue2(spread_deg, "value_int"))
	vx, vy = -math.cos(direction), -math.sin(direction)
end
for i = 1, max_distance - min_distance do
	GameCreateCosmeticParticle("rock_static_glow", x + (-vx * (i + min_distance)), y + (-vy * (i + min_distance)), 1, 0, 0, 0, 0.06, 0.06, true, true, false, false, 0, 0)
end
EntitySetTransform(me, x, y - 1, direction)