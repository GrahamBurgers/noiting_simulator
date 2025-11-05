local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local hitbox = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "hitbox")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local dmg = EntityGetFirstComponentIncludingDisabled(me, "DamageModelComponent")
if not (hitbox and vel and dmg) then return end

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

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = string.len(storage) > 0 and smallfolk.loads(storage)
if not v then return end

-- Fire
local tick_time = 60
local on_fire = EntityGetFirstComponent(me, "VariableStorageComponent", "on_fire")
local fire_particles = EntityGetFirstComponent(me, "ParticleEmitterComponent", "on_fire")
local smoke_particles = EntityGetFirstComponent(me, "ParticleEmitterComponent", "smoke")
if on_fire and fire_particles and smoke_particles then
    local burn_time = ComponentGetValue2(on_fire, "value_float") * v.burn_multiplier
    local type = ComponentGetValue2(on_fire, "value_string")
    local burn_tick = ComponentGetValue2(on_fire, "value_int")
    local is_burning = ComponentGetValue2(on_fire, "value_bool")
    if type ~= "NONE" then
        ComponentSetValue2(fire_particles, "color",
            (type == "CUTE" and 15771118) or
            (type == "CHARMING" and 8048609) or
            (type == "CLEVER" and 15777445) or
            (type == "COMEDIC" and 9558392) or
            (type == "TYPELESS" and 13685968)
        )
        ComponentSetValue2(smoke_particles, "emitted_material_name",
            (type == "CUTE" and "magic_gas_polymorph") or
            (type == "CHARMING" and "spark_yellow") or
            (type == "CLEVER" and "spark_blue") or
            (type == "COMEDIC" and "spark_green") or
            (type == "TYPELESS" and "spark_white")
        )
    end
    if (burn_time > 0 or (burn_time > -1 and is_burning)) and type ~= "NONE" then
        ComponentSetValue2(dmg, "is_on_fire", true)
        ComponentSetValue2(dmg, "mFireFramesLeft", 2)
        ComponentSetValue2(on_fire, "value_bool", true)
        ComponentSetValue2(fire_particles, "is_emitting", true)
        ComponentSetValue2(smoke_particles, "is_emitting", true)
        -- flame cap: 5
        ComponentSetValue2(on_fire, "value_float", math.min(4, burn_time - 0.003))
        if burn_tick <= 0 then
            ComponentSetValue2(on_fire, "value_int", tick_time)
            dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
            local burn_perk = tonumber(GlobalsGetValue("PERK_PICKED_BURNING_PICKUP_COUNT", "0")) or 0
            local fire_multiplier = 1 + (0.1 * burn_perk) * v.fire_multiplier
            DamageHeart(me, {
                cute = type == "CUTE" and 0.005 or 0,
                charming = type == "CHARMING" and 0.005 or 0,
                clever = type == "CLEVER" and 0.005 or 0,
                comedic = type == "COMEDIC" and 0.005 or 0,
                typeless = type == "TYPELESS" and 0.005 or 0,
            }, fire_multiplier, nil, nil, nil, nil, true)
        else
            ComponentSetValue2(on_fire, "value_int", burn_tick - 1)
        end
    elseif burn_time > -1 then
        ComponentSetValue2(fire_particles, "is_emitting", false)
        ComponentSetValue2(smoke_particles, "is_emitting", true)
        ComponentSetValue2(on_fire, "value_int", tick_time)
        ComponentSetValue2(on_fire, "value_float", burn_time - 0.003)
    else
        ComponentSetValue2(fire_particles, "is_emitting", false)
        ComponentSetValue2(smoke_particles, "is_emitting", false)
        ComponentSetValue2(on_fire, "value_int", tick_time)
        ComponentSetValue2(on_fire, "value_bool", false)
    end
end

storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
v = string.len(storage) > 0 and smallfolk.loads(storage)
if not v then return end

-- AI LOGIC --

-- TEMPO LOGIC
local hearts = EntityGetWithTag("heart") or {me}
local heartcount = #(hearts)
local primary = hearts[1] == me
if v.name == "Dummy" then
    v.tempo = 0
    if v.guard <= 0 then v.guard = v.guardmax end
else
    v.tempo = v.tempo + ((v.tempogain / 60) / heartcount)
    if v.tempodebt > 0 then
        local amount = v.tempodebt / 300
        v.tempo = v.tempo + amount
        v.tempodebt = v.tempodebt - amount
    end
end
if v.tempo >= v.tempomax then
    v.tempolevel = v.tempolevel + 1
    v.tempo = 0
    v.tempomax = v.tempomax * v.tempomaxboost
    v.tempodebt = 0
    v.tempoflashframe = math.max(GameGetFrameNum(), v.tempoflashframe)
end
GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))