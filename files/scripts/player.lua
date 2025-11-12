-- crouchy hitbox
local me = GetUpdatedEntityID()
local platform = EntityGetFirstComponentIncludingDisabled(me, "CharacterPlatformingComponent")
local hitbox = EntityGetFirstComponentIncludingDisabled(me, "HitboxComponent")
local hitbox_crouch = EntityGetFirstComponentIncludingDisabled(me, "HitboxComponent", "crouched")
if platform and hitbox and hitbox_crouch then
    if ComponentGetValue2(platform, "mShouldCrouch") then
        EntitySetComponentIsEnabled(me, hitbox, false)
        EntitySetComponentIsEnabled(me, hitbox_crouch, true)
    else
        EntitySetComponentIsEnabled(me, hitbox, true)
        EntitySetComponentIsEnabled(me, hitbox_crouch, false)
    end
end

-- camera
local cx, cy = tonumber(GlobalsGetValue("NS_CAM_X", "nil")), tonumber(GlobalsGetValue("NS_CAM_Y", "nil"))
local c = EntityGetFirstComponentIncludingDisabled(me, "PlatformShooterPlayerComponent")
if cx and cy and c then
    ComponentSetValue2(c, "mDesiredCameraPos", cx, cy)
end