local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
local controls = EntityGetFirstComponent(owner, "ControlsComponent")

if not (proj and owner and controls and vel) then return end
local x, y = EntityGetTransform(me)
local closest = EntityGetClosestWithTag(x, y, "heart")
if not EntityGetIsAlive(closest) then return end
local x2, y2 = EntityGetTransform(closest)
local dir = math.atan2((y2 - y), (x2 - x))

local vx, vy = ComponentGetValue2(vel, "mVelocity")
local speed = 6 * (1.5 ^ ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame"))

ComponentSetValue2(vel, "mVelocity", vx + (math.cos(dir) * speed) / 6, vy + (math.sin(dir) * speed) / 6)