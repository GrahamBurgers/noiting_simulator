local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local boost = ComponentGetValue2(GetUpdatedComponentID(), "script_electricity_receiver_switched")
local function set(material)
    local particles = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
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