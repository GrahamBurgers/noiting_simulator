local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local root = EntityGetRootEntity(me)
-- commander
local is_in_hand = EntityGetFirstComponent(me, "VariableStorageComponent", "hand_checker") ~= nil
local controls = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
local item = EntityGetFirstComponentIncludingDisabled(me, "ItemComponent")
local inworld = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "item_identified")
if not (controls and item and inworld) then return end

local cooldown = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame")
if is_in_hand and controls and ComponentGetValue2(controls, "mButtonDownThrow") and cooldown < GameGetFrameNum() then
	local current = ComponentGetValue2(item, "ui_sprite")
	if current == nil or current == "" then
		current = "mods/noiting_simulator/files/spells/limiter.png"
	end
	local sprite = (current == "mods/noiting_simulator/files/spells/limiter.png" and "limiter2.png") or
		(current == "mods/noiting_simulator/files/spells/limiter2.png" and "limiter3.png") or
		"limiter.png"
	local file = "mods/noiting_simulator/files/spells/" .. sprite
	local emitter = "mods/noiting_simulator/files/spells/explosions/" .. sprite
	ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", GameGetFrameNum() + 30)

	ComponentSetValue2(item, "ui_sprite", file)
	ComponentSetValue2(inworld, "image_file", file)
	EntityRefreshSprite(me, inworld)

	local particle = EntityLoad("mods/noiting_simulator/files/spells/explosions/limiter.xml", x, y - 2)
	local p = EntityAddComponent2(particle, "ParticleEmitterComponent", {
		emitted_material_name="spark_blue",
		lifetime_min=0.3,
		lifetime_max=0.6,
		count_min=3,
		count_max=3,
		render_on_grid=true,
		fade_based_on_lifetime=true,
		cosmetic_force_create=false,
		airflow_force=0,
		emission_interval_min_frames=1,
		emission_interval_max_frames=1,
		emit_cosmetic_particles=true,
		image_animation_file=emitter,
		image_animation_speed=30,
		image_animation_loop=false,
		image_animation_raytrace_from_center=false,
		is_emitting=true,
	})
	ComponentSetValue2(p, "gravity", 0, 0)
	ComponentSetValue2(p, "area_circle_radius", 0, 0)
end