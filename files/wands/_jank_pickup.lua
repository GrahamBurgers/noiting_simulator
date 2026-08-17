function item_pickup(entity_item, entity_pickupper, item_name )
	local ability = EntityGetFirstComponentIncludingDisabled(entity_item, "AbilityComponent")
	if ability then ComponentSetValue2(ability, "use_gun_script", true) end
	EntityRemoveFromParent(entity_item)
	EntitySetComponentsWithTagEnabled(entity_item, "enabled_in_world", true)
	EntitySetComponentsWithTagEnabled(entity_item, "enabled_in_hand", false)
	EntitySetComponentsWithTagEnabled(entity_item, "enabled_in_inventory", false)
end