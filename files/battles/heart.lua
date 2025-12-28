local me = GetUpdatedEntityID()
local dmg = EntityGetFirstComponentIncludingDisabled(me, "DamageModelComponent")
if not dmg then return end

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = string.len(storage) > 0 and smallfolk.loads(storage)
if (not v) or GlobalsGetValue("NS_BATTLE_DEATHFRAME", "0") ~= "0" then
    -- pause logic
    local logic = EntityGetFirstComponent(me, "VariableStorageComponent", "logic_file")
    local logic_file = logic and ComponentGetValue2(logic, "value_string")
    if logic and logic_file then
        ComponentSetValue2(logic, "value_float", GameGetFrameNum() + 60)
    end
    return
end

-- Fire
local tick_time = 60
local flame_cap = 3
local on_fire = EntityGetFirstComponent(me, "VariableStorageComponent", "on_fire")
local fire_particles = EntityGetFirstComponent(me, "ParticleEmitterComponent", "on_fire")
local smoke_particles = EntityGetFirstComponent(me, "ParticleEmitterComponent", "smoke")
local bar_sprites = EntityGetComponentIncludingDisabled(me, "SpriteComponent", "firebar") or {}
if on_fire and fire_particles and smoke_particles and (#bar_sprites >= 2) then
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
	local bar_percent = (burn_time + 1) / (flame_cap + 1)
	local threshold_percent = 1 / (flame_cap + 1)
    if (burn_time > 0 or (burn_time > -1 and is_burning)) and type ~= "NONE" then
        ComponentSetValue2(dmg, "is_on_fire", true)
        ComponentSetValue2(dmg, "mFireFramesLeft", 2)
        ComponentSetValue2(on_fire, "value_bool", true)
        ComponentSetValue2(fire_particles, "is_emitting", true)
        ComponentSetValue2(smoke_particles, "is_emitting", true)
		EntitySetComponentsWithTagEnabled(me, "firebar", true)
		ComponentSetValue2(bar_sprites[2], "special_scale_y", -bar_percent)
		ComponentSetValue2(bar_sprites[2], "offset_y", 8 / bar_percent)
		ComponentSetValue2(bar_sprites[3], "special_scale_y", 0)
		ComponentSetValue2(bar_sprites[4], "special_scale_y", 0)
        -- flame cap: 5
        ComponentSetValue2(on_fire, "value_float", math.min(flame_cap, burn_time - 0.003))
        if burn_tick <= 0 then
            ComponentSetValue2(on_fire, "value_int", tick_time)
            dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
            local burn_perk = tonumber(GlobalsGetValue("PERK_PICKED_BURNING_PICKUP_COUNT", "0")) or 0
            local fire_multiplier = 1 + (0.2 * burn_perk) * v.fire_multiplier
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
		EntitySetComponentsWithTagEnabled(me, "firebar", true)
		ComponentSetValue2(bar_sprites[2], "special_scale_y", 0)
		ComponentSetValue2(bar_sprites[3], "offset_y", 8 / bar_percent)
		ComponentSetValue2(bar_sprites[3], "special_scale_y", -bar_percent)
		ComponentSetValue2(bar_sprites[4], "offset_y", 8 / threshold_percent)
		ComponentSetValue2(bar_sprites[4], "special_scale_y", -threshold_percent)
        ComponentSetValue2(on_fire, "value_int", tick_time)
        ComponentSetValue2(on_fire, "value_float", burn_time - 0.001)
    else
        ComponentSetValue2(fire_particles, "is_emitting", false)
        ComponentSetValue2(smoke_particles, "is_emitting", false)
		EntitySetComponentsWithTagEnabled(me, "firebar", false)
        ComponentSetValue2(on_fire, "value_int", tick_time)
        ComponentSetValue2(on_fire, "value_bool", false)
    end
end

storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
v = string.len(storage) > 0 and smallfolk.loads(storage)
if not v then return end

-- TEMPO LOGIC
local hearts = EntityGetWithTag("heart") or {me}
local heartcount = #(hearts)
local primary = hearts[1] == me
if v.name == "dummy" then
    v.tempo = 0
    v.damagemax = 0
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
    local regen_perk = tonumber(GlobalsGetValue("PERK_PICKED_REGEN_PICKUP_COUNT", "0")) or 0
    local players = EntityGetWithTag("player_unit")
    for i = 1, #players do
        local dmg2 = EntityGetFirstComponent(players[i], "DamageModelComponent")
        if dmg2 and regen_perk > 0 then
            local x, y = EntityGetTransform(players[i])
            EntityLoad("data/entities/particles/heal_effect.xml", x, y)
            ComponentSetValue2(dmg2, "max_hp", ComponentGetValue2(dmg2, "max_hp") + 0.2 * regen_perk)
        end
    end
end

dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
-- ATTACK LOGIC
local logic = EntityGetFirstComponent(me, "VariableStorageComponent", "logic_file")
local logic_file = logic and ComponentGetValue2(logic, "value_string")
if logic and logic_file then
    -- thanks nathan for this code. i barely know how this works
    local tick = ComponentGetValue2(logic, "value_int")
    local l = dofile(logic_file)
    local next_do_time = ComponentGetValue2(logic, "value_float")
    if next_do_time <= 1 then next_do_time = GameGetFrameNum() end
    TEMPO_SCALE = 6

    local period = TEMPO_SCALE / math.max(1, (v.tempolevel + TEMPO_SCALE))
    while next_do_time < GameGetFrameNum() do
        next_do_time = next_do_time + period
        tick = tick + 1
        l.LOGIC(v, tick)
    end
    ComponentSetValue2(logic, "value_float", next_do_time)

    ComponentSetValue2(logic, "value_int", tick)
end

GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))