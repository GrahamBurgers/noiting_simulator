local me = GetUpdatedEntityID()
local player = EntityGetRootEntity(me)
local x, y = EntityGetTransform(player)
Is_all_buttons_frames = Is_all_buttons_frames or 0
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
if not controls then return end

local particle = EntityGetFirstComponent(me, "ParticleEmitterComponent")
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
if not particle then
	particle = EntityAddComponent2(me, "ParticleEmitterComponent", {
		emitted_material_name="spark_red",
		lifetime_min=6/60,
		lifetime_max=6/60,
		custom_alpha=0.5,
		count_min=2,
		count_max=4,
		render_on_grid=true,
		fade_based_on_lifetime=false,
		cosmetic_force_create=true,
		airflow_force=0,
		airflow_time=0,
		airflow_scale=0,
		emission_interval_min_frames=1,
		emission_interval_max_frames=1,
		emit_cosmetic_particles=true,
		draw_as_long=true,
		x_vel_min=0,
		x_vel_max=0,
		y_vel_min=0,
		y_vel_max=0,
		is_emitting=true,
		velocity_always_away_from_center=0
	})
	ComponentSetValue2(particle, "gravity", 0, 0)
	ComponentSetValue2(particle, "area_circle_radius", 10, 12)
end
if not sprite then
	sprite = EntityAddComponent2(me, "SpriteComponent", {
		image_file="mods/noiting_simulator/files/gui/explode_skull.png",
		offset_x=19/2,
		offset_y=16/2,
		alpha=0,
		update_transform_rotation=false,
		emissive=true,
	})
end

if Is_all_buttons_frames < 0 then
	ComponentSetValue2(sprite, "alpha", 0)
	ComponentSetValue2(particle, "count_min", 0)
	ComponentSetValue2(particle, "count_max", 0)
	dofile_once("mods/noiting_simulator/files/scripts/player_inputs.lua")()
	Is_all_buttons_frames = Is_all_buttons_frames + 1
	local dmg = EntityGetFirstComponent(player, "DamageModelComponent")
	if dmg and Is_all_buttons_frames == 0 then
		ComponentSetValue2(dmg, "hp", 0)
		EntityInflictDamage(player, 0.04, "DAMAGE_PROJECTILE", "???", "NONE", 0, 0, player)
	end
	return
end

local max_explode_frames = ModSettingGet("noiting_simulator.cheatcode_explode") and 2 or (3 * 60)
local is_all_buttons = ComponentGetValue2(controls, "mButtonDownLeft") and
	ComponentGetValue2(controls, "mButtonDownRight") and
	ComponentGetValue2(controls, "mButtonDownFly") and
	ComponentGetValue2(controls, "mButtonDownDown")
if Is_all_buttons_frames > 0 then
	local inputs = dofile_once("mods/noiting_simulator/files/scripts/player_inputs.lua")()
	is_all_buttons = (inputs.left and inputs.right and inputs.up and inputs.down) or is_all_buttons
end
local alpha = ComponentGetValue2(sprite, "alpha")
if is_all_buttons then
	Is_all_buttons_frames = Is_all_buttons_frames + 1
	ComponentSetValue2(sprite, "alpha", alpha + (1 - alpha) / (max_explode_frames / 35))
else
	Is_all_buttons_frames = 0
	ComponentSetValue2(sprite, "alpha", alpha + (0 - alpha) / (max_explode_frames / 35))
end

local amount = (Is_all_buttons_frames / max_explode_frames) * 360
ComponentSetValue2(particle, "area_circle_sector_degrees", amount)
ComponentSetValue2(particle, "count_min", amount)
ComponentSetValue2(particle, "count_max", amount)

local turn = (math.pi / -2) + ((amount / 360) * math.pi)
EntitySetTransform(me, x, y - 30, turn)

if Is_all_buttons_frames >= max_explode_frames then
	Is_all_buttons_frames = -3
	EntityLoad("mods/noiting_simulator/files/spells/manual_explosion.xml", x, y)
end