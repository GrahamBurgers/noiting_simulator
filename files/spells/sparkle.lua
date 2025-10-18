local me = GetUpdatedEntityID()
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if me and sprite and proj and vel then
    SetRandomSeed(me + proj + GetUpdatedComponentID(), sprite + GameGetFrameNum() + GetUpdatedComponentID())
    local dmg = 2
    local type = Random(1, 4)
    if type == 1 then
        ComponentSetValue2(sprite, "rect_animation", "cute")
        ComponentObjectSetValue2(proj, "damage_by_type", "melee", ComponentObjectGetValue2(proj, "damage_by_type", "melee") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "data/particles/explosion_008_pink.xml")
    elseif type == 2 then
        ComponentSetValue2(sprite, "rect_animation", "comedic")
        ComponentObjectSetValue2(proj, "damage_by_type", "ice", ComponentObjectGetValue2(proj, "damage_by_type", "ice") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "data/particles/explosion_008_plasma_green.xml")
        EntityAddTag(me, "comedic_noheal")
        EntityAddTag(me, "comedic_nohurt")
    elseif type == 3 then
        ComponentSetValue2(sprite, "rect_animation", "charming")
        ComponentObjectSetValue2(proj, "damage_by_type", "slice", ComponentObjectGetValue2(proj, "damage_by_type", "slice") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "data/particles/explosion_008.xml")
    else
        ComponentSetValue2(sprite, "rect_animation", "clever")
        ComponentObjectSetValue2(proj, "damage_by_type", "fire", ComponentObjectGetValue2(proj, "damage_by_type", "fire") + dmg / 25)
        ComponentObjectSetValue2(proj, "config_explosion", "explosion_sprite", "mods/noiting_simulator/files/spells/explosions/008_blue.xml")
    end
    ComponentSetValue2(sprite, "visible", true)
    EntityRefreshSprite(me, sprite)
end