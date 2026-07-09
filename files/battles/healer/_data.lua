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
    heart = path .. "_heart.png", heart_pieces = {{img = path .. "_shell_l.png", vx = -35, vy = 0}, {img = path .. "_shell_r.png", vx = 35, vy = 0}}, heart_inside = {{img = path .. "_inside.png", vx = 0, vy = -12}},
    arena = path .. "_arena.png", arena_border = 12,
    arena_back = path .. "_arena_back.png",
    size = 8, mass = 2, air_friction = 3,
    guard = 1200, guardbonus = 600,
    cute = 0.5, charming = 1, clever = 1.5, comedic = 1.0,
    fire_multiplier = 1, burn_multiplier = 1,
    tempogain = 0.2, tempomaxboost = 1.1, tempo_dmg_mult = 1.5, tempomax = 10,
}

ATTACKS = {
	["init"] = {
		next_valid_attacks = {"honey_slam"},
		func = function()
			Frame(60)
		end
	},
	["glomp"] = {
		next_valid_attacks = {"honey_slam"},
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
		next_valid_attacks = {"glomp"},
		func = function()
			Frame(5 , function() Move({target = "UP", speed = 35, flat = true}) end)
			Frame(10)
			Frame(5 , function() Move({target = "DOWN", speed = 30, flat = true}) end)
			Frame(90, function() Move({target = "DOWN", speed = 30, flat = true}) end, BOUNCED)
			Frame(1 , function() Shoot({target = "DOWN", count = 8, deg_between = 45, file = "mods/noiting_simulator/files/battles/healer/honey.xml"}) end)
			Frame(80)
		end
	},
}

DIALOGUE = {
    ["TempoUpCute"] = {"Heh, hey...! You’re just making yourself look silly, you know..."},
    ["TempoUpClever"] = {"O-oh! You’re a bit different than my coworkers, aren’t you...?"},
    ["TempoUpCharming"] = {""},
    ["TempoUpComedic"] = {""},
}

LOGIC = function(v)
    V = v
	BOUNCED = false
	local me = GetUpdatedEntityID()
	local proj = me and EntityGetFirstComponent(me, "ProjectileComponent")
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