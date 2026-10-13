local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local inv = EntityGetWithName("inventory_quick")
local wands = EntityGetIsAlive(inv) and EntityGetAllChildren(inv, "wand") or {}
local old_count = ComponentGetValue2(this, "limit_how_many_times_per_frame")
local new_count = 0
if EntityHasTag(EntityGetParent(me), "wand") then
	for i = 1, #wands do
		local ability = EntityGetFirstComponentIncludingDisabled(wands[i], "AbilityComponent")
		if ability then
			local free_slots = ComponentObjectGetValue2(ability, "gun_config", "deck_capacity") - #(EntityGetAllChildren(wands[i], "card_action") or {})
			new_count = new_count + free_slots
		end
	end
end
GlobalsSetValue("INHERENT_MANA_MAX", tonumber(GlobalsGetValue("INHERENT_MANA_MAX") or 0) + 5 * (new_count - old_count))
GlobalsSetValue("INHERENT_MANA_CHG", tonumber(GlobalsGetValue("INHERENT_MANA_CHG") or 0) + 1 * (new_count - old_count))
ComponentSetValue2(this, "limit_how_many_times_per_frame", new_count)