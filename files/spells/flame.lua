local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local flame_multiplier = 1.5
local conversion = 0.5
if not proj then return end
local cute = ComponentObjectGetValue2(proj, "damage_by_type", "melee")
local charming = ComponentObjectGetValue2(proj, "damage_by_type", "slice")
local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
local amount = 0
local dmg = nil

if cute > 0 and (cute >= charming and cute >= clever and cute >= comedic) then
    dmg = "CUTE"
    amount = cute * (1 - conversion)
    ComponentObjectSetValue2(proj, "damage_by_type", "melee", cute * conversion)
elseif charming > 0 and (charming >= cute and charming >= clever and charming >= comedic) then
    dmg = "CHARMING"
    amount = charming * (1 - conversion)
    ComponentObjectSetValue2(proj, "damage_by_type", "slice", charming * conversion)
elseif clever > 0 and (clever >= cute and clever >= charming and clever >= comedic) then
    dmg = "CLEVER"
    amount = clever * (1 - conversion)
    ComponentObjectSetValue2(proj, "damage_by_type", "fire", clever * conversion)
elseif comedic > 0 and (comedic >= cute and comedic >= charming and comedic >= clever) then
    dmg = "COMEDIC"
    amount = comedic * (1 - conversion)
    ComponentObjectSetValue2(proj, "damage_by_type", "ice", comedic * conversion)
end

dofile_once("mods/noiting_simulator/files/scripts/burn_projectile.lua")
Add_burn(me, dmg, amount * conversion * flame_multiplier)