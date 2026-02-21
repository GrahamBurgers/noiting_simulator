local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local dmg_factor = 25
local kb_factor = 2
local knockback = ComponentGetValue2(proj, "knockback_force") * kb_factor
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "ice") * dmg_factor
local balanced = (knockback + dmg) / 2
ComponentSetValue2(proj, "knockback", balanced / kb_factor)
ComponentObjectSetValue2(proj, "damage_by_type", "ice", balanced / dmg_factor)