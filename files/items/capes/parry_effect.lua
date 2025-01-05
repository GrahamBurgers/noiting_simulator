local radius = 18
local iframes = 120

local me = GetUpdatedEntityID()
local player = EntityGetRootEntity(me)
local x, y = EntityGetTransform(player)
y = y - 2
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if proj then
    local lifetime = ComponentGetValue2(proj, "lifetime")
    local start = ComponentGetValue2(proj, "mStartingLifetime")
    local turn = (math.pi * -4) * (lifetime / start)
    local size = 0.5 + (2 * (lifetime / start))
    EntitySetTransform(me, x, y, turn, size, size)
end
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
                local prot = EntityGetAllChildren(player, "effect_protection") or {}
                local entity, comp
                if #prot > 0 then
                    -- just reset cooldown of the existing entity
                    entity = prot[1]
                else
                    -- give a new entity
                    entity = LoadGameEffectEntityTo(player, "data/entities/misc/effect_protection_all.xml")
                    comp = EntityGetFirstComponent(entity, "GameEffectComponent")
                    EntityAddComponent2(entity, "UIIconComponent", {
                        name="$status_protection_all",
                        description="$statusdesc_protection_all",
                        icon_sprite_file="data/ui_gfx/status_indicators/protection_all.png",
                        is_perk=false,
                        display_above_head=true,
                        display_in_hud=true,
                    })
                end
                if entity then
                    comp = EntityGetFirstComponent(entity, "GameEffectComponent")
                    if comp then ComponentSetValue2(comp, "frames", iframes) end
                end
                local d = EntityGetFirstComponent(player, "CharacterDataComponent")
                if d then
                    ComponentSetValue2(d, "mFlyingTimeLeft", ComponentGetValue2(d, "fly_time_max"))
                end
                GlobalsSetValue("NS_CAPE_NEXT_FRAME", tostring(GameGetFrameNum() + 6))
            end
        end
    end
end
if done then EntityKill(me) end -- don't parry multiple times per activation