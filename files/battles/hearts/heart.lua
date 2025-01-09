local me = GetUpdatedEntityID()
local type = GlobalsGetValue("NS_BAR_TYPE", "CHARM")
local d = EntityGetFirstComponent(me, "DamageModelComponent")
if d and type == "CHARM" then
    local hp, max_hp = ComponentGetValue2(d, "hp") * 25, ComponentGetValue2(d, "max_hp") * 25
    GlobalsSetValue("NS_BAR_MAX", tostring(max_hp))
    GlobalsSetValue("NS_BAR_VALUE", tostring(max_hp - hp))
end