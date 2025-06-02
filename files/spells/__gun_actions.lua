---@diagnostic disable: undefined-global, lowercase-global
--[[ CUSTOM STUFF SUMMARY:
Melee damage:  CUTE damage
Slice damage:  CHARMING damage
Fire damage:   CLEVER damage
Ice damage:    COMEDIC damage

Healing damage:     Lifetime (DOES get read on init, add healing to add lifetime)
Holy damage:        Bounces (DOES NOT get read, only for tooltips)
Curse damage:       Knockback (DOES NOT get read, only for tooltips)
Projectile damage:  Proj. count (DOES NOT get read, only for tooltips.)

play_damage_sounds:             Whether or not the projectile deals damage + knockback on collision with a heart.
on_collision_die:               Works as normal. Independent from play_damage_sounds.
damage_scale_max_speed:         Damage multiplier, works for projectiles and explosions. 1.0 = 100% (normal) damage.
collide_with_shooter_frames:    Frame count until this projectile becomes active. Default 1.
blood_count_multiplier:         Projectile hitbox size. Basically just a radius increase.
ragdoll_force_multiplier:       Gravity x. Works while projectile is in terrain. Don't set this; gravity_x in VelocityComponent will do it automatically.
hit_particle_force_multiplier:  Gravity y. Works while projectile is in terrain. Don't set this; gravity_y in VelocityComponent will do it automatically.

HEALING and PROJECTILE damage multipliers should always be at 1.0. EntityInflictDamage using these when needed to heal and damage universally.
]]--
local to_insert = {
	{
		id                  = "NS_CUTE1",
		name                = "$n_ns_cute1",
		description         = "$d_ns_cute1",
		sprite              = "mods/noiting_simulator/files/spells/endear.png",
		type                = ACTION_TYPE_PROJECTILE,
		mana                = 0,
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
		id                  = "NS_CUTEHITBOX",
		name                = "$n_ns_cutehitbox",
		description         = "$d_ns_cutehitbox",
		sprite              = "mods/noiting_simulator/files/spells/cutehitbox.png",
		type                = ACTION_TYPE_MODIFIER,
		mana                = 0,
		action 	            = function()
			c.extra_entities = c.extra_entities .. "mods/noiting_simulator/files/spells/cutehitbox.xml,"
			c.damage_melee_add = c.damage_melee_add + 0.12
			c.knockback_force = c.knockback_force + 6
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

actions = {}
local len = #actions
for i=1, #to_insert do
	to_insert[i]["custom_xml_file"] = "mods/noiting_simulator/files/spells/_card.xml"
	to_insert[i]["spawn_level"] = "0,1,2,3,4,5,6,7,8,9,10"
	to_insert[i]["spawn_probability"] = "1,1,1,1,1,1,1,1,1,1,1"
	to_insert[i]["price"] = 1
	actions[len+i] = to_insert[i]
end