--[[
size                        : Hitbox size of the heart (circular)
mass                        : Mass of the heart. Affects knockback and such
guard                       : Max health of the heart
guardbonus                  : Gains this much bonus max health for each previous date you've had with them

cute/charming/clever/comedic: Damage multipliers

tempogain                   : Tempo gained per second.
tempomax                    : Once tempo reaches tempo max, tempo level goes up by 1.
tempomaxboost               : Tempo max goes up by this multiplier each tempo level (multiplicative). 1.1 = +10%
tempo_dmg_mult              : Multiplier for how much damage received affects the tempo. 0.5 = 50%

fire_multiplier             : Fire tick damage multiplier
burn_multiplier             : Multiplier towards increasing the burn bar
fire_decay_idle             : Burn bar decrease over time when not burning. Default 0.0005
fire_decay_burning          : Burn bar decrease over time when burning. Default 0.0025
fire_tick_time              : Frames between each fire tick. Default 60
flame_cap                   : Burn bar upper limit. Default 3
]]--

local path = "mods/noiting_simulator/files/battles/healer/"
DATA = {
    heart = path .. "_heart.png",
	heart_pieces = {
		{img = path .. "_shell_l.png", vx = -35, vy = 0},
		{img = path .. "_shell_r.png", vx = 35, vy = 0},
		{img = path .. "_shell_c.png", vx = 0, vy = -15},
	},
	heart_inside = {
		{img = path .. "_inside.png", vx = 0, vy = -12},
	},
    arena = path .. "_arena.png", arena_border = 12,
    arena_back = path .. "_arena_back.png",
    size = 8, mass = 2, air_friction = 3,
    guard = 1200, guardbonus = 600,
    cute = 0.5, charming = 1, clever = 1.5, comedic = 1.0,
    fire_multiplier = 1, burn_multiplier = 1,
    tempogain = 0.15, tempomaxboost = 1.2, tempo_dmg_mult = 1, tempomax = 10,
}

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
V = V or v
Tempo = Tempo or v.tempolevel
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
X, Y = X or x, Y or y

