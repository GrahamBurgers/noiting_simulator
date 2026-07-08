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
local tick_time = v.fire_tick_time or 60
local flame_cap = v.flame_cap or 3
local fire_decay_idle = v.fire_decay_idle or (1 / 2500)
local fire_decay_burning = v.fire_decay_burning or (1 / 600)
local on_fire = EntityGetFirstComponent(me, "VariableStorageComponent", "on_fire")
local fire_particles = EntityGetFirstComponent(me, "ParticleEmitterComponent", "on_fire")
local smoke_particles = EntityGetFirstComponent(me, "ParticleEmitterComponent", "smoke")
local bar_sprites = EntityGetComponentIncludingDisabled(me, "SpriteComponent", "firebar") or {}
if on_fire and fire_particles and smoke_particles and (#bar_sprites >= 2) and flame_cap > 0 then
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
        ComponentSetValue2(on_fire, "value_float", math.min(flame_cap, burn_time - fire_decay_burning))
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
        ComponentSetValue2(on_fire, "value_float", burn_time - fire_decay_idle)
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

local hearts = EntityGetWithTag("heart") or {me}
local heartcount = #(hearts)
local me_index = 0
for i = 1, #hearts do
	if hearts[i] == me then me_index = i end
end

dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
Victorytime = Victorytime or 0
if v.guard <= (v.damagemax or 0) and v.name ~= "dummy" then
	local x, y = EntityGetTransform(me)
	Victorytime = Victorytime + 1
	-- VICTORY ANIMATION
	local boom_time = 400 - ((me_index - 1) * 60)
	if Victorytime % 3 == 0 and Victorytime < boom_time then
		EntityLoad("data/entities/particles/particle_explosion/ember_trail.xml", x, y)
		EntityLoad("data/entities/particles/particle_explosion/explosion_trail_swirl_red_slow.xml", x, y)
	end
	if Victorytime == boom_time then
		EntityAddComponent2(me, "LifetimeComponent", {lifetime = 1})
		for i = 1, #v.heart_pieces do
			local piece = EntityLoad("mods/noiting_simulator/files/battles/heart_piece_physics.xml", x, y)
			local phys = EntityGetFirstComponent(piece, "PhysicsBodyComponent")
			if phys then
				ComponentSetValue2(phys, "mRefreshed", false)
				ComponentSetValue2(phys, "initial_velocity", v.heart_pieces[i].vx, v.heart_pieces[i].vy)
			end
			local img = EntityGetFirstComponent(piece, "PhysicsImageShapeComponent")
			if img then
				ComponentSetValue2(img, "image_file", v.heart_pieces[i].img)
			end
		end

		local ah = GuiCreate()
		for i = 1, #v.heart_inside do
			local inside = EntityLoad("mods/noiting_simulator/files/battles/heart_inside.xml", x, y)
			local w, h = GuiGetImageDimensions(ah, v.heart_inside[i].img)
			EntityAddComponent2(inside, "SpriteComponent", {
				image_file = v.heart_inside[i].img,
				offset_x = w / 2,
				offset_y = h / 2,
				emissive=true,
			})
			local vel = EntityAddComponent2(inside, "VelocityComponent", {
				air_friction=0,
				gravity_y=0,
			})
			local trail = EntityGetFirstComponentIncludingDisabled(inside, "SpriteParticleEmitterComponent")
			if trail then
				ComponentSetValue2(trail, "sprite_file", v.heart_inside[i].img)
			end
			ComponentSetValue2(vel, "mVelocity", v.heart_inside[i].vx, v.heart_inside[i].vy)
		end
		GuiDestroy(ah)
		GamePlaySound("data/audio/Desktop/explosion.bank", "explosions/magic_rocket_big", x, y)

		if me_index == 1 then
			v.persistent = v.persistent or {}
			v.persistent[v.name] = v.persistent[v.name] or {}
			v.persistent[v.name].damage = 0
			v.persistent[v.name].damagemax = v.damagemax
			v.persistent[v.name].dates_so_far = (v.persistent[v.name].dates_so_far or 0) + 1
			GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
			dofile_once("mods/noiting_simulator/files/items/_list.lua")
			CollectItems(true)
			CollectSpells(true, true)

			dofile_once("mods/noiting_simulator/files/scripts/gui_feed.lua")
			CallFeedMessage("battle_win")
		end
	end

	return
end

local stuns = EntityGetAllChildren(me, "heart_stun")
if stuns and #stuns > 0 then -- stop everything!
    local logic = EntityGetFirstComponent(me, "VariableStorageComponent", "logic_file")
    local logic_file = logic and ComponentGetValue2(logic, "value_string")
    if logic and logic_file then
        ComponentSetValue2(logic, "value_float", GameGetFrameNum() + 1)
    end
	return
end

-- TEMPO LOGIC
if v.name == "dummy" then
    v.tempo = 0
    v.damagemax = 0
    if v.guard <= 0 then v.guard = v.guardmax end
else
    v.tempo = v.tempo + ((v.tempogain / 60) / heartcount)
    if v.tempodebt > 0 then
        local amount = v.tempodebt / 400
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

-- ATTACK LOGIC
local logic = EntityGetFirstComponent(me, "VariableStorageComponent", "logic_file")
local logic_file = logic and ComponentGetValue2(logic, "value_string")
if logic and logic_file then
    -- thanks nathan for this code. i barely know how this works
    Tick = ComponentGetValue2(logic, "value_int")
	Tempo = v.tempolevel
    local l = dofile(logic_file)
    local next_do_time = ComponentGetValue2(logic, "value_float")
    if next_do_time <= 1 then next_do_time = GameGetFrameNum() end
    TEMPO_SCALE = 8 -- lower = faster

    local period = TEMPO_SCALE / math.max(1, (Tempo + TEMPO_SCALE))
    while next_do_time < GameGetFrameNum() do
        next_do_time = next_do_time + period
        Tick = Tick + 1
        l.LOGIC(v)
    end
    ComponentSetValue2(logic, "value_float", next_do_time)

    ComponentSetValue2(logic, "value_int", Tick)
end

GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))