---@diagnostic disable: undefined-global, lowercase-global
return {
	--------- CUTE ---------
    {
		id                  = "NS_CUTE1",
		sprite              = "mods/noiting_simulator/files/spells/endear.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/endear.xml")
		end,
	},
	{
		id                  = "NS_CUTE2",
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
		sprite              = "mods/noiting_simulator/files/spells/allure.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/allure.xml")
		end,
	},
	{
		id                  = "NS_BOOSTCUTE",
		sprite              = "mods/noiting_simulator/files/spells/boostcute.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcute.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_CHERISH",
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
		id                  = "NS_PUSHER",
		sprite              = "mods/noiting_simulator/files/spells/pusher.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/pusher.xml")
		end,
	},
	--------- CHARMING ---------
	{
		id                  = "NS_CHARMING1",
		sprite              = "mods/noiting_simulator/files/spells/confidence.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/confidence.xml")
		end,
	},
	{
		id                  = "NS_CHARMING2",
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
		id                  = "NS_BOOSTCHARMING",
		sprite              = "mods/noiting_simulator/files/spells/boostcharming.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcharming.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_TEMPOCHARM",
		sprite              = "mods/noiting_simulator/files/spells/tempocharm.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			local tempo = 1
			if not reflecting then
				local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
				local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
				local v = smallfolk.loads(storage)
				tempo = math.max(0, v.tempolevel + (v.tempo / v.tempomax))
			end
			c.speed_multiplier = c.speed_multiplier + 0.2 * tempo
			c.damage_slice_add = c.damage_slice_add + 0.08 * tempo
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_POKE",
		sprite              = "mods/noiting_simulator/files/spells/poke.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/poke.xml,"
			c.damage_slice_add = c.damage_slice_add + 0.12
			draw_actions(1, true)
		end,
	},
	--------- CLEVER ---------
	{
		id                  = "NS_CLEVER1",
		sprite              = "mods/noiting_simulator/files/spells/geek_out.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/geek_out.xml")
		end,
	},
	{
		id                  = "NS_CLEVER2",
		sprite              = "mods/noiting_simulator/files/spells/foresight.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/foresight.xml")
		end,
	},
	{
		id                  = "NS_CLEVER3",
		sprite              = "mods/noiting_simulator/files/spells/intuition.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/intuition.xml")
		end,
	},
	{
		id                  = "NS_BOOSTCLEVER",
		sprite              = "mods/noiting_simulator/files/spells/boostclever.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostclever.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_SNAPSHOT",
		sprite              = "mods/noiting_simulator/files/spells/snapshot.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/snapshot.xml,"
			c.damage_fire_add = c.damage_fire_add + 0.12
			c.damage_healing_add = c.damage_healing_add + 0.6
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_TRIPLESHOT",
		sprite              = "mods/noiting_simulator/files/spells/tripleshot.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/tripleshot.xml")
			add_projectile("mods/noiting_simulator/files/spells/tripleshot2.xml")
			add_projectile("mods/noiting_simulator/files/spells/tripleshot3.xml")
		end,
	},
	--------- COMEDIC ---------
	{
		id                  = "NS_COMEDIC1",
		sprite              = "mods/noiting_simulator/files/spells/one_liner.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/one_liner.xml")
		end,
	},
	{
		id                  = "NS_COMEDIC2",
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
		id                  = "NS_BOOSTCOMEDIC",
		sprite              = "mods/noiting_simulator/files/spells/boostcomedic.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcomedic.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_PLAYITSTRAIGHT",
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
		id                  = "NS_INSIDEJOKE",
		sprite              = "mods/noiting_simulator/files/spells/inside_joke.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/inside_joke.xml")
		end,
	},
	--------- TYPELESS ---------
	{
		id                  = "NS_STRUGGLE",
		sprite              = "mods/noiting_simulator/files/spells/struggle.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		charge_time         = 0.12,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/struggle.xml")
		end,
	},
	{
		id                  = "NS_BOOSTRANDOM",
		sprite              = "mods/noiting_simulator/files/spells/boostrandom.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostrandom.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_SPARKLES",
		sprite              = "mods/noiting_simulator/files/spells/sparkles.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.bounces = c.bounces + 1
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/sparkles.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_MIMICMODIFIER",
		sprite              = "mods/noiting_simulator/files/spells/doubledown.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			for i = 1, #deck do
				if deck[i].type == ACTION_TYPE_MODIFIER and deck[i].id ~= "NS_MIMICMODIFIER" then
					deck[i].action(deck[i])
					return
				end
			end
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_FLAME",
		sprite              = "mods/noiting_simulator/files/spells/flame.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/flame.xml,"
			draw_actions(1, true)
		end,
	},
}