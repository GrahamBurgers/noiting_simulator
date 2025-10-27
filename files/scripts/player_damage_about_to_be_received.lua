function damage_about_to_be_received( damage, x, y, entity_thats_responsible, crit_hit_chance )
    local me = GetUpdatedEntityID()
    SetRandomSeed(x + damage + me, y + 249502940 + entity_thats_responsible + GameGetFrameNum())
    if entity_thats_responsible ~= me and EntityGetIsAlive(entity_thats_responsible) and EntityGetWithTag("snapshot") and Random(1, 100) > 25 then
        local thingy = EntityGetWithTag("snapshot")[1]
        local x2, y2 = EntityGetTransform(thingy)
        if thingy and x2 and y2 and EntityGetIsAlive(thingy) then
            EntityApplyTransform(thingy, x, y)
            EntityApplyTransform(me, x2, y2)
            EntityRemoveTag(thingy, "snapshot")

            EntityLoad("data/entities/particles/teleportation_source.xml", x, y)
            EntityLoad("data/entities/particles/teleportation_target.xml", x2, y2)
            GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", x2, y2)

            local sprite = EntityGetFirstComponent(thingy, "SpriteComponent", "snapshot")
            if sprite then EntityRemoveComponent(thingy, sprite) end
            local char = EntityGetFirstComponent(me, "CharacterDataComponent")
            if char then ComponentSetValue2(char, "mVelocity", 0, 0) end
            return 0, 0
        end
    end
    if EntityGetWithName("Dummy") > 0 then return damage / 1200, 0 end
    return damage, crit_hit_chance
end