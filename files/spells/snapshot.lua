local me = GetUpdatedEntityID()
local current = EntityGetWithTag("snapshot") or {}
for i = 1, #current do
    EntityRemoveTag(current[i], "snapshot")
    local sprite = EntityGetFirstComponent(current[i], "SpriteComponent", "snapshot")
    if sprite then EntityRemoveComponent(current[i], sprite) end
end
local sprite = EntityGetFirstComponent(me, "SpriteComponent", "snapshot")
if not sprite then
    sprite = EntityAddComponent2(me, "SpriteComponent", {
        _tags="snapshot",
        image_file="mods/noiting_simulator/files/spells/snapshot_field.png",
        emissive=true,
        additive=true,
        special_scale_x=1,
        special_scale_y=1,
        offset_x=5.5,
        offset_y=5.5,
        alpha=0.75,
        update_transform_rotation=false,
        z_index=-6.1,
    })
end
EntityAddTag(me, "snapshot")