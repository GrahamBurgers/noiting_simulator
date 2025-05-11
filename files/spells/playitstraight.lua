local me = GetUpdatedEntityID()
EntityAddTag(me, "comedic_noheal")
EntityAddTag(me, "comedic_nohurt")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local part = EntityGetComponentIncludingDisabled(me, "ParticleEmitterComponent") or {}
for i = 1, #part do
    if proj and ComponentObjectGetValue2(proj, "damage_by_type", "ice") > 0 then
        ComponentSetValue2(part[i], "emitted_material_name", "plasma_fading_pink")
    end
end