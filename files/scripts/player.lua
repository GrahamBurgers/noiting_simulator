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
local cx, cy = tonumber(GlobalsGetValue("NS_CAM_X", "nil")) or 0, tonumber(GlobalsGetValue("NS_CAM_Y", "nil")) or 0
local tcx, tcy = tonumber(GlobalsGetValue("NS_CAM_X_TWEEN")) or cx, tonumber(GlobalsGetValue("NS_CAM_Y_TWEEN")) or cy
local c = EntityGetFirstComponentIncludingDisabled(me, "PlatformShooterPlayerComponent")
local ox = tonumber(GlobalsGetValue("NS_CAM_OVERRIDE_X", "nil"))
local oy = tonumber(GlobalsGetValue("NS_CAM_OVERRIDE_Y", "nil"))
if ox and oy and ox ~= "nil" and oy ~= "nil" then
    cx, cy = ox, oy
end
if cx and cy and c then
    tcx = tcx + (cx - tcx) / 10
    tcy = tcy + (cy - tcy) / 10
    GlobalsSetValue("NS_CAM_X_TWEEN", tostring(tcx))
    GlobalsSetValue("NS_CAM_Y_TWEEN", tostring(tcy))
    ComponentSetValue2(c, "mDesiredCameraPos", tcx, tcy)
end

-- undo any latency frames
local controls = EntityGetFirstComponentIncludingDisabled(me, "ControlsComponent")
local latency = controls and ComponentGetValue2(controls, "input_latency_frames")
if controls and latency and latency > 0 then
    ComponentSetValue2(controls, "input_latency_frames", latency - 1)
end