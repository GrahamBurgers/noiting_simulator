function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it)
	local dmg = EntityGetIsAlive(who_did_it) and EntityGetFirstComponent(who_did_it, "DamageModelComponent")
	if not (dmg and v and v.name ~= "dummy") then return end
	v.damagemax = math.min(v.guardmax - 1, v.damagemax + types.comedic * 25)
    ComponentSetValue2(dmg, "max_hp", ComponentGetValue2(dmg, "max_hp") + types.comedic)
end