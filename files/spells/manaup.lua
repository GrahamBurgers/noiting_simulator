function enabled_changed(me, is_enabled)
	local mana_chg = tonumber(GlobalsGetValue("INHERENT_MANA_CHG", "0")) or 0
	local mana_max = tonumber(GlobalsGetValue("INHERENT_MANA_MAX", "0")) or 0

	mana_chg = mana_chg + (is_enabled and 3 or -3)
	mana_max = mana_max + (is_enabled and 25 or -25)

	GlobalsSetValue("INHERENT_MANA_CHG", tostring(mana_chg))
	GlobalsSetValue("INHERENT_MANA_MAX", tostring(mana_max))
end