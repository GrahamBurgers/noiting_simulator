function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it)
	local me = GetUpdatedEntityID()
	local var = me and EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "comedic_heal_multiplier")
	local comedic_heal_factor = tonumber(GlobalsGetValue("COMEDIC_HEAL_FACTOR", "0")) * (var and ComponentGetValue2(var, "value_float") or 1)
	local dmg = EntityGetIsAlive(who_did_it) and EntityGetFirstComponent(who_did_it, "DamageModelComponent")
	if dmg and types.comedic > 0 and comedic_heal_factor > 0 then
		local hurt = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "comedic_hurt_multiplier") or
			EntityAddComponent2(me, "VariableStorageComponent", {_tags="comedic_hurt_multiplier"})
			ComponentSetValue2(hurt, "value_float", 0)
		if who_did_it ~= who_got_hit and ComponentGetValue2(dmg, "hp") < ComponentGetValue2(dmg, "max_hp") then
			EntityInflictDamage(who_did_it, types.comedic * -1 * comedic_heal_factor, "DAMAGE_HEALING", "$inventory_dmg_healing", "NORMAL", 0, 0, who_did_it)
			local x2, y2 = EntityGetTransform(who_did_it)
			EntityLoad("mods/noiting_simulator/files/spells/comedic_heal_silent.xml", x, y)
			EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x2, y2)
			if v then
				v.comedicflashframe = math.max(GameGetFrameNum(), v.comedicflashframe)
				return v
			end
		end
	end
end