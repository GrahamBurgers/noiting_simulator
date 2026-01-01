function enabled_changed(me, is_enabled)
    local crits = tonumber(GlobalsGetValue("SPELL_CRIT_COUNT", "0")) or 0
	GlobalsSetValue("SPELL_CRIT_COUNT", tostring(crits + (is_enabled and 1 or -1)))
end