local me = GetUpdatedEntityID()
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not proj then return end
EntityAddComponent2(me, "VariableStorageComponent", {
    _tags="hitbox",
    name="hitbox",
    value_float=ComponentGetValue2(proj, "blood_count_multiplier") + 4,
})