local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")

if not proj then return end
local cute = ComponentObjectGetValue2(proj, "damage_by_type", "melee")
local charming = ComponentObjectGetValue2(proj, "damage_by_type", "slice")
local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
local typeless = ComponentObjectGetValue2(proj, "damage_by_type", "drill")

ComponentObjectSetValue2(proj, "damage_by_type", "healing", (cute + charming + clever + comedic + typeless) * 2)