local me = GetUpdatedEntityID()
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local shield = EntityGetFirstComponentIncludingDisabled(me, "EnergyShieldComponent")
if not (shield and item) then return end
local energy = ComponentGetValue2(shield, "energy")
local x, y, dir = EntityGetTransform(me)
local force_off = false
if energy <= 0 then
	EntityLoad("mods/noiting_simulator/files/items/shroom_explode.xml", x, y)
	EntityKill(me)
	force_off = true
else
	ComponentSetValue2(item, "uses_remaining", energy)
end
local player = EntityGetClosestWithTag(x, y, "player_unit")
local plat = player and EntityGetFirstComponent(player, "CharacterPlatformingComponent")
if not plat then return end
if (EntityGetFirstComponent(me, "EnergyShieldComponent") or 0) == shield and not force_off then
	local strength = math.max(0, 1 - math.abs(dir + math.pi / 2) / 2)
	ComponentSetValue2(plat, "pixel_gravity", 350 - (strength * 250))
else
	ComponentSetValue2(plat, "pixel_gravity", 350)
end