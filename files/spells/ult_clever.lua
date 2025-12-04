local count = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
count = math.floor(count / 3)
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
-- todo: spawn tempo return orbs
Shoot({file = "mods/noiting_simulator/files/spells/ult_clever_tempoball.xml", stick_frames = 0, count = count, deg_add = 0, deg_between = 360 / count, deg_random = 360})