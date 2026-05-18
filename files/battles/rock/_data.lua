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

DATA = {
    heart = "mods/noiting_simulator/files/battles/rock/_heart.png",
    arena = "mods/noiting_simulator/files/battles/rock/_arena.png", arena_border = 12,
    arena_back = "mods/noiting_simulator/files/battles/dummy/_arena_back.png",
    size = 8, mass = 90, air_friction = 3,
    guard = 100, guardbonus = 0,
    cute = 0, charming = 0, clever = 0, comedic = 0,
    fire_multiplier = 0, burn_multiplier = 0, flame_cap = 0,
    tempogain = 0, tempomaxboost = 1, tempo_dmg_mult = 0, tempomax = 10,
}

DIALOGUE = {
    ["EnterBattle"] = "Click on any UI element to learn more about it.",
    ["Cute"]        = "CUTE damage will deal bonus damage if the opponent is below 25% or above 75% CHARM!",
    ["Charming"]    = "CHARMING damage will temporarily increase your opponent's other damage multipliers!",
    ["Clever"]      = "CLEVER damage will temporarily decrease the TEMPO of the battle!",
    ["Comedic"]     = "COMEDIC damage will restore your health. But missing will hurt!",
    ["Guard"]       = "Use SPELLS to increase CHARM! Once CHARM reaches max, you succeed!",
    ["Tempo"]       = "TEMPO measures the intensity of the encounter!",
}

LOGIC = function(v, tick)
end

return {DATA = DATA, ["DIALOGUE"] = DIALOGUE, ["LOGIC"] = LOGIC}