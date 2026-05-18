function interacting(who, me, name)
	local interact = EntityGetFirstComponentIncludingDisabled(me, "InteractableComponent")
	local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent")
	local lua = EntityGetFirstComponentIncludingDisabled(me, "LuaComponent", "you_are_a_dummy")
	if not (interact and sprite and lua) then return end
	local disable_now = ComponentGetValue2(interact, "ui_text") == "$tether_disable"
	EntitySetComponentIsEnabled(me, lua, not disable_now)
	ComponentSetValue2(interact, "ui_text", disable_now and "$tether_enable" or "$tether_disable")
	ComponentSetValue2(sprite, "image_file", disable_now and "mods/noiting_simulator/files/battles/dummy/dummy_stand_off.png" or "mods/noiting_simulator/files/battles/dummy/dummy_stand.png")
	EntityRefreshSprite(me, sprite)
end