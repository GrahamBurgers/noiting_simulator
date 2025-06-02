local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local bouncy = EntityGetFirstComponent(me, "VariableStorageComponent", "last_bounces")
local particles = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "inside_joke_bump")
if not (sprite and vel and proj and bouncy and particles) then return end
local radius = 9 + ComponentGetValue2(proj, "blood_count_multiplier")
local dmg_multiplier = 1.5

if ComponentGetValue2(vel, "updates_velocity") then
    if ComponentGetValue2(proj, "bounces_left") < ComponentGetValue2(bouncy, "value_int") then
        ComponentSetValue2(vel, "updates_velocity", false)
        ComponentSetValue2(vel, "terminal_velocity", 0)
        ComponentSetValue2(sprite, "rect_animation", "idle")
        EntitySetComponentsWithTagEnabled(me, "inside_joke_go", true)
        ComponentSetValue2(particles, "is_emitting", true)
        EntityRemoveTag(me, "hittable")
    else
        ComponentSetValue2(sprite, "rect_animation", "deploy")
    end
    return
else
    ComponentSetValue2(sprite, "rect_animation", "")
    ComponentSetValue2(particles, "is_emitting", false)
end
local bump = EntityGetInRadiusWithTag(x, y, radius, "hittable") or {}
for i = 1, #bump do
    if bump[i] ~= me then
        ComponentSetValue2(sprite, "rect_animation", "bump")
        EntityRefreshSprite(me, sprite)
        ComponentSetValue2(particles, "is_emitting", true)

        local x2, y2 = EntityGetTransform(bump[i])
        local vel2 = EntityGetFirstComponentIncludingDisabled(bump[i], "VelocityComponent")
        local cdc = EntityGetFirstComponentIncludingDisabled(bump[i], "CharacterDataComponent")
        local isproj = EntityHasTag(bump[i], "projectile")
        local proj2 = EntityGetFirstComponentIncludingDisabled(bump[i], "ProjectileComponent")

        vel2 = cdc or vel2
        if vel2 then
            GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y )
            local direction = math.pi - math.atan2((y2 - y), (x2 - x))
            local vx, vy = ComponentGetValue2(vel2, "mVelocity")
            local magnitude = math.max(30, math.sqrt(vx^2 + vy^2) * 1.2) + ComponentGetValue2(proj, "knockback_force")
            vx = magnitude * -math.cos(direction) * (cdc and 3 or 1)
            vy = magnitude * math.sin(direction) * (cdc and 2 or 1)

            -- code stolen from nathan. Might be haunted
            local nx, ny = x2 - x, y2 - y
            local mag = (nx * nx + ny * ny) ^ 0.5
            nx, ny = nx / mag, ny / mag

            local vmag = (vx * vx + vy * vy) ^ 0.5
            vx, vy = vx / vmag, vy / vmag

            local dot = nx * vx + ny * vy
            local rx, ry = 2 * nx * dot, 2 * ny * dot
            rx, ry = rx - vx, ry - vy
            rx, ry = rx * vmag, ry * vmag

            ComponentSetValue2(vel2, "mVelocity", rx, ry)

            if isproj and proj2 then
                EntityAddTag(bump[i], "comedic_nohurt")
                ComponentSetValue2(proj2, "lifetime", math.max(90, ComponentGetValue2(proj, "lifetime")))
                ComponentObjectSetValue2(proj2, "damage_by_type", "melee", ComponentObjectGetValue2(proj2, "damage_by_type", "melee") * dmg_multiplier)
                ComponentObjectSetValue2(proj2, "damage_by_type", "slice", ComponentObjectGetValue2(proj2, "damage_by_type", "slice") * dmg_multiplier)
                ComponentObjectSetValue2(proj2, "damage_by_type", "fire", ComponentObjectGetValue2(proj2, "damage_by_type", "fire") * dmg_multiplier)
                ComponentObjectSetValue2(proj2, "damage_by_type", "ice", ComponentObjectGetValue2(proj2, "damage_by_type", "ice") * dmg_multiplier)
                ComponentSetValue2(vel2, "air_friction", 0)
            end
        end
    end
end