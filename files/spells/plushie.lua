local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local dmg = EntityGetFirstComponent(me, "DamageModelComponent")
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
local dmg2 = EntityGetIsAlive(owner) and EntityGetFirstComponent(owner, "DamageModelComponent")
if dmg and dmg2 then
	local maxhp = ComponentGetValue2(dmg2, "max_hp")
	ComponentSetValue2(dmg, "max_hp", maxhp)
	ComponentSetValue2(dmg, "hp", maxhp)
end