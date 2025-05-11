local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if proj and not EntityHasTag(me, "comedic_nohurt") then
    local whoshot = ComponentGetValue2(proj, "mWhoShot")
    local dmg_comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice") * ComponentGetValue2(proj, "damage_scale_max_speed")
    local dmg = EntityGetFirstComponent(whoshot, "DamageModelComponent")
    if whoshot and whoshot > 0 and dmg_comedic > 0 and dmg then
        EntityInflictDamage(whoshot, math.min(dmg_comedic, ComponentGetValue2(dmg, "hp") - 0.04), "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NONE", 0, 0, whoshot)
    end
end