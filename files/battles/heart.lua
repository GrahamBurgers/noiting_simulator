local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local hitbox = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "heart_hitbox")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (hitbox and vel) then return end

-- player contact damage --
local force = 100
local push = -0.5
local mortals = EntityGetInRadiusWithTag(x, y, ComponentGetValue2(hitbox, "value_float"), "player_unit") or {}
for i = 1, #mortals do
    if #EntityGetAllChildren(mortals[i], "heart_knockback") < 1 then -- don't chain stuns
        local x2, y2 = EntityGetTransform(mortals[i])
        local cdc = EntityGetFirstComponentIncludingDisabled(mortals[i], "CharacterDataComponent")
        if cdc then
            local mymass = ComponentGetValue2(vel, "mass")
            local knockback = (mymass / ComponentGetValue2(cdc, "mass")) * force
            local direction = math.pi - math.atan2((y2 - y), (x2 - x))
            local vx, vy = ComponentGetValue2(cdc, "mVelocity")
            vx = vx + knockback * -math.cos(direction) * 1.5
            vy = vy + knockback * math.sin(direction)

            ComponentSetValue2(cdc, "mVelocity", vx, vy)
            local vx2, vy2 = ComponentGetValue2(vel, "mVelocity")
            ComponentSetValue2(vel, "mVelocity", vx2 + vx * push, vy2 + vy * push)

            -- EntityInflictDamage(mortals[i], mymass / 10, "DAMAGE_PROJECTILE", "$ns_contact_damage", "NONE", 0, 0, me)
            local stun = EntityCreateNew()
            EntityAddTag(stun, "heart_knockback")
            EntityAddComponent2(stun, "GameEffectComponent", {
                effect="ELECTROCUTION",
                frames=30,
                disable_movement=true,
            })
            EntityAddChild(mortals[i], stun)
        end
    end
end

-- AI LOGIC --