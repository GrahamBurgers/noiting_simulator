dofile_once("mods/noiting_simulator/files/items/capes/_capes.lua")
local cooldown = 3.0

local nextframe = tonumber(GlobalsGetValue("NS_CAPE_NEXT_FRAME", "-999"))
local frame = GameGetFrameNum()
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local controls = EntityGetFirstComponent(me, "ControlsComponent")

local go = 400
local divider = 5

if controls and frame >= nextframe and ComponentGetValue2(controls, "mButtonFrameKick") == frame then
    local vx, vy = 0, 0
    local power = 1
    if ComponentGetValue2(controls, "mButtonDownDown") then
        vy = vy + go
        power = power - 0.25
    end
    if ComponentGetValue2(controls, "mButtonDownUp") then
        vy = vy - go
        power = power - 0.25
    end
    if ComponentGetValue2(controls, "mButtonDownLeft") then
        vx = vx - go
        power = power - 0.25
    end
    if ComponentGetValue2(controls, "mButtonDownRight") then
        vx = vx + go
        power = power - 0.25
    end
    vx, vy = vx * power, vy * power
    local c = EntityGetFirstComponent(me, "CharacterDataComponent")
    if (vx ~= 0 or vy ~= 0) and power > 0 and c then
        ComponentSetValue2(c, "mVelocity", vx, vy)
        local dash = CapeShoot(me, "mods/noiting_simulator/files/items/capes/dash.xml", x, y, cooldown, true)
        local p = EntityGetFirstComponent(dash, "ProjectileComponent")
        if p then
            ComponentSetValue2(p, "direction_random_rad", vx / divider)
            ComponentSetValue2(p, "direction_nonrandom_rad", vy / divider)
        end
    end
end

Cape(me, "dash")