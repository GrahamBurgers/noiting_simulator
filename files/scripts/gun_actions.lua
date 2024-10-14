---@diagnostic disable: undefined-global, lowercase-global
local to_insert = {
	{
		id                  = "NS_ENDEAR",
		name                = "$ns_actionname_cute1",
		description         = "$ns_actiondesc_cute1",
		sprite              = "mods/noiting_simulator/files/gfx/spells/endear.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/entities/spells/endear.xml")
		end,
	},
	{
		id                  = "NS_DOTE",
		name                = "$ns_actionname_cute2",
		description         = "$ns_actiondesc_cute2",
		sprite              = "mods/noiting_simulator/files/gfx/spells/dote.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/entities/spells/dote.xml")
			add_projectile("mods/noiting_simulator/files/entities/spells/dote.xml")
			add_projectile("mods/noiting_simulator/files/entities/spells/dote.xml")
		end,
	},
	{
		id                  = "NS_ALLURE",
		name                = "$ns_actionname_cute3",
		description         = "$ns_actiondesc_cute3",
		sprite              = "mods/noiting_simulator/files/gfx/spells/allure.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/entities/spells/allure.xml")
		end,
	},
	{
		id                  = "NS_CLEVER",
		name                = "$ns_actionname_clever1",
		description         = "$ns_actiondesc_clever1",
		sprite              = "mods/noiting_simulator/files/gfx/spells/clever.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/entities/spells/clever.xml")
		end,
	},
}

actions = {}
local len = #actions
for i=1, #to_insert do
	actions[len+i] = to_insert[i]
end