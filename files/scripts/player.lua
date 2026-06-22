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
if EntityGetWithName("dummy_stand") ~= 0 then
	local dx, dy = EntityGetTransform(EntityGetWithName("dummy_stand"))
	if dy - y > 80 then
		cy = cy - 70
	elseif y - dy > 15 then
		cy = cy + 70
	end
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

-- sum all mana
local inv = EntityGetWithName("inventory_quick")
if not (inv and inv > 0) then inv = EntityGetWithName("inventory_quick2") end
local wands = EntityGetAllChildren(inv, "wand") or {}
local mana = tonumber(GlobalsGetValue("INHERENT_MANA", "0"))
local mana_chg = tonumber(GlobalsGetValue("INHERENT_MANA_CHG", "0")) or 0
local mana_max = tonumber(GlobalsGetValue("INHERENT_MANA_MAX", "0")) or 0
local inbattle = GlobalsGetValue("NS_IN_BATTLE", "0") == "1"

for i = 1, #wands do
	local reloader = EntityGetFirstComponent(wands[i], "ManaReloaderComponent")
	if reloader then EntityRemoveComponent(wands[i], reloader) end
	local ability = EntityGetFirstComponentIncludingDisabled(wands[i], "AbilityComponent")
	local mana_last = EntityGetFirstComponentIncludingDisabled(wands[i], "VariableStorageComponent", "mana_last")
	if ability and not mana_last then
		EntityAddComponent2(wands[i], "VariableStorageComponent", {_tags="mana_last", value_int=ComponentGetValue2(ability, "mana_max"), value_float=mana})
	elseif ability and mana_last then
		mana_max = mana_max + ComponentGetValue2(ability, "mana_max")
		mana_chg = mana_chg + ComponentGetValue2(ability, "mana_charge_speed")
		local diff = ComponentGetValue2(ability, "mana") - ComponentGetValue2(mana_last, "value_float")
		mana = mana + diff
		-- hide the mana so it doesn't show on hud outside of battle
		if (not inbattle) and (mana_max > -99999) then
			ComponentSetValue2(mana_last, "value_int", ComponentGetValue2(ability, "mana_max"))
			ComponentSetValue2(ability, "mana_max", -999999)
		elseif inbattle and (mana_max <= -99999) then
			ComponentSetValue2(ability, "mana_max", ComponentGetValue2(mana_last, "value_int"))
			mana_max = mana_max + 999999
			mana = mana + 999999
		end
	end
end
local forcemana = tonumber(GlobalsGetValue("NS_FORCE_MANA", "-1")) or -1
if forcemana >= 0 then
	mana = forcemana
	mana_chg = 0
	GlobalsSetValue("NS_FORCE_MANA", "-1")
end
mana_chg = mana_chg / 60
mana = math.min(mana_max, mana + mana_chg)
for i = 1, #wands do
	local ability = EntityGetFirstComponentIncludingDisabled(wands[i], "AbilityComponent")
	local mana_last = EntityGetFirstComponentIncludingDisabled(wands[i], "VariableStorageComponent", "mana_last")
	if ability and mana_last then
		ComponentSetValue2(mana_last, "value_float", mana)
		ComponentSetValue2(ability, "mana", mana)
	end
end
if math.abs(mana) > 9999 or math.abs(mana_max) > 9999 then return end
GlobalsSetValue("INHERENT_MANA", tostring(mana))
GlobalsSetValue("MANA_CHG_FINAL", tostring(mana_chg))
GlobalsSetValue("MANA_MAX_FINAL", tostring(mana_max))