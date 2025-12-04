local me = GetUpdatedEntityID()
local x, y, dir = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
local controls = EntityGetFirstComponent(owner, "ControlsComponent")
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = string.len(storage) > 0 and smallfolk.loads(storage)
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")

if not (proj and owner and controls and vel and v) then return end

local x2, y2 = EntityGetTransform(owner)
local target_x, target_y = v.arena_x + (v.arena_x - x2), v.arena_y + (v.arena_y - y2)
x = x + (target_x - x) / 20
y = y + (target_y - y) / 20
ComponentSetValue2(vel, "air_friction", 0)
dir = math.atan2((y2 - y), (x2 - x))
EntitySetTransform(me, x, y, dir)

if ComponentGetValue2(controls, "mButtonDownThrow") and ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") % 3 == 0 then
    Shoot({file = "mods/noiting_simulator/files/spells/ult_cute_bubble.xml", stick_frames = 0, count = 1, deg_add = 180 + math.deg(math.pi - dir), deg_random_per = 5, whoshot = owner})
end