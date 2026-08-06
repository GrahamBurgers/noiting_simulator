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

local drain = 1/25 + (1/7500 * ticks)
local dmg = EntityGetFirstComponent(shooter, "DamageModelComponent")
local hp = dmg and ComponentGetValue2(dmg, "hp") or 0
if dmg and hp > 0.04 then
	drain = math.min(hp - 0.04, drain)
	ComponentSetValue2(dmg, "hp", hp - drain)
	ComponentSetValue2(proj, "collide_with_shooter_frames", ComponentGetValue2(proj, "collide_with_shooter_frames") + 1)
	GameCreateCosmeticParticle("spark_green", x2 + Random(-3, 3), y2 + Random(-3, 3), 1, vx * (distance * 2), vy * (distance * 2), 0, 0.47, 0.47, true, true, false, false, 0, 0)

	local expl = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
	ComponentObjectSetValue2(proj, "config_explosion", "explosion_radius", expl + drain * 8)

	local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
	ComponentObjectSetValue2(proj, "damage_by_type", "ice", comedic + drain * 0.5)

	local size = ComponentGetValue2(proj, "blood_count_multiplier")
	ComponentSetValue2(proj, "blood_count_multiplier", size + drain)

	ComponentSetValue2(sprite, "special_scale_x", size / 6)
	ComponentSetValue2(sprite, "special_scale_y", size / 6)
else
	EntityRemoveComponent(me, this)
	return
end
direction = direction + math.pi
ComponentSetValue2(vel, "mVelocity", vx * magnitude, vy * magnitude)
EntitySetTransform(me, x, y - 1, direction)