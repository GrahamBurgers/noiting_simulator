function interacting(entity_who_interacted, entity_interacted, interactable_name)
    local sprite = EntityGetFirstComponentIncludingDisabled(entity_interacted, "SpriteComponent", "box")
    local interact = EntityGetFirstComponentIncludingDisabled(entity_interacted, "InteractableComponent")
    if not (sprite and interact) then return end
    local anim = ComponentGetValue2(sprite, "rect_animation")
    local x, y = EntityGetTransform(entity_interacted)
    if anim ~= "open" then
        GlobalsSetValue("NS_CAM_OVERRIDE_X", tostring(x))
        GlobalsSetValue("NS_CAM_OVERRIDE_Y", tostring(y - 75))
        GlobalsSetValue("NS_STORAGE_BOX_FRAME", tostring(GameGetFrameNum()))
        ComponentSetValue2(sprite, "rect_animation", "open")
        ComponentSetValue2(interact, "radius", 100000)
        EntityRefreshSprite(entity_interacted, sprite)
    else
        ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", 1)
    end
end