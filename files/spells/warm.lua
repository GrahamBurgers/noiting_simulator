function enabled_changed(me, is_enabled)
    local burn_perk = tonumber(GlobalsGetValue("PERK_PICKED_BURNING_PICKUP_COUNT", "0")) or 0
	GlobalsSetValue("PERK_PICKED_BURNING_PICKUP_COUNT", tostring(burn_perk + (is_enabled and 1 or -1)))
end