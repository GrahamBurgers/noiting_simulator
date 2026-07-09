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

local path = "mods/noiting_simulator/files/battles/assassin/"
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
		next_valid_attacks = {"swipe_combo"},
		tempo_min = -1, tempo_max = -1,
	},
	["swipe_combo"] = {
		next_valid_attacks = {"swipe_combo"},
		tempo_min = -1, tempo_max = -1,
		func = function()
			Frame(1 , function() Move({target = "PLAYER", speed = 225, flat = true}) Shoot({target = "PLAYER", displace_px = 15, file = "mods/noiting_simulator/files/battles/healer/swipe.xml"}) end)
			Frame(45)
			Frame(1 , function() Move({target = "PLAYER", speed = 225, flat = true}) Shoot({target = "PLAYER", displace_px = 15, file = "mods/noiting_simulator/files/battles/healer/swipe2.xml"}) end)
			Frame(45)
			Frame(1 , function() Move({target = "PLAYER", speed = 225, flat = true}) Shoot({target = "PLAYER", displace_px = 15, file = "mods/noiting_simulator/files/battles/healer/swipe.xml"}) end)
			Frame(60)
			Frame(1 , function() Move({target = "PLAYER", speed = 225, flat = true}) Shoot({target = "PLAYER", displace_px = 15, file = "mods/noiting_simulator/files/battles/healer/swipe3.xml"}) end)
			Frame(120)
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
	Do_attacks()
end

return {DATA = DATA, ["DIALOGUE"] = DIALOGUE, ["LOGIC"] = LOGIC}