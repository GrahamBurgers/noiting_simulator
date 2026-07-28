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

local path = "mods/noiting_simulator/files/battles/kummitus/"
DATA = {
    heart = path .. "_heart.png",
	heart_pieces = {
	},
	heart_inside = {
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

local function control_player(new_inputs)
	x, y = EntityGetTransform(me)
	local who = EntityGetClosestWithTag(x, y, "player_dummy")
	local dir = 0
	if who == 0 then who = EntityGetClosestWithTag(x, y, "player_unit") end
	if EntityGetIsAlive(who) then
		local x2, y2 = EntityGetTransform(who)
		y2 = y2 - 4
		dir = math.rad(180) + math.atan2((y2 - y), (x2 - x))
	end
	new_inputs.aim_angle = dir
	local inputs = dofile_once("mods/noiting_simulator/files/scripts/player_inputs.lua")(new_inputs)
	if inputs.left then
		Move({target = "LEFT", speed = 5, flat = true})
	end
	if inputs.right then
		Move({target = "RIGHT", speed = 5, flat = true})
	end
	if inputs.up then
		Move({target = "UP", speed = 5, flat = true})
	end
	if inputs.down then
		Move({target = "DOWN", speed = 5, flat = true})
	end
end


ATTACKS = {
	["init"] = {
		next_valid_attacks = {"go"},
		func = function()
			Frame(5)
		end
	},
	["go"] = {
		next_valid_attacks = {"go"},
		func = function()
			local who = EntityGetClosestWithTag(x, y, "player_dummy")
			local move_right, move_left, fly, fire = false, false, false, false
			if who == 0 then who = EntityGetClosestWithTag(x, y, "player_unit") end
			if EntityGetIsAlive(who) then
				local x2, y2 = EntityGetTransform(who)
				local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
				if X < x2 - 20 then
					move_left = true
				elseif X > x2 + 20 then
					move_right = true
				end
				if distance < 110 and Y < y2 - 10 then
					fly = true
				end
				if distance < 90 and Random(1, 10) == 1 then
					fire = true
				end
			end
			Frame(1, function() control_player({right = move_right, left = move_left, fly = fly, fire = fire}) end)
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