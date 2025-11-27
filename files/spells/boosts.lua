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

local amount = 1.25
local boosts = {
    ["CUTE"] = function()
        local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "melee")
        ComponentObjectSetValue2(proj, "damage_by_type", "melee", dmg * amount)
        set("magic_gas_polymorph")
    end,
    ["CHARMING"] = function()
        local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "slice")
        ComponentObjectSetValue2(proj, "damage_by_type", "slice", dmg * amount)
        set("spark_yellow")
    end,
    ["CLEVER"] = function()
        local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
        ComponentObjectSetValue2(proj, "damage_by_type", "fire", dmg * amount)
        set("spark_blue")
    end,
    ["COMEDIC"] = function()
        local dmg = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
        ComponentObjectSetValue2(proj, "damage_by_type", "ice", dmg * amount)
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