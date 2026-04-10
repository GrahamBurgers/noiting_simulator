local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local owner = proj and ComponentGetValue2(proj, "mWhoShot")
local controls = EntityGetFirstComponent(owner, "ControlsComponent")
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")

local inv2comp = owner and EntityGetFirstComponentIncludingDisabled(owner, "Inventory2Component")
local activeitem = inv2comp and ComponentGetValue2(inv2comp, "mActiveItem")

local data = owner and EntityGetFirstComponentIncludingDisabled(owner, "CharacterDataComponent")
if not (proj and owner and controls and vel and data and activeitem) then return end
local vx, vy = ComponentGetValue2(data, "mVelocity")
local vx2, vy2 = ComponentGetValue2(vel, "mVelocity")
if ComponentGetValue2(data, "is_on_ground") then vy = 0 end

local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
local dir = math.atan2(dy or 0, dx or 0)

local ability = EntityGetFirstComponentIncludingDisabled(activeitem, "AbilityComponent")

if ability and (ComponentGetValue2(ability, "mCastDelayStartFrame") == GameGetFrameNum()) then -- eh?
	Shoot({file = "mods/noiting_simulator/files/spells/ult_cute_bubble.xml", target = -dir, count = 4, deg_random_per = 5, deg_add = 180, speed_random_per = 30, whoshot = owner, do_muzzle_flash = true})
	EntityAddTag(me, "ult_cute")
end

EntitySetTransform(me, x, y, dir)

vx = (vx2 * 0.8) + (vx * 0.2)
vy = (vy2 * 0.8) + (vy * 0.2)
ComponentSetValue2(vel, "mVelocity", vx, vy)