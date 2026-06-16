local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local boost = ComponentGetValue2(GetUpdatedComponentID(), "script_electricity_receiver_switched")
local function set(material)
		local p = EntityAddComponent2(me, "ParticleEmitterComponent", {
		_tags="proj_enable",
		render_on_grid=true,
		cosmetic_force_create=true,
		count_min=1,
		count_max=4,
		custom_alpha=0.4,
		draw_as_long=false,
		emission_interval_min_frames=1,
		emission_interval_max_frames=1,
		emit_cosmetic_particles=true,
		emit_only_if_there_is_space=false,
		emit_real_particles=false,
		emitted_material_name="magic_gas_polymorph",
		fade_based_on_lifetime=true,
		fire_cells_dont_ignite_damagemodel=true,
		is_emitting=true,
		is_trail=true,
		lifetime_min=0.5,
		lifetime_max=0.5,
		particle_single_width=true,
		render_back=true,
		velocity_always_away_from_center=0,
		friction=8,
	})
	ComponentSetValue2(p, "gravity", 0, 0)
	ComponentSetValue2(p, "area_circle_radius", 0, 0)
	EntitySetComponentIsEnabled(me, p, true)

    local particles = EntityGetComponent(me, "ParticleEmitterComponent") or {}

    for i = 1, #particles do
        ComponentSetValue2(particles[i], "emitted_material_name", material)
    end
end

local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
local amount = 0.5
local boosts = {
    ["CUTE"] = function()
		q.add_mult(me, "boost_cute", amount, "dmg_mult_cute")
        set("magic_gas_polymorph")
    end,
    ["CHARMING"] = function()
		q.add_mult(me, "boost_charming", amount, "dmg_mult_charming")
        set("spark_yellow")
    end,
    ["CLEVER"] = function()
		q.add_mult(me, "boost_clever", amount, "dmg_mult_clever")
        set("spark_blue")
    end,
    ["COMEDIC"] = function()
		q.add_mult(me, "boost_comedic", amount, "dmg_mult_comedic")
        set("spark_green")
    end,
}
if boosts[boost] then
    boosts[boost]()
else
    SetRandomSeed(me + 4250459, -314660)
    amount = 2
    local choices = {"CUTE", "CHARMING", "CLEVER", "COMEDIC"}
    boosts[choices[Random(1, #choices)]]()
end