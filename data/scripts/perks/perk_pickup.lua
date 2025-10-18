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
    if double > 0 and item_name ~= "$name_ns_double" then
        for i = 1, double do
            perk_pickup(entity_item, entity_who_picked, item_name, false, kill_other_perks)
        end
        local entities = EntityGetWithTag("perk_entity")
        for i = 1, #entities do
            local ui = EntityGetFirstComponent(entities[i], "UIIconComponent")
            if ui and ComponentGetValue2(ui, "name") == "$name_ns_double" then
                EntityKill(entities[i])
            end
        end
        GlobalsSetValue("PERK_PICKED_DOUBLE_PICKUP_COUNT", "0")
    end
end