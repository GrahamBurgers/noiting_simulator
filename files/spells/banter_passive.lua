local me = GetUpdatedEntityID()

local bar = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "banter_bar")
if not bar then return end

local thing = math.max(0, ComponentGetValue2(bar, "special_scale_x") - 0.006)
ComponentSetValue2(bar, "special_scale_x", thing)

GlobalsSetValue("SPELL_BANTER_ACTIVE", thing > 0 and "1" or "0")