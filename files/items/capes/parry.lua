dofile_once("mods/noiting_simulator/files/items/capes/_capes.lua")

local nextframe = tonumber(GlobalsGetValue("NS_CAPE_NEXT_FRAME", "-999"))
local frame = GameGetFrameNum()
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local controls = EntityGetFirstComponent(me, "ControlsComponent")

if controls and frame >= nextframe and ComponentGetValue2(controls, "mButtonFrameKick") == frame then
    nextframe = frame + 240
    GlobalsSetValue("NS_CAPE_NEXT_FRAME", tostring(nextframe))
    local parry = EntityLoad("mods/noiting_simulator/files/items/capes/parry.xml", x, y)
    EntityAddChild(me, parry)
end

Cape(me, "parry")