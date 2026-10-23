local me = GetUpdatedEntityID()

local bar = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "pebble_bar")
if not bar then return end

local thing = math.max(0, ComponentGetValue2(bar, "special_scale_x") - 0.015)
ComponentSetValue2(bar, "special_scale_x", thing)

GlobalsSetValue("SPELL_PEBBLE_ACTIVE", thing > 0 and "1" or "0")