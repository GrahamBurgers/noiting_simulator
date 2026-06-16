local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end
local radius = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
local projs = EntityGetInRadiusWithTag(x, y, radius / 2, "projectile")
for i = 1, #projs do
	local proj2 = EntityGetFirstComponentIncludingDisabled(projs[i], "ProjectileComponent")
	if proj2 and ComponentGetValue2(proj, "mWhoShot") ~= ComponentGetValue2(proj2, "mWhoShot") then
		ComponentSetValue2(proj, "lifetime", 0)
	end
end