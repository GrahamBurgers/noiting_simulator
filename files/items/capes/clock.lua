dofile_once("mods/noiting_simulator/files/items/capes/_capes.lua")
local cooldown = 15.0

local nextframe = tonumber(GlobalsGetValue("NS_CAPE_NEXT_FRAME", "-999"))
local frame = GameGetFrameNum()
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local controls = EntityGetFirstComponent(me, "ControlsComponent")

if controls and frame >= nextframe and ComponentGetValue2(controls, "mButtonFrameKick") == frame then
    CapeShoot(me, "mods/noiting_simulator/files/items/capes/clock.xml", x, y - 40, cooldown)
end

Cape(me, "clock")