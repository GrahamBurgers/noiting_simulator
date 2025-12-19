local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
local boost = ComponentGetValue2(proj, "blood_count_multiplier") + 6
local sprite = EntityGetFirstComponent(me, "SpriteComponent", "breaker")
if not sprite then
    sprite = EntityAddComponent2(me, "SpriteComponent", {
        _tags="breaker",
        image_file="mods/noiting_simulator/files/spells/breaker_field.png",
        emissive=true,
        additive=true,
        special_scale_x=1,
        special_scale_y=1,
        offset_x=7,
        offset_y=7,
        has_special_scale=true,
        z_index=-6,
    })
end
ComponentSetValue2(sprite, "special_scale_x", boost / 7)
ComponentSetValue2(sprite, "special_scale_y", boost / 7)
EntityAddComponent2(me, "VariableStorageComponent", {
    _tags="hitbox",
    name="hitbox",
    value_float=boost,
})