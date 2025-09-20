---@diagnostic disable: undefined-global, lowercase-global
return {
    {
		id                  = "NS_CUTE1",
		name                = "$n_ns_cute1",
		description         = "$d_ns_cute1",
		sprite              = "mods/noiting_simulator/files/spells/endear.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		charge_time         = 0.04,
        max_uses            = 200,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/endear.xml")
		end,
	},
	{
		id                  = "NS_CUTE2",
		name                = "$n_ns_cute2",
		description         = "$d_ns_cute2",
		sprite              = "mods/noiting_simulator/files/spells/dote.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
		end,
	},
	{
		id                  = "NS_CUTE3",
		name                = "$n_ns_cute3",
		description         = "$d_ns_cute3",
		sprite              = "mods/noiting_simulator/files/spells/allure.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/allure.xml")
		end,
	},
	{
		id                  = "NS_CHARMING1",
		name                = "$n_ns_charming1",
		description         = "$d_ns_charming1",
		sprite              = "mods/noiting_simulator/files/spells/confidence.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/confidence.xml")
		end,
	},
	{
		id                  = "NS_CHARMING2",
		name                = "$n_ns_charming2",
		description         = "$d_ns_charming2",
		sprite              = "mods/noiting_simulator/files/spells/dazzle.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/dazzle.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
		end,
	},
	{
		id                  = "NS_CHARMING3",
		name                = "$n_ns_charming3",
		description         = "$d_ns_charming3",
		sprite              = "mods/noiting_simulator/files/spells/candor.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/candor.xml")
			add_projectile("mods/noiting_simulator/files/spells/candor2.xml")
			add_projectile("mods/noiting_simulator/files/spells/candor3.xml")
		end,
	},
	{
		id                  = "NS_CLEVER1",
		name                = "$n_ns_clever1",
		description         = "$d_ns_clever1",
		sprite              = "mods/noiting_simulator/files/spells/geek_out.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/geek_out.xml")
		end,
	},
	{
		id                  = "NS_CLEVER2",
		name                = "$n_ns_clever2",
		description         = "$d_ns_clever2",
		sprite              = "mods/noiting_simulator/files/spells/foresight.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/foresight.xml")
		end,
	},
	{
		id                  = "NS_CLEVER3",
		name                = "$n_ns_clever3",
		description         = "$d_ns_clever3",
		sprite              = "mods/noiting_simulator/files/spells/intuition.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/intuition.xml")
		end,
	},
	{
		id                  = "NS_COMEDIC1",
		name                = "$n_ns_comedic1",
		description         = "$d_ns_comedic1",
		sprite              = "mods/noiting_simulator/files/spells/one_liner.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/one_liner.xml")
		end,
	},
	{
		id                  = "NS_COMEDIC2",
		name                = "$n_ns_comedic2",
		description         = "$d_ns_comedic2",
		sprite              = "mods/noiting_simulator/files/spells/pickup_line.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/pickup_line.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 200.0
		end,
	},
	{
		id                  = "NS_COMEDIC3",
		name                = "$n_ns_comedic3",
		description         = "$d_ns_comedic3",
		sprite              = "mods/noiting_simulator/files/spells/icebreaker.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/icebreaker.xml")
			add_projectile("mods/noiting_simulator/files/spells/icebreaker2.xml")
			add_projectile("mods/noiting_simulator/files/spells/icebreaker3.xml")
		end,
	},
	{
		id                  = "NS_STRUGGLE",
		name                = "$n_ns_struggle",
		description         = "$d_ns_struggle",
		sprite              = "mods/noiting_simulator/files/spells/struggle.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		charge_time         = 0.12,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/struggle.xml")
		end,
	},
	{
		id                  = "NS_TRIPLESHOT",
		name                = "$n_ns_tripleshot",
		description         = "$d_ns_tripleshot",
		sprite              = "mods/noiting_simulator/files/spells/tripleshot.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/tripleshot.xml")
			add_projectile("mods/noiting_simulator/files/spells/tripleshot2.xml")
			add_projectile("mods/noiting_simulator/files/spells/tripleshot3.xml")
		end,
	},
	{
		id                  = "NS_INSIDEJOKE",
		name                = "$n_ns_insidejoke",
		description         = "$d_ns_insidejoke",
		sprite              = "mods/noiting_simulator/files/spells/inside_joke.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/inside_joke.xml")
		end,
	},
	{
		id                  = "NS_BOOSTCUTE",
		name                = "$n_ns_boostcute",
		description         = "$d_ns_boostcute",
		sprite              = "mods/noiting_simulator/files/spells/boostcute.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcute.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_BOOSTCHARMING",
		name                = "$n_ns_boostcharming",
		description         = "$d_ns_boostcharming",
		sprite              = "mods/noiting_simulator/files/spells/boostcharming.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcharming.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_BOOSTCLEVER",
		name                = "$n_ns_boostclever",
		description         = "$d_ns_boostclever",
		sprite              = "mods/noiting_simulator/files/spells/boostclever.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostclever.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_BOOSTCOMEDIC",
		name                = "$n_ns_boostcomedic",
		description         = "$d_ns_boostcomedic",
		sprite              = "mods/noiting_simulator/files/spells/boostcomedic.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcomedic.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_BOOSTRANDOM",
		name                = "$n_ns_boostrandom",
		description         = "$d_ns_boostrandom",
		sprite              = "mods/noiting_simulator/files/spells/boostrandom.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostrandom.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_CHERISH",
		name                = "$n_ns_cherish",
		description         = "$d_ns_cherish",
		sprite              = "mods/noiting_simulator/files/spells/cherish.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/cherish.xml,"
			c.damage_melee_add = c.damage_melee_add + 0.12
			c.knockback_force = c.knockback_force + 6
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_SNAPSHOT",
		name                = "$n_ns_snapshot",
		description         = "$d_ns_snapshot",
		sprite              = "mods/noiting_simulator/files/spells/snapshot.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/snapshot.xml,"
			c.damage_fire_add = c.damage_fire_add + 0.12
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_PLAYITSTRAIGHT",
		name                = "$n_ns_playitstraight",
		description         = "$d_ns_playitstraight",
		sprite              = "mods/noiting_simulator/files/spells/playitstraight.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/playitstraight.xml,"
			c.damage_ice_add = c.damage_ice_add + 0.12
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_TEMPOCHARM",
		name                = "$n_ns_tempocharm",
		description         = "$d_ns_tempocharm",
		sprite              = "mods/noiting_simulator/files/spells/tempocharm.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.speed_multiplier = c.speed_multiplier * 1.5
			c.damage_slice_add = c.damage_slice_add + 0.12
			draw_actions(1, true)
		end,
	},
	--[[
	{
		id          = "LIFETIME2",
		name 		= "Lifetime",
		description = "Lifetime up",
		sprite 		= "data/ui_gfx/gun_actions/lifetime.png",
		type 		= ACTION_TYPE_MODIFIER,
		mana = 3,
		action 		= function()
			c.damage_healing_add = c.damage_healing_add + 1
			draw_actions( 1, true )
		end,
	},
	{
		id          = "SPEED2",
		name 		= "Speed",
		description = "Speedy speed",
		sprite 		= "data/ui_gfx/gun_actions/speed.png",
		type 		= ACTION_TYPE_MODIFIER,
		mana = 3,
		action 		= function()
			c.speed_multiplier = c.speed_multiplier * 1.5
			draw_actions( 1, true )
		end,
	},
	]]--
}