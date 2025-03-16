---@diagnostic disable: undefined-global, lowercase-global
local to_insert = {
	{
		id                  = "NS_CUTE1",
		name                = "$ns_actionname_cute1",
		description         = "$ns_actiondesc_cute1",
		sprite              = "mods/noiting_simulator/files/spells/endear.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/endear.xml")
		end,
	},
	--[[
	{
		id                  = "NS_CUTE2",
		name                = "$ns_actionname_cute2",
		description         = "$ns_actiondesc_cute2",
		sprite              = "mods/noiting_simulator/files/spells/dote.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
		end,
	},
	{
		id                  = "NS_CUTE3",
		name                = "$ns_actionname_cute3",
		description         = "$ns_actiondesc_cute3",
		sprite              = "mods/noiting_simulator/files/spells/allure.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/allure.xml")
		end,
	},
	]]--
	{
		id                  = "NS_CLEVER1",
		name                = "$ns_actionname_clever1",
		description         = "$ns_actiondesc_clever1",
		sprite              = "mods/noiting_simulator/files/spells/geek_out.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/geek_out.xml")
		end,
	},
	{
		id                  = "NS_COMEDIC1",
		name                = "$ns_actionname_comedic1",
		description         = "$ns_actiondesc_comedic1",
		sprite              = "mods/noiting_simulator/files/spells/one_liner.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/one_liner.xml")
		end,
	},
	{
		id                  = "NS_CHARMING1",
		name                = "$ns_actionname_charming1",
		description         = "$ns_actiondesc_charming1",
		sprite              = "mods/noiting_simulator/files/spells/confidence.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/confidence.xml")
		end,
	},
	{
		id                  = "NS_STRUGGLE",
		name                = "$ns_actionname_struggle",
		description         = "$ns_actiondesc_struggle",
		sprite              = "mods/noiting_simulator/files/spells/struggle.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/struggle.xml")
		end,
	},
}

actions = {}
local len = #actions
for i=1, #to_insert do
	actions[len+i] = to_insert[i]
end