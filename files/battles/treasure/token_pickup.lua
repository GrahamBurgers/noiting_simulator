function item_pickup( entity_item, entity_who_picked, item_name )
    local tokens = tonumber(GlobalsGetValue("NS_TOKENS", "0"))
    local tokens_needed = tonumber(GlobalsGetValue("NS_TOKENS_NEEDED", "0"))
    local extra = tonumber(GlobalsGetValue("NS_EXTRA_TREASURE", "0"))
    local x, y = EntityGetTransform(GetUpdatedEntityID())
    tokens = tokens + 1
    GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/rune/destroy", x, y)
    if tokens >= tokens_needed then
        GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/potion/create", x, y)
        extra = extra + 1
        tokens = tokens - tokens_needed
    end

    GlobalsSetValue("NS_TOKENS", tostring(tokens))
    GlobalsSetValue("NS_EXTRA_TREASURE", tostring(extra))
	EntityKill(entity_item)
end