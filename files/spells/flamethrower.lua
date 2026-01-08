local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local cute = ComponentObjectGetValue2(proj, "damage_by_type", "melee")
local charming = ComponentObjectGetValue2(proj, "damage_by_type", "slice")
local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
local typeless = ComponentObjectGetValue2(proj, "damage_by_type", "drill")
local amount = 0
local dmg = nil

if cute > 0 and (cute >= charming and cute >= clever and cute >= comedic and cute >= typeless) then
    dmg = "CUTE"
    amount = cute
    ComponentObjectSetValue2(proj, "damage_by_type", "melee", 0)
elseif charming > 0 and (charming >= cute and charming >= clever and charming >= comedic and charming >= typeless) then
    dmg = "CHARMING"
    amount = charming
    ComponentObjectSetValue2(proj, "damage_by_type", "slice", 0)
elseif clever > 0 and (clever >= cute and clever >= charming and clever >= comedic and clever >= typeless) then
    dmg = "CLEVER"
    amount = clever
    ComponentObjectSetValue2(proj, "damage_by_type", "fire", 0)
elseif comedic > 0 and (comedic >= cute and comedic >= charming and comedic >= clever and comedic >= typeless) then
    dmg = "COMEDIC"
    amount = comedic
    ComponentObjectSetValue2(proj, "damage_by_type", "ice", 0)
elseif typeless > 0 and (typeless >= cute and typeless >= charming and typeless >= clever and typeless >= comedic) then
    dmg = "TYPELESS"
    amount = typeless
end

dofile_once("mods/noiting_simulator/files/scripts/burn_projectile.lua")
Add_burn(me, dmg, amount * 0.5)