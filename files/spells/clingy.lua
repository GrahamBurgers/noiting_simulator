function enabled_changed(me, is_enabled)
    local sparkles_perk = tonumber(GlobalsGetValue("SPELL_CLINGY_COUNT", "0")) or 0
	GlobalsSetValue("SPELL_CLINGY_COUNT", tostring(sparkles_perk + (is_enabled and 1 or -1)))
end