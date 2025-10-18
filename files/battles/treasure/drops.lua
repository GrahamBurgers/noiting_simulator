local me = GetUpdatedEntityID()
local dmg = EntityGetFirstComponent(me, "DamageModelComponent")
if dmg and ComponentGetValue2(dmg, "hp") <= 0 and not EntityGetFirstComponent(me, "LifetimeComponent") then
    EntityAddComponent2(GetUpdatedEntityID(), "LifetimeComponent", {
        lifetime=45,
    })
end
local item = EntityGetFirstComponent(me, "ItemComponent")
if EntityGetName(me) == "ns_token" and item then
    local tokens = GlobalsGetValue("NS_TOKENS", "0")
    local tokens_needed = GlobalsGetValue("NS_TOKENS_NEEDED", "0")
    ComponentSetValue2(item, "item_name", GameTextGet("$ns_token", tokens + 1, tokens_needed))
end