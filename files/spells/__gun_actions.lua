---@diagnostic disable: undefined-global, lowercase-global
--[[ CUSTOM STUFF SUMMARY:
Melee damage:  CUTE damage
Slice damage:  CHARMING damage
Fire damage:   CLEVER damage
Ice damage:    COMEDIC damage
Drill damage:  TYPELESS damage

Healing damage:     Lifetime  (DOES get read on init, add healing to add lifetime)
Holy damage:        Bounces   (DOES NOT get read, only for tooltips. Keep synced with the bounces_left value in ProjectileComponent)
Curse damage:       Knockback (DOES NOT get read, only for tooltips. Keep synced with the knockback_force value in ProjectileComponent)
Projectile damage:  Chg. Time (DOES NOT get read, only for tooltips. Keep synced with the charge_time value in _gun_list.lua)
Electric damage:    Lifetime Multiplier (DOES get read on init when not reflecting. Just use addlifetimemult)
Crit chance:        Lifetime Multiplier (DOES get read on init when reflecting. Just use addlifetimemult)

play_damage_sounds:                     Whether or not the projectile deals damage + knockback on collision with a heart.
on_collision_die:                       Works as normal. Independent from play_damage_sounds.
collide_with_shooter_frames:            Frame count until this projectile becomes active. Default 1.
blood_count_multiplier:                 Projectile hitbox size. Basically just a radius increase.
ragdoll_force_multiplier:               Gravity x. Works while projectile is in terrain. Don't set this; gravity_x in VelocityComponent will do it automatically.
hit_particle_force_multiplier:          Gravity y. Works while projectile is in terrain. Don't set this; gravity_y in VelocityComponent will do it automatically.
config_explosion:physics_throw_enabled: Whether or not the explosion does explosion things (knockback, projectile boost, and damage)

HEALING and PROJECTILE damage multipliers should always be at 1.0. EntityInflictDamage using these when needed to heal and damage universally.

unlock_flag         = "unlock_demo_flag",
]]--
actions = dofile_once("mods/noiting_simulator/files/spells/__gun_list.lua")

for i=1, #actions do
	local this = actions[i]
	this.name = this.name or ("$n_" .. string.lower(this.id))
	this.description = this.description or ("$d_" .. string.lower(this.id))
	this.custom_xml_file = this.custom_xml_file or "mods/noiting_simulator/files/spells/_card.xml"
	this.spawn_level = "0,1,2,3,4,5,6,7,8,9,10"
	this.spawn_probability = "1,1,1,1,1,1,1,1,1,1,1"
	this.price = 1
	this.is_unlocked = (this.unlock_flag == nil) or ModSettingGet("noiting_simulator.flag_" .. this.unlock_flag) or false
	this.is_discovered = ModSettingGet("noiting_simulator.spell_discovered_" .. this.id) or false
end