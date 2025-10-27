dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local kill_other_perks = true

	local components = EntityGetComponent( entity_item, "VariableStorageComponent" )

	if ( components ~= nil ) then
		for key,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == "perk_dont_remove_others") then
				if( ComponentGetValueBool( comp_id, "value_bool" ) ) then
					kill_other_perks = false
				end
			end
		end
	end

	perk_pickup( entity_item, entity_who_picked, item_name, true, kill_other_perks )
	local double = tonumber(GlobalsGetValue("PERK_PICKED_DOUBLE_PICKUP_COUNT", "0")) or 0
	-- double handler
    if double > 0 and item_name ~= "$name_ns_double" then
        for i = 1, double do
            perk_pickup(entity_item, entity_who_picked, item_name, false, kill_other_perks)
        end
		-- remove ui icon
        local entities = EntityGetWithTag("perk_entity")
        for i = 1, #entities do
            local ui = EntityGetFirstComponent(entities[i], "UIIconComponent")
            if ui and ComponentGetValue2(ui, "name") == "$name_ns_double" then
                EntityKill(entities[i])
            end
        end
        GlobalsSetValue("PERK_PICKED_DOUBLE_PICKUP_COUNT", "0")
    end

	-- gamble handler
	if item_name == "$name_ns_gamble" then
		SetRandomSeed(entity_item + GameGetFrameNum(), 2049205 + entity_who_picked)
		local x, y = EntityGetTransform(entity_who_picked)
		local print_string = "Rolled: "
		local count = Random(1, 3)
		while count > 0 do
			local pid = perk_spawn(x, y, gamble_list[Random(1, #gamble_list)])
			perk_pickup(pid, entity_who_picked, "", false, false)
			count = count - 1
			local ui = pid and EntityGetFirstComponent(pid, "UIInfoComponent")
			if ui then
				print_string = print_string .. GameTextGet(ComponentGetValue2(ui, "name"))
				if count > 0 then print_string = print_string .. ", " end
			end
		end
		GamePrint(print_string)
	end
end