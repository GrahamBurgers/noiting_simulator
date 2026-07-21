function enabled_changed(me, is_enabled)
    local wavekick = tonumber(GlobalsGetValue("SPELL_WAVE_KICK_COUNT", "0")) or 0
	GlobalsSetValue("SPELL_WAVE_KICK_COUNT", tostring(wavekick + (is_enabled and 1 or -1)))
end