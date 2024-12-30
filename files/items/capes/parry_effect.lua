local radius = 18
local iframes = 16

local me = GetUpdatedEntityID()
local turn = -math.pi / 5
local x, y, rot, scale_x = EntityGetTransform(me)
local size = scale_x + (0 - scale_x) / 12
local player = EntityGetRootEntity(me)
EntitySetTransform(me, x, y, rot + turn, size, size)
local projectiles = EntityGetInRadiusWithTag(x, y, radius, "projectile")
local done = false
for i = 1, #projectiles do
    local p = EntityGetFirstComponent(projectiles[i], "ProjectileComponent")
    if p then
        if StringToHerdId("player") ~= ComponentGetValue2(p, "mShooterHerdId") then -- don't parry your own projectiles
            ComponentSetValue2(p, "on_death_explode", false)
            ComponentSetValue2(p, "on_death_emit_particle", false)
            EntityKill(projectiles[i])
            if not done then -- things we don't need to do twice in the same frame
                done = true
                EntityLoad("mods/noiting_simulator/files/items/capes/parry_poof.xml", x, y)
                local comp = GetGameEffectLoadTo(player, "PROTECTION_ALL", false)
                ComponentSetValue2(comp, "frames", iframes)
                GlobalsSetValue("NS_CAPE_NEXT_FRAME", tostring(GameGetFrameNum()))
            end
        end
    end
end
if done then EntityKill(me) end -- don't parry multiple times per activation