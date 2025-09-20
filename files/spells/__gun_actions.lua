---@diagnostic disable: undefined-global, lowercase-global
--[[ CUSTOM STUFF SUMMARY:
Melee damage:  CUTE damage
Slice damage:  CHARMING damage
Fire damage:   CLEVER damage
Ice damage:    COMEDIC damage

Healing damage:     Lifetime  (DOES get read on init, add healing to add lifetime)
Holy damage:        Bounces   (DOES NOT get read, only for tooltips. Keep synced with the bounces_left value in ProjectileComponent)
Curse damage:       Knockback (DOES NOT get read, only for tooltips. Keep synced with the knockback_force value in ProjectileComponent)
Projectile damage:  Chg. Time (DOES NOT get read, only for tooltips. Keep synced with the charge_time value in _gun_list.lua)

play_damage_sounds:             Whether or not the projectile deals damage + knockback on collision with a heart.
on_collision_die:               Works as normal. Independent from play_damage_sounds.
damage_scale_max_speed:         Damage multiplier, works for projectiles and explosions. 1.0 = 100% (normal) damage.
collide_with_shooter_frames:    Frame count until this projectile becomes active. Default 1.
blood_count_multiplier:         Projectile hitbox size. Basically just a radius increase.
ragdoll_force_multiplier:       Gravity x. Works while projectile is in terrain. Don't set this; gravity_x in VelocityComponent will do it automatically.
hit_particle_force_multiplier:  Gravity y. Works while projectile is in terrain. Don't set this; gravity_y in VelocityComponent will do it automatically.

HEALING and PROJECTILE damage multipliers should always be at 1.0. EntityInflictDamage using these when needed to heal and damage universally.
]]--
to_insert = dofile_once("mods/noiting_simulator/files/spells/__gun_list.lua")

actions = {}
local len = #actions
for i=1, #to_insert do
	to_insert[i].custom_xml_file = "mods/noiting_simulator/files/spells/_card.xml"
	to_insert[i].spawn_level = "0,1,2,3,4,5,6,7,8,9,10"
	to_insert[i].spawn_probability = "1,1,1,1,1,1,1,1,1,1,1"
	to_insert[i].price = 1
	actions[len+i] = to_insert[i]
end