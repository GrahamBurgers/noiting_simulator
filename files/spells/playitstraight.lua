local me = GetUpdatedEntityID()
local hurt = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "comedic_hurt_multiplier") or
	EntityAddComponent2(me, "VariableStorageComponent", {_tags="comedic_hurt_multiplier"})
	ComponentSetValue2(hurt, "value_float", 0)
local heal = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "comedic_heal_multiplier") or
	EntityAddComponent2(me, "VariableStorageComponent", {_tags="comedic_heal_multiplier"})
	ComponentSetValue2(heal, "value_float", 0)
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local part = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
for i = 1, #part do
    if proj and ComponentObjectGetValue2(proj, "damage_by_type", "ice") > 0 and ComponentGetValue2(part[i], "emitted_material_name") == "spark_green" then
        -- dull particles somewhat
        ComponentSetValue2(part[i], "friction", ComponentGetValue2(part[i], "friction") * 2)
        local gx, gy = ComponentGetValue2(part[i], "gravity")
        ComponentSetValue2(part[i], "gravity", gx, gy + 150)
        ComponentSetValue2(part[i], "emitted_material_name", "ice_meteor_static")
    end
end