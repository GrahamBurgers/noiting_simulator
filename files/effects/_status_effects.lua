local to_insert = {
	{
		id             = "NS_HONEY",
		ui_name        = "$ns_n_honey",
		ui_description = "$ns_d_honey",
		ui_icon        = "mods/noiting_simulator/files/effects/honey.png",
		effect_entity  = "mods/noiting_simulator/files/effects/honey.xml",
		is_harmful=true,
	},
}

for i,v in ipairs(to_insert) do
    table.insert(status_effects, v)
end