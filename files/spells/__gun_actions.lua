---@diagnostic disable: undefined-global, lowercase-global
local to_insert = {
	{
		id                  = "NS_CUTE1",
		name                = "$ns_n_cute1",
		description         = "$ns_d_cute1",
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
	{
		id                  = "NS_CUTE2",
		name                = "$ns_n_cute2",
		description         = "$ns_d_cute2",
		sprite              = "mods/noiting_simulator/files/spells/dote.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
		end,
	},
	{
		id                  = "NS_CUTE3",
		name                = "$ns_n_cute3",
		description         = "$ns_d_cute3",
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
	{
		id                  = "NS_CHARMING1",
		name                = "$ns_n_charming1",
		description         = "$ns_d_charming1",
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
		id                  = "NS_CHARMING2",
		name                = "$ns_n_charming2",
		description         = "$ns_d_charming2",
		sprite              = "mods/noiting_simulator/files/spells/dazzle.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/dazzle.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
		end,
	},
	{
		id                  = "NS_CHARMING3",
		name                = "$ns_n_charming3",
		description         = "$ns_d_charming3",
		sprite              = "mods/noiting_simulator/files/spells/candor.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/candor.xml")
			add_projectile("mods/noiting_simulator/files/spells/candor2.xml")
			add_projectile("mods/noiting_simulator/files/spells/candor3.xml")
		end,
	},
	{
		id                  = "NS_CLEVER1",
		name                = "$ns_n_clever1",
		description         = "$ns_d_clever1",
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
		id                  = "NS_CLEVER2",
		name                = "$ns_n_clever2",
		description         = "$ns_d_clever2",
		sprite              = "mods/noiting_simulator/files/spells/foresight.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/foresight.xml")
		end,
	},
	{
		id                  = "NS_CLEVER3",
		name                = "$ns_n_clever3",
		description         = "$ns_d_clever3",
		sprite              = "mods/noiting_simulator/files/spells/intuition.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/intuition.xml")
		end,
	},
	{
		id                  = "NS_COMEDIC1",
		name                = "$ns_n_comedic1",
		description         = "$ns_d_comedic1",
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
		id                  = "NS_COMEDIC2",
		name                = "$ns_n_comedic2",
		description         = "$ns_d_comedic2",
		sprite              = "mods/noiting_simulator/files/spells/pickup_line.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/pickup_line.xml")
		end,
	},
	{
		id                  = "NS_COMEDIC3",
		name                = "$ns_n_comedic3",
		description         = "$ns_d_comedic3",
		sprite              = "mods/noiting_simulator/files/spells/icebreaker.png",
		type                = ACTION_TYPE_PROJECTILE,
		spawn_level         = "0",
		spawn_probability   = "0",
		price               = 0,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/icebreaker.xml")
		end,
	},
	{
		id                  = "NS_STRUGGLE",
		name                = "$ns_n_struggle",
		description         = "$ns_d_struggle",
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
	{
		id          = "SPEED",
		name 		= "$action_speed",
		description = "$actiondesc_speed",
		sprite 		= "data/ui_gfx/gun_actions/speed.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/speed_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3", -- SPEED
		spawn_probability                 = "1,0.5,0.5", -- SPEED
		price = 100,
		mana = 3,
		--max_uses = 100,
		custom_xml_file = "data/entities/misc/custom_cards/speed.xml",
		action 		= function()
			c.damage_drill_add = c.damage_drill_add + 0.12
			draw_actions( 1, true )
		end,
	},
}

actions = {}
local len = #actions
for i=1, #to_insert do
	actions[len+i] = to_insert[i]
end