---@diagnostic disable: undefined-global, lowercase-global

local function addlifetimemult(amount)
	if reflecting then
		c.damage_critical_chance = c.damage_critical_chance + amount * 100
	else
		c.damage_electricity_add = c.damage_electricity_add + amount
	end
end

ACTION_TYPE_PROJECTILE	= 0
ACTION_TYPE_STATIC_PROJECTILE = 1
ACTION_TYPE_MODIFIER	= 2
ACTION_TYPE_DRAW_MANY	= 3
ACTION_TYPE_MATERIAL	= 4
ACTION_TYPE_OTHER		= 5
ACTION_TYPE_UTILITY		= 6
ACTION_TYPE_PASSIVE		= 7

return {
	{
		id                  = "NS_DEBUG",
		sprite              = "mods/noiting_simulator/files/spells/debug.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
		charge_time         = 0.12,
		action 	            = function()
			c.damage_projectile_add = c.damage_projectile_add + 0.04
			c.damage_melee_add = c.damage_melee_add + 0.08
			c.damage_electricity_add = c.damage_electricity_add + 0.12
			c.damage_fire_add = c.damage_fire_add + 0.16
			c.damage_explosion_add = c.damage_explosion_add + 0.20
			c.damage_ice_add = c.damage_ice_add + 0.24
			c.damage_slice_add = c.damage_slice_add + 0.28
			c.damage_healing_add = c.damage_healing_add + 0.32
			c.damage_curse_add = c.damage_curse_add + 0.36
			c.damage_drill_add = c.damage_drill_add + 0.38
			c.speed_multiplier = c.speed_multiplier + 1
			c.knockback_force = c.knockback_force + 2
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			c.damage_critical_chance = c.damage_critical_chance + 15
			c.bounces = c.bounces + 1
			c.explosion_radius = c.explosion_radius + 30.0
			-- c.fire_rate_wait = c.fire_rate_wait + 5
			-- current_reload_time = current_reload_time + 10
			add_projectile("mods/noiting_simulator/files/spells/debug.xml")
		end,
	},
	-------------------------------------------- CUTE --------------------------------------------
    {
		id                  = "NS_CUTE1",
		sprite              = "mods/noiting_simulator/files/spells/endear.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CUTE",
		mana                = 50,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/endear.xml")
		end,
	},
	{
		id                  = "NS_CUTE2",
		sprite              = "mods/noiting_simulator/files/spells/dote.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
			add_projectile("mods/noiting_simulator/files/spells/dote.xml")
		end,
	},
	{
		id                  = "NS_CUTE3",
		sprite              = "mods/noiting_simulator/files/spells/allure.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/allure.xml")
		end,
	},
	{
		id                  = "NS_BOOSTCUTE",
		sprite              = "mods/noiting_simulator/files/spells/boostcute.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcute.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_CHERISH",
		sprite              = "mods/noiting_simulator/files/spells/cherish.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/cherish.xml,"
			c.damage_melee_add = c.damage_melee_add + 0.12
			c.knockback_force = c.knockback_force + 2
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_PUSHER",
		sprite              = "mods/noiting_simulator/files/spells/pusher.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 3,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/pusher.xml")
		end,
	},
	{
		id                  = "NS_PIERCING",
		sprite              = "mods/noiting_simulator/files/spells/piercing.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/piercing.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_ULTCUTE",
		sprite              = "mods/noiting_simulator/files/spells/ult_cute.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 4,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/ult_cute.xml")
		end,
	},
	{
		id                  = "NS_TELEPORT",
		sprite              = "mods/noiting_simulator/files/spells/teleport.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/teleport.xml,"
			addlifetimemult(-0.5)
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_ENTICE",
		sprite              = "mods/noiting_simulator/files/spells/entice.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/entice.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_BIGHEARTED",
		sprite              = "mods/noiting_simulator/files/spells/bighearted.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 2,
		custom_xml_file     = "mods/noiting_simulator/files/spells/bighearted.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_TEASE",
		sprite              = "mods/noiting_simulator/files/spells/tease.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 3,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/tease.xml")
		end,
	},
	{
		id                  = "NS_PUPPYDOG",
		sprite              = "mods/noiting_simulator/files/spells/puppydog.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 2,
		custom_xml_file     = "mods/noiting_simulator/files/spells/puppydog.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
    {
		id                  = "NS_GLOMP",
		sprite              = "mods/noiting_simulator/files/spells/glomp.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CUTE",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/glomp.xml")
		end,
	},
	-------------------------------------------- CHARMING --------------------------------------------
	{
		id                  = "NS_CHARMING1",
		sprite              = "mods/noiting_simulator/files/spells/confidence.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/confidence.xml")
		end,
	},
	{
		id                  = "NS_CHARMING2",
		sprite              = "mods/noiting_simulator/files/spells/dazzle.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/dazzle.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 300.0
		end,
	},
	{
		id                  = "NS_CHARMING3",
		sprite              = "mods/noiting_simulator/files/spells/candor.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 2,
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
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcharming.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_TEMPOCHARM",
		sprite              = "mods/noiting_simulator/files/spells/tempocharm.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			local tempo = 1
			if not reflecting then
				local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
				local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
				local v = smallfolk.loads(storage)
				tempo = math.max(0, v.tempolevel + (v.tempo / v.tempomax))
			end
			c.speed_multiplier = c.speed_multiplier + 0.1 * tempo
			c.damage_slice_add = c.damage_slice_add + 0.06 * tempo
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_POKE",
		sprite              = "mods/noiting_simulator/files/spells/poke.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/poke.xml,"
			c.damage_slice_add = c.damage_slice_add + 0.12
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_HASTEN",
		sprite              = "mods/noiting_simulator/files/spells/hasten.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.speed_multiplier = c.speed_multiplier + 0.25
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/hasten.xml,"
			addlifetimemult(-0.2)
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_ULTCHARMING",
		sprite              = "mods/noiting_simulator/files/spells/ult_charming.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 4,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/ult_charming.xml")
		end,
	},
	{
		id                  = "NS_FLAME",
		sprite              = "mods/noiting_simulator/files/spells/flame.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/flame.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_BREAKER",
		sprite              = "mods/noiting_simulator/files/spells/breaker.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/breaker.xml,"
			c.speed_multiplier = c.speed_multiplier - 0.15
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_FLAMETHROWER",
		sprite              = "mods/noiting_simulator/files/spells/flamethrower.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/flamethrower.xml")
			add_projectile("mods/noiting_simulator/files/spells/flamethrower2.xml")
			add_projectile("mods/noiting_simulator/files/spells/flamethrower3.xml")
			add_projectile("mods/noiting_simulator/files/spells/flamethrower4.xml")
		end,
	},
	{
		id                  = "NS_REGEN",
		sprite              = "mods/noiting_simulator/files/spells/regen.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		custom_xml_file     = "mods/noiting_simulator/files/spells/regen.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_WARM",
		sprite              = "mods/noiting_simulator/files/spells/warm.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		custom_xml_file     = "mods/noiting_simulator/files/spells/warm.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_SPARKLES",
		sprite              = "mods/noiting_simulator/files/spells/sparkles.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.bounces = c.bounces + 1
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/sparkles.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_WAVE",
		sprite              = "mods/noiting_simulator/files/spells/wave.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CHARMING",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/wave.xml")
		end,
	},
	-------------------------------------------- CLEVER --------------------------------------------
	{
		id                  = "NS_CLEVER1",
		sprite              = "mods/noiting_simulator/files/spells/geek_out.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/geek_out.xml")
		end,
	},
	{
		id                  = "NS_CLEVER2",
		sprite              = "mods/noiting_simulator/files/spells/foresight.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/foresight.xml")
		end,
	},
	{
		id                  = "NS_CLEVER3",
		sprite              = "mods/noiting_simulator/files/spells/intuition.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/intuition.xml")
		end,
	},
	{
		id                  = "NS_BOOSTCLEVER",
		sprite              = "mods/noiting_simulator/files/spells/boostclever.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostclever.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_SNAPSHOT",
		sprite              = "mods/noiting_simulator/files/spells/snapshot.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/snapshot.xml,"
			c.damage_fire_add = c.damage_fire_add + 0.12
			addlifetimemult(0.15)
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_TRIPLESHOT",
		sprite              = "mods/noiting_simulator/files/spells/tripleshot.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/tripleshot.xml")
			add_projectile("mods/noiting_simulator/files/spells/tripleshot2.xml")
			add_projectile("mods/noiting_simulator/files/spells/tripleshot3.xml")
		end,
	},
	{
		id                  = "NS_PATIENCE",
		sprite              = "mods/noiting_simulator/files/spells/patience.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.speed_multiplier = c.speed_multiplier - 0.2
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/patience.xml,"
			addlifetimemult(0.3)
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_ULTCLEVER",
		sprite              = "mods/noiting_simulator/files/spells/ult_clever.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 4,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/ult_clever.xml")
		end,
	},
	{
		id                  = "NS_WRAPPER",
		sprite              = "mods/noiting_simulator/files/spells/wrapper.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/wrapper.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_LUA",
		sprite              = "mods/noiting_simulator/files/spells/lua.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 3,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/lua.xml,"
			if reflecting then c.damage_fire_add = c.damage_fire_add + 0.2 end
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_EAGER",
		sprite              = "mods/noiting_simulator/files/spells/eager.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 2,
		custom_xml_file     = "mods/noiting_simulator/files/spells/eager.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_CRITS",
		sprite              = "mods/noiting_simulator/files/spells/crits.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "CLEVER",
		mana                = 0,
		rarity              = 2,
		custom_xml_file     = "mods/noiting_simulator/files/spells/crits.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
	-------------------------------------------- COMEDIC --------------------------------------------
	{
		id                  = "NS_COMEDIC1",
		sprite              = "mods/noiting_simulator/files/spells/one_liner.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/one_liner.xml")
		end,
	},
	{
		id                  = "NS_COMEDIC2",
		sprite              = "mods/noiting_simulator/files/spells/pickup_line.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/pickup_line.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 200.0
		end,
	},
	{
		id                  = "NS_COMEDIC3",
		sprite              = "mods/noiting_simulator/files/spells/icebreaker.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 2,
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
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostcomedic.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_PLAYITSTRAIGHT",
		sprite              = "mods/noiting_simulator/files/spells/playitstraight.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 2,
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
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/inside_joke.xml")
		end,
	},
	{
		id                  = "NS_GUTBUSTER",
		sprite              = "mods/noiting_simulator/files/spells/gutbuster.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 1,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/gutbuster.xml,"
			c.knockback_force = c.knockback_force + 10
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_ULTCOMEDIC",
		sprite              = "mods/noiting_simulator/files/spells/ult_comedic.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 4,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/ult_comedic.xml")
		end,
	},
	{
		id                  = "NS_HOLDER",
		sprite              = "mods/noiting_simulator/files/spells/holder.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 3,
		action 	            = function()
			if reflecting then c.damage_ice_add = c.damage_ice_add + 0.8 end
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/holder.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_CURVEBALL",
		sprite              = "mods/noiting_simulator/files/spells/curveball.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 3,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/curveball.xml,"
			c.damage_ice_add = c.damage_ice_add + 0.12
			c.speed_multiplier = c.speed_multiplier + 0.15
			addlifetimemult(0.15)
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_SHOWOFF",
		sprite              = "mods/noiting_simulator/files/spells/showoff.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 2,
		custom_xml_file     = "mods/noiting_simulator/files/spells/showoff.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_COMMIT",
		sprite              = "mods/noiting_simulator/files/spells/commit.png",
		type                = ACTION_TYPE_PASSIVE,
		ns_category         = "COMEDIC",
		mana                = 0,
		rarity              = 2,
		custom_xml_file     = "mods/noiting_simulator/files/spells/commit.xml",
		action 	            = function()
			draw_actions(1, true)
		end,
	},
	-------------------------------------------- TYPELESS --------------------------------------------
	{
		id                  = "NS_STRUGGLE",
		sprite              = "mods/noiting_simulator/files/spells/struggle.png",
		type                = ACTION_TYPE_PROJECTILE,
		ns_category         = "TYPELESS",
		mana                = 0,
		rarity              = 5,
		action 	            = function()
			add_projectile("mods/noiting_simulator/files/spells/struggle.xml")
		end,
	},
	{
		id                  = "NS_BOOSTRANDOM",
		sprite              = "mods/noiting_simulator/files/spells/boostrandom.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "TYPELESS",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/boostrandom.xml,"
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_MIMICMODIFIER",
		sprite              = "mods/noiting_simulator/files/spells/doubledown.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "TYPELESS",
		mana                = 0,
		rarity              = 2,
		action 	            = function()
			for i = 1, #deck do
				if deck[i].type == ACTION_TYPE_MODIFIER and deck[i].id ~= "NS_MIMICMODIFIER" and deck[i].id ~= "NS_MIMICMODIFIER2" then
					deck[i].action()
					return
				end
			end
			draw_actions(1, true)
		end,
	},
	{
		id                  = "NS_MIMICMODIFIER2",
		sprite              = "mods/noiting_simulator/files/spells/tripledown.png",
		type                = ACTION_TYPE_MODIFIER,
		ns_category         = "TYPELESS",
		mana                = 0,
		rarity              = 3,
		action 	            = function()
			for i = 1, #deck do
				if deck[i].type == ACTION_TYPE_MODIFIER and deck[i].id ~= "NS_MIMICMODIFIER" and deck[i].id ~= "NS_MIMICMODIFIER2" then
					local action = deck[i].action
					action()
					action()
					return
				end
			end
			draw_actions(1, true)
		end,
	},
}