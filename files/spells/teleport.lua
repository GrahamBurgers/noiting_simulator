local me = GetUpdatedEntityID()
EntityAddComponent2(me, "TeleportProjectileComponent", {
    min_distance_from_wall=4
})