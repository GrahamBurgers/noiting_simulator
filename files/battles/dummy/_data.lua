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

local path = "mods/noiting_simulator/files/battles/dummy/"
DATA = {
    heart = path .. "_heart.png",
    arena = path .. "_arena.png", arena_border = 12,
    arena_back = path .. "_arena_back.png",
    size = 8, mass = 2, air_friction = 3,
    guard = 100, guardbonus = 0,
    cute = 1, charming = 1, clever = 1, comedic = 1,
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

LOGIC = function(v)
    local me = GetUpdatedEntityID()
    local x, y = EntityGetTransform(me)
	local player = EntityGetClosestWithTag(x, y, "player_unit")
    V = v
    if Tick == 1 then
		EntitySetTransform(player, V.arena_x, y + 40)
        local a = EntityLoad("mods/noiting_simulator/files/battles/dummy/dummy_stand.xml", V.arena_x + 90, V.arena_y + 48)
		EntityAddChild(me, a)
        local b = EntityLoad("mods/noiting_simulator/files/spells/storage_box/storage_box.xml", V.arena_x - 90, V.arena_y + 48)
		EntityAddChild(me, b)
        local c = EntityLoad("mods/noiting_simulator/files/battles/dummy/item_storage.xml", V.arena_x - 100, V.arena_y + 73)
		EntityAddChild(me, c)
        local d = EntityLoad("mods/noiting_simulator/files/battles/dummy/tinker.xml", V.arena_x, V.arena_y)
		EntityAddChild(me, d)
        local e = EntityLoad("data/entities/buildings/workshop_spell_visualizer.xml", V.arena_x - 78, (V.arena_y - V.arena_h / 2) + 61)
		EntityAddChild(me, e)
        local f = EntityLoad("mods/noiting_simulator/files/battles/dummy/heal_station.xml", V.arena_x - 40, V.arena_y - 64)
		EntityAddChild(me, f)

        EntityLoad("mods/noiting_simulator/files/battles/dummy/maybe_a_wand.xml",   V.arena_x + 35,   V.arena_y - 54)
        EntityLoad("mods/noiting_simulator/files/battles/dummy/maybe_a_wand.xml",   V.arena_x + 54.5, V.arena_y - 54)
        EntityLoad("mods/noiting_simulator/files/battles/dummy/maybe_a_wand.xml",   V.arena_x + 74,   V.arena_y - 54)
        EntityLoad("mods/noiting_simulator/files/battles/dummy/maybe_a_wand.xml",   V.arena_x + 93.5, V.arena_y - 54)
        EntityLoad("mods/noiting_simulator/files/battles/dummy/reroll_station.xml", V.arena_x + 120,  V.arena_y - 54)
    end
end

return {DATA = DATA, ["DIALOGUE"] = DIALOGUE, ["LOGIC"] = LOGIC}