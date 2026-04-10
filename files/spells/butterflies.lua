function enabled_changed(me, is_enabled)
    local butterflies = tonumber(GlobalsGetValue("SPELL_BUTTERFLIES_COUNT", "0")) or 0
	GlobalsSetValue("SPELL_BUTTERFLIES_COUNT", tostring(butterflies + (is_enabled and 1 or -1)))
end