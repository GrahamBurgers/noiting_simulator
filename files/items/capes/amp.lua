dofile_once("mods/noiting_simulator/files/items/capes/_capes.lua")
local cooldown = 20.0

local nextframe = tonumber(GlobalsGetValue("NS_CAPE_NEXT_FRAME", "-999"))
local frame = GameGetFrameNum()
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local controls = EntityGetFirstComponent(me, "ControlsComponent")

if controls and frame >= nextframe and ComponentGetValue2(controls, "mButtonFrameKick") == frame then
    CapeShoot(me, "mods/noiting_simulator/files/items/capes/amp.xml", x, y, cooldown, true)
end

Cape(me, "amp")