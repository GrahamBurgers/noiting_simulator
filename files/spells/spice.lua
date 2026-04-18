local me = GetUpdatedEntityID()
local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local owner = ComponentGetValue2(proj, "mWhoShot")
local multiplier = q.get_mult(me, "dmg_mult_collision")
local types = {
	cute = ComponentObjectGetValue2(proj, "damage_by_type", "melee") * q.get_mult(me, "dmg_mult_cute") * multiplier,
	charming = ComponentObjectGetValue2(proj, "damage_by_type", "slice") * q.get_mult(me, "dmg_mult_charming") * multiplier,
	clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire") * q.get_mult(me, "dmg_mult_clever") * multiplier,
	comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice") * q.get_mult(me, "dmg_mult_comedic") * multiplier,
	typeless = ComponentObjectGetValue2(proj, "damage_by_type", "drill") * q.get_mult(me, "dmg_mult_typeless") * multiplier,
}

dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
local entity = Shoot({file = "mods/noiting_simulator/files/spells/spice_bang.xml", count = 1, deg_add = 0, whoshot = owner, comedic_multiplier = 0})[1]
local proj2 = EntityGetFirstComponentIncludingDisabled(entity, "ProjectileComponent")
if proj2 then
	ComponentObjectSetValue2(proj2, "damage_by_type", "melee", types.cute)
	ComponentObjectSetValue2(proj2, "damage_by_type", "slice", types.charming)
	ComponentObjectSetValue2(proj2, "damage_by_type", "fire", types.clever)
	ComponentObjectSetValue2(proj2, "damage_by_type", "ice", types.comedic)
	ComponentObjectSetValue2(proj2, "damage_by_type", "drill", types.typeless)
end