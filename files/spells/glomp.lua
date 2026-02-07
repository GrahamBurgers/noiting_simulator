local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local whoshot = proj and ComponentGetValue2(proj, "mWhoShot")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local cdc = whoshot and EntityGetFirstComponent(whoshot, "CharacterDataComponent")
if not (vel and cdc) then return end
local vx, vy = ComponentGetValue2(vel, "mVelocity")
local vx2, vy2 = ComponentGetValue2(cdc, "mVelocity")
vy2 = ComponentGetValue2(cdc, "is_on_ground") and 0 or vy2

local ratio = 0.8
vx, vy = vx * ratio,  vy * ratio
vx2, vy2 = vx2 * (1 - ratio), vy2 * (1 - ratio)

ComponentSetValue2(cdc, "mVelocity", vx2 + vx, vy2 + vy)
ComponentSetValue2(vel, "mVelocity", vx2 + vx, vy2 + vy)