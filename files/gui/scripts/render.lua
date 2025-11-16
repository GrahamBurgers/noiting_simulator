local player = EntityGetWithTag("player_unit") or {}

dofile("mods/noiting_simulator/files/scripts/world_utils.lua")

if GameGetWorldStateEntity() > 0 and #player > 0 then
    dofile_once("mods/noiting_simulator/files/gui/scripts/text.lua")()
    dofile_once("mods/noiting_simulator/files/gui/scripts/inworld.lua")()
    dofile_once("mods/noiting_simulator/files/gui/scripts/battle.lua")()
end