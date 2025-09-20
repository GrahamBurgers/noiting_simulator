local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local boost = ComponentGetValue2(proj, "blood_count_multiplier") + 3
ComponentSetValue2(proj, "blood_count_multiplier", boost)
local sprite = EntityGetFirstComponent(me, "SpriteComponent", "cherish")
if not sprite then
    sprite = EntityAddComponent2(me, "SpriteComponent", {
        _tags="cherish",
        image_file="mods/noiting_simulator/files/spells/cherish_field.png",
        emissive=true,
        additive=true,
        special_scale_x=1,
        special_scale_y=1,
        offset_x=3.5,
        offset_y=3.5,
        has_special_scale=true,
        z_index=-6,
    })
end
ComponentSetValue2(sprite, "special_scale_x", boost / 3.5)
ComponentSetValue2(sprite, "special_scale_y", boost / 3.5)
EntityRefreshSprite(me, sprite)