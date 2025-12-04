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
    heart = "mods/noiting_simulator/files/battles/dummy/_heart.png",
    arena = "mods/noiting_simulator/files/battles/dummy/_arena.png", arena_border = 12,
    size = 8, mass = 2, air_friction = 3,
    guard = 200, guardbonus = 400,
    cute = 1, charming = 1, clever = 1, comedic = 1.0,
    fire_multiplier = 1, burn_multiplier = 1,
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
    local me = GetUpdatedEntityID()
    local x, y = EntityGetTransform(me)
    V = v
    if tick == 1 then
        EntityLoad("mods/noiting_simulator/files/battles/dummy/dummy_stand.xml", x, y)
    end
end

return {DATA = DATA, ["DIALOGUE"] = DIALOGUE, ["LOGIC"] = LOGIC}