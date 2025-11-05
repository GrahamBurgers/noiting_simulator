--[[
size                        : Hitbox size of the heart (circular)
heart                       : Heart sprite filepath.
arena                       : Arena sprite terrain filepath.
guard                       : Max health of the heart
mass                        : Mass of the heart. Affects knockback and such
cute/charming/clever/comedic: Damage multipliers
tempogain                   : Tempo gained per second.
tempomax                    : Once tempo reaches tempo max, tempo level goes up by 1.
tempomaxboost               : Tempo max goes up by this multiplier each tempo level (multiplicative). 1.1 = +10%.
tempo_dmg_mult              : Multiplier for how much damage affects the tempo. 0.5 = 50%.
]]--
return {
    ["DEFAULT"] = {
        cute = 1.0, charming = 1.0, clever = 1.0, comedic = 1.0, fire_multiplier = 1, burn_multiplier = 1,
        tempomax = 10, tempogain = 1, tempomaxboost = 1.1, tempo_dmg_mult = 0.5,
        guard = 200, mass = 2, size = 8
    },
    ["Dummy"] = {
        heart = "mods/noiting_simulator/files/battles/hearts/test_dummy.png",
        arena = "mods/noiting_simulator/files/battles/arenas/default.png",
        cute = 1.0, charming = 1.0, clever = 1.0, comedic = 1.0,
        tempomax = 99999,
    },
    ["Parantajahiisi"] = {
        heart = "mods/noiting_simulator/files/battles/hearts/parantajahiisi.png",
        arena = "mods/noiting_simulator/files/battles/arenas/default.png",
        cute = 0.5, charming = 1, clever = 1.5, comedic = 1.0, tempomaxboost = 0.9,
        attacks = {}
    },
}