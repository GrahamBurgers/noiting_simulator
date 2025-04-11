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
			add_projectile("mods/noiting_simulator/files/spells/confidence.xml")
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
			add_projectile("mods/noiting_simulator/files/spells/confidence.xml")
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
		id          = "LANCE",
		name 		= "$action_lance",
		description = "$actiondesc_lance",
		sprite 		= "data/ui_gfx/gun_actions/lance.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/lance_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/lance.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,5,6", -- LANCE
		spawn_probability                 = "0.9,1,0.8,1", -- LANCE
		price = 180,
		mana = 30,
		--max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/lance.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lance.xml")
			-- damage = 0.3
			c.fire_rate_wait = c.fire_rate_wait + 20
			c.spread_degrees = c.spread_degrees - 20
			shot_effects.recoil_knockback = 60.0
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
			c.speed_multiplier = c.speed_multiplier * 2.5
			
			if ( c.speed_multiplier >= 20 ) then
				c.speed_multiplier = math.min( c.speed_multiplier, 20 )
			elseif ( c.speed_multiplier < 0 ) then
				c.speed_multiplier = 0
			end
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DAMAGE",
		name 		= "$action_damage",
		description = "$actiondesc_damage",
		sprite 		= "data/ui_gfx/gun_actions/damage.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		related_extra_entities = { "data/entities/particles/tinyspark_yellow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5", -- DAMAGE
		spawn_probability                 = "0.6,0.6,0.8,0.6,0.6", -- DAMAGE
		price = 140,
		mana = 5,
		--max_uses = 50,
		custom_xml_file = "data/entities/misc/custom_cards/damage.xml",
		action 		= function()
			c.damage_projectile_add = c.damage_projectile_add + 0.4
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 5
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true )
		end,
	},
}

actions = {}
local len = #actions
for i=1, #to_insert do
	actions[len+i] = to_insert[i]
end