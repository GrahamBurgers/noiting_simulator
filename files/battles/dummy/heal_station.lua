local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local player = EntityGetWithTag("player_unit")
local min_x, max_x, min_y, max_y = -6, 6, -25, 1
for i = 1, #player do
	local px, py = EntityGetTransform(player[i])
	if px > x + min_x and px < x + max_x and py > y + min_y and py < y + max_y then
		local dmg = EntityGetFirstComponent(player[i], "DamageModelComponent")
		if dmg and ComponentGetValue2(dmg, "hp") < ComponentGetValue2(dmg, "max_hp") then
			ComponentSetValue2(dmg, "hp", ComponentGetValue2(dmg, "max_hp"))
            EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", px, py)
		end
	end
end