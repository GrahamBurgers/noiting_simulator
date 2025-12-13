local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
local controls = EntityGetFirstComponent(owner, "ControlsComponent")
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = string.len(storage) > 0 and smallfolk.loads(storage)
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")

if not (proj and owner and controls and vel and v) then return end
ComponentSetValue2(vel, "air_friction", 1)

local magnitude = 20
local recoil_div = -1
local px, py = EntityGetTransform(owner)
py = py - 4
local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
local target_x, target_y = px + dx * magnitude, py + dy * magnitude
local dir = math.atan2(dy or 0, dx or 0)

x = x + (target_x - x) / 5
y = y + (target_y - y) / 5
EntitySetTransform(me, x, y, dir)

if ComponentGetValue2(controls, "mButtonDownThrow") then
    local vel2 = EntityGetFirstComponent(owner, "CharacterDataComponent")
    if vel2 then
        local vx, vy = ComponentGetValue2(vel2, "mVelocity")
        ComponentSetValue2(vel2, "mVelocity", vx + dx * (magnitude / recoil_div), vy + dy * (magnitude / recoil_div))
    end
    if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") % 3 == 0 then
        Shoot({file = "mods/noiting_simulator/files/spells/ult_cute_bubble.xml", stick_frames = 0, count = 1, deg_add = 180 + math.deg(math.pi - dir), deg_random_per = 5, whoshot = owner})
    end
end