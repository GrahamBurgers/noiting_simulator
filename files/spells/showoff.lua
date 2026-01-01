function enabled_changed(me, is_enabled)
    local sparkles_perk = tonumber(GlobalsGetValue("SPELL_SPARKLES_COUNT", "0")) or 0
	GlobalsSetValue("SPELL_SPARKLES_COUNT", tostring(sparkles_perk + (is_enabled and 1 or -1)))
end