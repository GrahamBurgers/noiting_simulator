-- crouchy hitbox
local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local platform = EntityGetFirstComponentIncludingDisabled(me, "CharacterPlatformingComponent")
local hitbox = EntityGetFirstComponentIncludingDisabled(me, "HitboxComponent")
local hitbox_crouch = EntityGetFirstComponentIncludingDisabled(me, "HitboxComponent", "crouched")
local alpha = 1
if platform and hitbox and hitbox_crouch then
	if #(EntityGetWithTag("phase") or {}) > 0 then
        EntitySetComponentIsEnabled(me, hitbox, false)
        EntitySetComponentIsEnabled(me, hitbox_crouch, false)
		alpha = 0.5
	elseif ComponentGetValue2(platform, "mShouldCrouch") then
        EntitySetComponentIsEnabled(me, hitbox, false)
        EntitySetComponentIsEnabled(me, hitbox_crouch, true)
    else
        EntitySetComponentIsEnabled(me, hitbox, true)
        EntitySetComponentIsEnabled(me, hitbox_crouch, false)
    end
end
local sprites = EntityGetComponent(me, "SpriteComponent") or {}
for i = 1, #sprites do
	ComponentSetValue2(sprites[i], "alpha", alpha)
end

-- no kicking when already kicking
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "character")
local kick = EntityGetFirstComponentIncludingDisabled(me, "KickComponent")
if sprite and kick then
	local anim = ComponentGetValue2(sprite, "rect_animation")
	local can_kick = anim ~= "kick" and anim ~= "kick_alt" and anim ~= "kick_crouched" and anim ~= "kick_alt_crouched"
	ComponentSetValue2(kick, "can_kick", can_kick)
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

-- butterflies
local dmg = EntityGetFirstComponentIncludingDisabled(me, "DamageModelComponent")
local data = EntityGetFirstComponentIncludingDisabled(me, "CharacterDataComponent")
local lev = data and ComponentGetValue2(data, "mFlyingTimeLeft")
local butterflies = tonumber(GlobalsGetValue("SPELL_BUTTERFLIES_COUNT", "0")) or 0
if butterflies > 0 and data and lev and dmg and ComponentGetValue2(data, "mFlyingTimeLeft") <= 0 then
	SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
	GameCreateCosmeticParticle("magic_gas_polymorph", x, y, 1, Random(-20, 20), 12, nil, 1.5, 2, true, false, false, false, 0, -40)
	local cost = 1 / 120 * (0.5 ^ (butterflies - 1))
	ComponentSetValue2(dmg, "hp", math.max(0.04, ComponentGetValue2(dmg, "hp") - cost))
	ComponentSetValue2(data, "mFlyingTimeLeft", 0.001)
end

-- logger
local log_spells = tonumber(GlobalsGetValue("NS_LOG_SPELLS", "0"))
local log_items = tonumber(GlobalsGetValue("NS_LOG_ITEMS", "0"))
if log_spells > 0 then
	if log_spells == 1 then
		GamePrint("$ns_log_spells_1")
	else
		GamePrint(GameTextGet("$ns_log_spells", tostring(log_spells)))
	end
	GlobalsSetValue("NS_LOG_SPELLS", "0")
end
if log_items > 0 then
	if log_items == 1 then
		GamePrint("$ns_log_items_1")
	else
		GamePrint(GameTextGet("$ns_log_items", tostring(log_items)))
	end
	GlobalsSetValue("NS_LOG_ITEMS", "0")
end

--[[
-- sum all mana
local inv = EntityGetWithName("inventory_quick")
local mana, mana_max, mana_chg = 0, 0, 0
local wands = EntityGetAllChildren(inv, "wand") or {}
local abilities = {}
for i = 1, #wands do
	abilities[#abilities+1] = EntityGetFirstComponentIncludingDisabled(wands[i], "AbilityComponent")
end
for i = 1, #abilities do
	mana = mana + ComponentGetValue2(abilities[i], "mana")
	mana_max = mana_max + ComponentGetValue2(abilities[i], "mana_max")
	mana_chg = mana_chg + ComponentGetValue2(abilities[i], "mana_charge_speed")
end
for i = 1, #abilities do
	ComponentSetValue2(abilities[i], "mana", mana / #abilities)
	ComponentSetValue2(abilities[i], "mana_max", mana_max / #abilities)
	ComponentSetValue2(abilities[i], "mana_charge_speed", mana_chg / #abilities)
end
]]--