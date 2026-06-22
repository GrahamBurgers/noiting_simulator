function item_pickup(me, who, item_name)
	local x, y = EntityGetTransform(me)
	EntityLoad( "data/entities/particles/perk_reroll.xml", x, y)
	EntityKill(me)
	EntityLoad("mods/noiting_simulator/files/battles/dummy/reroll_station.xml", x, y)
end