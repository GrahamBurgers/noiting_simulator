local me = GetUpdatedEntityID()
local player = EntityGetRootEntity(me)
local dmg = player and EntityGetFirstComponent(player, "DamageModelComponent")
local storage = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "adrenaline_bar")
local max_charge = 10
local charge_table = {
	4,
	2,
	1,
	0.75,
	0.65,
	0.60,
	0.55,
	0.50,
	0.45,
	0.40,
}

local bars = EntityGetComponentIncludingDisabled(me, "SpriteComponent", "adrenaline_bar") or {}
if #bars < 3 or (not dmg) or (not storage) then return end

local us = EntityGetWithTag("active_adrenaline")
if me ~= us[1] then
	ComponentSetValue2(bars[1], "alpha", 0)
	ComponentSetValue2(bars[2], "alpha", 0)
	ComponentSetValue2(bars[3], "alpha", 0)
	return
else
	EntityRefreshSprite(me, bars[1])
	ComponentSetValue2(bars[1], "z_index", 6)
	EntityRefreshSprite(me, bars[2])
	ComponentSetValue2(bars[2], "z_index", 5.5)
	EntityRefreshSprite(me, bars[3])
	ComponentSetValue2(bars[3], "z_index", 5)
end

local hp = ComponentGetValue2(dmg, "hp") / #us
hp = math.floor(math.max(1, hp * 25))
local charge = ComponentGetValue2(storage, "value_float")
local oldcharge = charge
local alpha = ComponentGetValue2(storage, "value_int")
ComponentSetValue2(storage, "value_int", alpha - 1)
alpha = math.min(1, (alpha + 100) / 100)
if charge_table[hp] then
	charge = charge + charge_table[hp] / 60
else
	charge = charge - 0.05
end
charge = math.max(0, math.min(charge, max_charge))
ComponentSetValue2(storage, "value_float", charge)
ComponentSetValue2(bars[1], "alpha", 0.8 * alpha)
if charge == max_charge then
	GlobalsSetValue("SPELL_ADRENALINE_ACTIVE", "TRUE")
	EntitySetComponentsWithTagEnabled(me, "adrenaline_particle", true)
elseif charge == 0 then
	GlobalsSetValue("SPELL_ADRENALINE_ACTIVE", "FALSE")
	EntitySetComponentsWithTagEnabled(me, "adrenaline_particle", false)
end
if oldcharge ~= charge then
	ComponentSetValue2(storage, "value_int", 100)
	alpha = 1
end

if GlobalsGetValue("SPELL_ADRENALINE_ACTIVE", "FALSE") == "FALSE" then
	ComponentSetValue2(bars[2], "special_scale_x", charge / max_charge)
	ComponentSetValue2(bars[2], "alpha", 0.6 * alpha)
	ComponentSetValue2(bars[3], "alpha", 0)
else
	ComponentSetValue2(bars[3], "special_scale_x", charge / max_charge)
	ComponentSetValue2(bars[3], "alpha", 0.6 * alpha)
	ComponentSetValue2(bars[2], "alpha", 0)
end