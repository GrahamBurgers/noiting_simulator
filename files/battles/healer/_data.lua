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

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", "{}"))
local v = string.len(storage) > 0 and smallfolk.loads(storage) or {}
V = V or v
Tempo = Tempo or v.tempolevel
Dates_so_far = v.dates_so_far
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
X, Y = X or x, Y or y

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
	dialogue = {
		start_battle = {
			{force = true, onlyif = Dates_so_far == 0, text = "O-oh, so you want to date me...?", text2 = "W-well, I... O-oh, gosh..."},
			{force = true, onlyif = Dates_so_far == 1, text = "W-well... Here we are again...", text2 = "This time, um... I'm prepared. I think."},
			{force = true, onlyif = Dates_so_far == 2, text = "W-wow... We're really doing this...", text2 = "L-let's go."},
		},
		victory = {
			{force = true, onlyif = Dates_so_far == 0, text = "W-wha--? You... really want to?", text2 = "Then, I-I guess we can... go on a date...!"},
			{force = true, onlyif = Dates_so_far == 1, text = "win 2"},
			{force = true, onlyif = Dates_so_far == 2, text = "win 3"},
		},
		player_downed = {
			{force = true, onlyif = Dates_so_far ~= 2, text = "O-oh... You need a breather...?", text2 = "I-it's okay... Don't overdo it...!"},
			{force = true, onlyif = Dates_so_far ~= 2, text = "H-hey...! Don't look so sad!", text2 = "I-I get tired too... s-sometimes..."},
			{force = true, onlyif = Dates_so_far ~= 2, text = "K-Knower...! A-are you hurt...?", text2 = "O-oh... I left my gun in the office..."},

			{force = true, onlyif = Dates_so_far == 2, text = "H-hey...! Get up, Knower!", text2 = "Y-you haven't worked so hard... just to..."},
		},
		tempoup = {
			{force = true, text = "win 1"},
			{force = true, text = "win 2"},
			{force = true, text = "win 3"},
		}
	}
}

local water_count = 12
function shoot_water()
	if #EntityGetWithTag("healer_flower") > 0 then
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
				local idk = ((V.arena_y - Y) - (V.arena_y - target_y)) / V.arena_h
				local high = 0.4 - (0.08 * idk) -- i hate this?
				local xv = -((X - target_x)) * high
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
			Frame(360)
		end
	},
	["glomp"] = {
		dialogue = {
			{chance = 25, text = "C'mere, c'mere..."},
			{chance = 25, text = "Oh, gosh... Can't hold back..."},
			{chance = 25, text = "Sweet...!!"},
		},
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
		dialogue = {
			{chance = 50, text = "O-oh... Is it getting hot in here, or...?"},
			{chance = 50, text = "H-hey... You're getting kinda close..."}
		},
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
		dialogue = {
			{chance = 50, text = "Need some space..."},
			{chance = 50, text = "U-uwa...!!"}
		},
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
		dialogue = {
			{chance = 25, text = "S-self-care, um... is important..."},
			{chance = 25, text = "O-oh, gosh... I need a minute..."},
			{chance = 25, text = "Mm... Snack break."},
		},
		onlyif = Tempo > 2 and V.guard < V.guardmax / 2,
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
		dialogue = {
			{force = true, text = "All those pretty flowers in the Park...", text2 = "I... I guess they're only alive because of me..."}
		},
		onlyif = Tempo > 4 and #EntityGetWithTag("healer_flower") == 0,
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
			Frame(90)
		end
	},
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