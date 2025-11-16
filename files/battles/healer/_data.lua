dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")

--[[
size                        : Hitbox size of the heart (circular)
mass                        : Mass of the heart. Affects knockback and such
guard                       : Max health of the heart
guardbonus                  : Gains this much bonus max health for each previous date you've had with them
cute/charming/clever/comedic: Damage multipliers
tempogain                   : Tempo gained per second.
tempomax                    : Once tempo reaches tempo max, tempo level goes up by 1.
tempomaxboost               : Tempo max goes up by this multiplier each tempo level (multiplicative). 1.1 = +10%.
tempo_dmg_mult              : Multiplier for how much damage received affects the tempo. 0.5 = 50%.
]]--

DATA = {
    heart = "mods/noiting_simulator/files/battles/healer/_heart.png",
    arena = "mods/noiting_simulator/files/battles/healer/_arena.png", arena_border = 12,
    size = 8, mass = 2, air_friction = 3,
    guard = 1200, guardbonus = 400,
    cute = 0.5, charming = 1, clever = 1.5, comedic = 1.0,
    fire_multiplier = 1, burn_multiplier = 1,
    tempogain = 0.2, tempomaxboost = 1.1, tempo_dmg_mult = 0.5, tempomax = 10,
}

DIALOGUE = {
    ["TempoUpCute"] = {"Heh, hey...! You’re just making yourself look silly, you know..."},
    ["TempoUpClever"] = {"O-oh! You’re a bit different than my coworkers, aren’t you...?"},
    ["TempoUpCharming"] = {""},
    ["TempoUpComedic"] = {""},
}

LOGIC = function(v, tick)
    V = v
    if tick % 400 < 200 then
        Movetopoint(0.8, 0.5, 12)
    else
        Movetopoint(0.2, 0.5, 12)
    end
    if tick % 15 == 0 then
        Shoot({file = "mods/noiting_simulator/files/spells/sparkle.xml", target = "DOWN", intro_frames = 60, count = 4, deg_add = 0, deg_between = 90, deg_random = 360})
    end
end

return {DATA = DATA, ["DIALOGUE"] = DIALOGUE, ["LOGIC"] = LOGIC}