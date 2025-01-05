local me = GetUpdatedEntityID()
local parent = EntityGetRootEntity(me)
local projcomp = EntityGetFirstComponent(parent, "ProjectileComponent")
if projcomp then
    local lifetime = ComponentGetValue2(projcomp, "lifetime")
    local slifetime = ComponentGetValue2(projcomp, "mStartingLifetime")
    local x, y = EntityGetTransform(me)
    if EntityGetName(me) == "slow_hand" then
        EntitySetTransform(me, x, y, -2 * math.pi * (lifetime / slifetime) - (math.pi / 2))
    else
        EntitySetTransform(me, x, y, -6 * math.pi * (lifetime / slifetime) - (math.pi / 2))
    end
end