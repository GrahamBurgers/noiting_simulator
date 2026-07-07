local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetWithTag("player_unit")
local min_x, max_x, min_y, max_y = -6, 6, -25, 1
Me_is_touch_player = Me_is_touch_player or false
for i = 1, #player do
	local px, py = EntityGetTransform(player[i])
	if px > x + min_x and px < x + max_x and py > y + min_y and py < y + max_y then
		if not Me_is_touch_player then
			local dmg = EntityGetFirstComponent(player[i], "DamageModelComponent")
			if dmg and ComponentGetValue2(dmg, "hp") < ComponentGetValue2(dmg, "max_hp") then
				ComponentSetValue2(dmg, "hp", ComponentGetValue2(dmg, "max_hp"))
				EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", px, py)
			end
			EntityLoad("data/entities/particles/image_emitters/spell_refresh_effect.xml", px, py)
			GameRegenItemActionsInPlayer(player[i])
		end
		Me_is_touch_player = true
	elseif #EntityGetInRadiusWithTag(x, y, 30, "player_unit") < 1 then
		Me_is_touch_player = false
	end
end