local water_count = 12
function shoot_water()
	if #EntityGetWithTag("healer_flower") > 0 then
		x, y = EntityGetTransform(me)
		local indices = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
		local target_y = V.arena_y + V.arena_h / 2
		local count = 1
		for q = 1, count do
			local ind = Random(1, #indices)
			local index = indices[ind]
			table.remove(indices, ind)
			local target_x = V.arena_x + (V.arena_w * ((index / water_count) - 0.5) - (V.arena_w * ((1 / water_count)) * 0.5))

			local e = Shoot({target = "UP", count = 1, dont_apply_tempo = true, file = "mods/noiting_simulator/files/battles/healer/water_drop.xml"})[1]

			local vel = EntityGetFirstComponentIncludingDisabled(e, "VelocityComponent")
			if vel then
				local idk = ((V.arena_y - y) - (V.arena_y - target_y)) / V.arena_h
				local high = 0.4 - (0.08 * idk) -- i hate this?
				local xv = -((x - target_x)) * high
				local _, yv = ComponentGetValue2(vel, "mVelocity")
				ComponentSetValue2(vel, "mVelocity", xv, yv)
			end
		end
	end
end

ATTACKS = {
	["init"] = {
		next_valid_attacks = {"honey_slam"},
		func = function()
			Frame(60)
		end
	},
	["glomp"] = {
		next_valid_attacks = {"honey_slam", "plant_seeds"},
		func = function()
			Frame(1 , function() Shoot({target = "PLAYER", stick_frames = 25, file = "mods/noiting_simulator/files/spells/glomp.xml"}) end)
			Frame(60)
			Frame(1 , function() Shoot({target = "PLAYER", stick_frames = 25, file = "mods/noiting_simulator/files/spells/glomp.xml"}) end)
			Frame(60)
			Frame(1 , function() Shoot({target = "PLAYER", stick_frames = 25, count = 2, deg_between = 35, file = "mods/noiting_simulator/files/spells/glomp.xml"}) end)
			Frame(60)
		end
	},
	["honey_slam"] = {
		next_valid_attacks = {"glomp", "fireball", "plant_seeds", "backstep"},
		func = function()

			Frame(2 , function() Move({target = "UP", speed = 90, flat = true}) end)
			Frame(10)
			Frame(5 , function() Move({target = "DOWN", speed = 30, flat = true}) end)
			Frame(90, function() Move({target = "DOWN", speed = 30, flat = true}) end, BOUNCED)
			Frame(1 , function() Shoot({target = "DOWN", count = 8, file = "mods/noiting_simulator/files/battles/healer/honey.xml"}) end)
			Frame(1, function() shoot_water() end)
			Frame(80)
		end
	},
	["fireball"] = {
		next_valid_attacks = {"glomp", "fireball", "line", "plant_seeds", "backstep"},
		func = function()
			local safe_x = V.arena_x + (V.arena_w * (Random(-25, 25) / 100))
			local safe_y = V.arena_y + (V.arena_h * (Random(-25, 25) / 100))

			Frame(1, function()
				EntityLoad("mods/noiting_simulator/files/battles/healer/fireball_warn.xml", safe_x, safe_y)
				if Tempo > 2 then
					Frame(1, function() Shoot({target = "RANDOM", count = 12, stick_frames = 90, stick_to_shoot_position = true, file = "mods/noiting_simulator/files/battles/healer/square.xml"}) end)
				end
			end)
			Frame(20)
			Frame(50, function()
				Move({target = {x = safe_x, y = safe_y, raw = true}, speed = 15})
			end)
			Frame(1, function()
				Shoot({x = safe_x, y = safe_y, target = "RANDOM", count = 32, displace_px = -400, file = "mods/noiting_simulator/files/battles/healer/fireball.xml"})
			end)
			Frame(100, function()
				Move({target = {x = safe_x, y = safe_y, raw = true}, speed = 5})
			end)
			Frame(1, function() shoot_water() end)
			Frame(100)
		end
	},
	["backstep"] = {
		onlyif = Tempo > 1 and #EntityGetInRadiusWithTag(x, y, 48, "player_unit") > 0,
		next_valid_attacks = {"glomp", "fireball", "plant_seeds", "backstep"},
		func = function()
			Frame(1 , function() Shoot({target = "PLAYER", deg_add = 180, stick_frames = 45, file = "mods/noiting_simulator/files/spells/glomp.xml"}) end)
			Frame(45)
			Frame(1 , function() Shoot({target = "PLAYER", deg_add = 180, stick_frames = 45, file = "mods/noiting_simulator/files/spells/glomp.xml"}) end)
			Frame(90)
			Frame(90, function() Move({target = "UP", speed = 10, flat = true}) end, BOUNCED)
			Frame(1 , function() Shoot({target = "UP", count = 8, file = "mods/noiting_simulator/files/battles/healer/honey.xml"}) end)
			Frame(8)
			Frame(1, function() shoot_water() end)
			Frame(12)
		end
	},
	["line"] = {
		only_if = Tempo > 2,
		next_valid_attacks = {"glomp", "fireball", "plant_seeds", "backstep"},
		func = function()
			local target_x, attack_direction
			if X < V.arena_x then
				target_x = (V.arena_x + V.arena_w / 2) - 8
				attack_direction = "LEFT"
			else
				target_x = (V.arena_x - V.arena_w / 2) + 8
				attack_direction = "RIGHT"
			end
			local target_y = V.arena_y + (V.arena_h * (Random(-45, 45) / 100))
			local fraction =     1 / 5
			Frame(1 , function() Shoot({x = X + (target_x - X) * fraction, y = Y + (target_y - Y) * fraction, target = "DOWN", count = 1, file = "mods/noiting_simulator/files/battles/healer/heal_heart.xml"}) end)
			Frame(20) fraction = 2 / 5
			Frame(1 , function() Shoot({x = X + (target_x - X) * fraction, y = Y + (target_y - Y) * fraction, target = "DOWN", count = 1, file = "mods/noiting_simulator/files/battles/healer/heal_heart.xml"}) end)
			Frame(20) fraction = 3 / 5
			Frame(1 , function() Shoot({x = X + (target_x - X) * fraction, y = Y + (target_y - Y) * fraction, target = "DOWN", count = 1, file = "mods/noiting_simulator/files/battles/healer/heal_heart.xml"}) end)
			Frame(20) fraction = 4 / 5
			Frame(1 , function() Shoot({x = X + (target_x - X) * fraction, y = Y + (target_y - Y) * fraction, target = "DOWN", count = 1, file = "mods/noiting_simulator/files/battles/healer/heal_heart.xml"}) end)
			Frame(20) fraction = 5 / 5
			Frame(1 , function() Shoot({x = X + (target_x - X) * fraction, y = Y + (target_y - Y) * fraction, target = "DOWN", count = 1, file = "mods/noiting_simulator/files/battles/healer/heal_heart.xml"}) end)
			Frame(120)
			Frame(1, function() shoot_water() end)
			Frame(2, function()
				Move({target = {x = target_x, y = target_y, raw = true}, speed = -90, flat = true})
			end)
			Frame(30, function()
				Move({target = {x = target_x, y = target_y, raw = true}, speed = 25})
			end)
			Frame(90, function()
				Move({target = {x = target_x, y = target_y, raw = true}, speed = 25})
			end, BOUNCED)
			Frame(1 , function() Shoot({target = attack_direction, count = 6, deg_between = 180 / 6, file = "mods/noiting_simulator/files/battles/healer/honey.xml"}) end)
			Frame(80)
		end
	},
	["plant_seeds"] = {
		only_if = Tempo > 4 and #EntityGetWithTag("healer_flower") == 0,
		next_valid_attacks = {"glomp", "fireball", "spawn_honey_pipe"},
		func = function()
			Frame(120, function()
				Move({target = {x = 0.5, y = 0.5}, speed = 4})
			end)
			local duration = 180
			local divider = duration / water_count
			Frame(duration, function()
				if ((This_tick % divider) > ((This_tick + 1) % divider)) then
					local index = math.ceil(This_tick / divider)
					local e = Shoot({target = "UP", count = 1, file = "mods/noiting_simulator/files/battles/healer/flower.xml"})[1]
					local f = EntityGetFirstComponent(e, "LuaComponent", "flowery")
					if f then
						ComponentSetValue2(f, "limit_how_many_times_per_frame", V.arena_x + (V.arena_w * ((index / water_count) - 0.5) - (V.arena_w * ((1 / water_count)) * 0.5)))
						ComponentSetValue2(f, "limit_to_every_n_frame", V.arena_y + V.arena_h / 2)
					end
				end
			end)
		end
	},
}

DIALOGUE = {
    ["TempoUpCute"] = {"Heh, hey...! You’re just making yourself look silly, you know..."},
    ["TempoUpClever"] = {"O-oh! You’re a bit different than my coworkers, aren’t you...?"},
    ["TempoUpCharming"] = {""},
    ["TempoUpComedic"] = {""},
}

LOGIC = function(v2)
    V = v2
	BOUNCED = false
	Me = GetUpdatedEntityID()
	local proj = Me and EntityGetFirstComponent(Me, "ProjectileComponent")
	if proj then
		local bounces_left = ComponentGetValue2(proj, "bounces_left")
		Last_bounces = Last_bounces or bounces_left
		if bounces_left < Last_bounces then
			BOUNCED = true
		end
		Last_bounces = bounces_left
	end
	Do_attacks()
end

return {DATA = DATA, ["DIALOGUE"] = DIALOGUE, ["LOGIC"] = LOGIC}