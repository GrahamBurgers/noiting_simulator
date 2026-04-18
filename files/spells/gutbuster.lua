local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local dmg_factor = 55
local kb_factor = 2
-- print("knockback: " .. tostring(ComponentGetValue2(proj, "knockback_force")) .. ", dmg: " .. tostring(ComponentObjectGetValue2(proj, "damage_by_type", "ice")))
local knockback = ComponentGetValue2(proj, "knockback_force") * kb_factor
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "ice") * dmg_factor
local balanced = (knockback + dmg) / 2
ComponentSetValue2(proj, "knockback_force", balanced / kb_factor)
ComponentObjectSetValue2(proj, "damage_by_type", "ice", balanced / dmg_factor)
-- print("knockback after: " .. tostring(ComponentGetValue2(proj, "knockback_force")) .. ", dmg: " .. tostring(ComponentObjectGetValue2(proj, "damage_by_type", "ice")))