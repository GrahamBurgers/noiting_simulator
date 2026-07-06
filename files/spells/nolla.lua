local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local dmg_factor = 150
local lifetime_factor = 1
local lifetime = ComponentGetValue2(proj, "lifetime") * lifetime_factor
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "melee") * dmg_factor
print("LIFETIME1: " .. tostring(lifetime) .. ", DMG1: " .. tostring(dmg))
local balanced = (lifetime + dmg) / 2
ComponentSetValue2(proj, "lifetime", balanced / lifetime_factor)
ComponentObjectSetValue2(proj, "damage_by_type", "melee", balanced / dmg_factor)
print("LIFETIME2: " .. tostring(balanced / lifetime_factor) .. ", DMG2: " .. tostring(balanced / dmg_factor))