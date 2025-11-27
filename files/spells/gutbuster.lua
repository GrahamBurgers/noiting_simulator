local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local knockback = ComponentGetValue2(proj, "knockback_force")
local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
ComponentObjectSetValue2(proj, "damage_by_type", "ice", dmg + knockback / 25 / 2)