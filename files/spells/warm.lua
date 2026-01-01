function enabled_changed(me, is_enabled)
    local burn_perk = tonumber(GlobalsGetValue("SPELL_BURNING_COUNT", "0")) or 0
	GlobalsSetValue("SPELL_BURNING_COUNT", tostring(burn_perk + (is_enabled and 1 or -1)))
end