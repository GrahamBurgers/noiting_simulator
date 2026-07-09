local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local whoshot = proj and ComponentGetValue2(proj, "mWhoShot")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local vel2 = whoshot and EntityGetFirstComponent(whoshot, "VelocityComponent")
if not (vel and vel2) then return end
local vx2, vy2 = ComponentGetValue2(vel2, "mVelocity")

if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") == 1 then
	GamePlaySound("data/audio/Desktop/animals.bank", "animals/assassin/attack_melee", x, y)
end
ComponentSetValue2(vel, "mVelocity", vx2, vy2)