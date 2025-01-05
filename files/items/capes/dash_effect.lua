local me = GetUpdatedEntityID()
local player = EntityGetRootEntity(me)
local p = EntityGetFirstComponent(me, "ProjectileComponent")
local c = EntityGetFirstComponent(player, "CharacterDataComponent")
local pl = EntityGetFirstComponent(player, "CharacterPlatformingComponent")
if p and c and pl then
    local gravity = ComponentGetValue2(pl, "pixel_gravity") / -60.0106489103
    local x, y = ComponentGetValue2(p, "direction_random_rad"), ComponentGetValue2(p, "direction_nonrandom_rad")
    local vx, vy = ComponentGetValue2(c, "mVelocity")
    ComponentSetValue2(c, "mVelocity", (vx * 0.95) + x, ((vy * 0.95) + y) + gravity)
end