local me = GetUpdatedEntityID()
local comps = EntityGetWithTag("puppydog_enabled") or {}
if me ~= comps[1] then return end
local count = #comps - 1

local puppydamage = tonumber(GlobalsGetValue("SPELL_PUPPYDOG_DAMAGE", "0"))
if puppydamage > 1 then
	puppydamage = puppydamage * 0.999
end
print(puppydamage)
GlobalsSetValue("SPELL_PUPPYDOG_DAMAGE", tostring(math.max(0, puppydamage - 0.002)))

local player = EntityGetRootEntity(me)
local x, y = EntityGetTransform(me)
local comp = EntityGetFirstComponent(me, "ParticleEmitterComponent", "repulsion")

if not comp then return end

puppydamage = puppydamage * 3 * (1.5 ^ count)
ComponentSetValue2(comp, "count_min", math.min(puppydamage * 2, 15))
ComponentSetValue2(comp, "count_max", math.min(puppydamage * 2, 15))
ComponentSetValue2(comp, "velocity_always_away_from_center", puppydamage * 20)

if puppydamage <= 0 then return end

local force  = math.max(180, puppydamage * 120)
local radius = math.max(35, puppydamage * 8)

local projs = EntityGetInRadiusWithTag(x, y, radius, "projectile") or {}
for i = 1, #projs do
	local vel2 = EntityGetFirstComponent(projs[i], "VelocityComponent")
	if vel2 and EntityGetHerdRelation(player, projs[i]) < 50 then
		local x2, y2 = EntityGetTransform(projs[i])
    	local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
		local direction = math.pi - math.atan2((y2 - y), (x2 - x))
		local final = force * (distance / radius) / 30

		local vx, vy = ComponentGetValue2(vel2, "mVelocity")
        vx = vx + final * -math.cos(direction)
        vy = vy + final * math.sin(direction)
		ComponentSetValue2(vel2, "mVelocity", vx, vy)
	end
end