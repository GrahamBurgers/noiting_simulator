local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
local controls = EntityGetFirstComponent(owner, "ControlsComponent")

if not (proj and owner and controls and vel) then return end

local vx, vy = ComponentGetValue2(vel, "mVelocity")
local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
local speed = 6 * (1.5 ^ ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame"))

ComponentSetValue2(vel, "mVelocity", vx + (dx * speed), vy + (dy * speed))