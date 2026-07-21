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
	local player = EntityGetClosestWithTag(x, y, "player_unit")
	local controls = EntityGetIsAlive(player) and EntityGetFirstComponent(player, "ControlsComponent")
	local controls2 = EntityGetIsAlive(player) and EntityGetFirstComponent(player, "ControlsComponent", "read_me_please")
	if controls and controls2 then
		ComponentSetValue2(controls, "enabled", false)
		for q, j in pairs(ComponentGetMembers(controls) or {}) do -- disable all that can be
			if q:sub(1, 11) == "mButtonDown" and q:sub(1, 16) ~= "mButtonDownDelay" then
				ComponentSetValue2(controls, q, false)
			end
		end
		local real_inputs = {
			ck = ComponentGetValue2(controls2, "mButtonDownFire"),
			rk = ComponentGetValue2(controls2, "mButtonDownThrow"),
			left = ComponentGetValue2(controls2, "mButtonDownLeft"),
			right = ComponentGetValue2(controls2, "mButtonDownRight"),
			up = ComponentGetValue2(controls2, "mButtonDownUp"),
			down = ComponentGetValue2(controls2, "mButtonDownDown"),
			fly = ComponentGetValue2(controls2, "mButtonDownFly"),
			kick = ComponentGetValue2(controls2, "mButtonDownKick"),
		}
		if real_inputs.left then
			Move({target = "LEFT", speed = 5, flat = true})
		end
		if real_inputs.right then
			Move({target = "RIGHT", speed = 5, flat = true})
		end
		if real_inputs.up then
			Move({target = "UP", speed = 5, flat = true})
		end
		if real_inputs.down then
			Move({target = "DOWN", speed = 5, flat = true})
		end
		ComponentSetValue2(controls, "mButtonDownLeft", new_inputs.left or false)
		ComponentSetValue2(controls, "mButtonDownRight", new_inputs.right or false)
		ComponentSetValue2(controls, "mButtonDownUp", new_inputs.up or false)
		ComponentSetValue2(controls, "mButtonDownDown", new_inputs.down or false)
		ComponentSetValue2(controls, "mButtonDownFire", new_inputs.ck or false)
		ComponentSetValue2(controls, "mButtonDownFly", new_inputs.fly or false)
		ComponentSetValue2(controls, "mButtonDownThrow", new_inputs.rk or false)
		ComponentSetValue2(controls, "mButtonDownKick", new_inputs.kick or false)
		ComponentSetValue2(controls, "mMousePosition", x + 90, y)
		ComponentSetValue2(controls, "mMousePositionRaw", x + 90, y)
		ComponentSetValue2(controls, "mMousePositionRawPrev", x + 90, y)
		ComponentSetValue2(controls, "mAimingVector", 1, 0)
		ComponentSetValue2(controls, "mAimingVectorNormalized", 1, 0)
	end
end


ATTACKS = {
	["init"] = {
		next_valid_attacks = {"init"},
		func = function()
			Frame(30, function() control_player({right = true}) end)
			Frame(30, function() control_player({left = true}) end)
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