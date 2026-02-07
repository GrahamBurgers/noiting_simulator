local player = EntityGetWithTag("player_unit") or {}

dofile("mods/noiting_simulator/files/scripts/world_utils.lua")

if GameGetWorldStateEntity() > 0 and #player > 0 then
	local imgs = dofile_once("mods/noiting_simulator/files/scripts/gui_images.lua")
    dofile_once("mods/noiting_simulator/files/scripts/gui_text.lua")()
    dofile_once("mods/noiting_simulator/files/scripts/gui_inworld.lua")()
    dofile_once("mods/noiting_simulator/files/scripts/gui_battle.lua")()
	imgs()
end