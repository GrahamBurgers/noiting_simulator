local me = GetUpdatedEntityID()
EntityAddTag(me, "comedic_noheal")
EntityAddTag(me, "comedic_nohurt")
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