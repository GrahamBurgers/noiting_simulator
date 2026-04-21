function damage_about_to_be_received( damage, dx, dy, entity_thats_responsible, crit_hit_chance)
    local me = GetUpdatedEntityID()
    local dmg = EntityGetFirstComponent(me, "DamageModelComponent")
    if not dmg then return end
	if EntityGetWithName("dummy") > 0 then damage = math.min(damage, ComponentGetValue2(dmg, "hp") - 0.04) end
    if ComponentGetValue2(dmg, "hp") - damage <= 0 then
        ComponentSetValue2(dmg, "hp", 0)
        if (GlobalsGetValue("NS_BATTLE_DEATHFRAME", "0") == "0") then
            GlobalsSetValue("NS_BATTLE_DEATHFRAME", tostring(GameGetFrameNum()))
        end
        return 0, 0
    end
    local x, y = EntityGetTransform(me)

    -- sparkles perk
    local sparkles = tonumber(GlobalsGetValue("SPELL_SPARKLES_COUNT", "0")) or 0
    if sparkles > 0 and damage > 0 then
        SetRandomSeed(me + GameGetFrameNum(), damage + 389508)
		dofile_once("data/scripts/lib/utilities.lua")

		local how_many = math.max(1, math.ceil(damage * 25)) * sparkles

		dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
		Shoot({file = "mods/noiting_simulator/files/spells/sparkle.xml", deg_random = 360, count = how_many, deg_between = 360 / how_many, speed_random_per = 20, whoshot = me, comedic_multiplier = 0})
    end

	local puppydamage = tonumber(GlobalsGetValue("SPELL_PUPPYDOG_DAMAGE", "0"))
	if damage > 0 then
		GlobalsSetValue("SPELL_PUPPYDOG_DAMAGE", tostring(math.max(0.48, puppydamage + damage)))
	else
		GlobalsSetValue("SPELL_PUPPYDOG_DAMAGE", tostring(puppydamage + damage / 2))
	end

    -- snapshot modifier
    SetRandomSeed(x + damage + me, y + 249502940 + entity_thats_responsible + GameGetFrameNum())
    if entity_thats_responsible ~= me and EntityGetIsAlive(entity_thats_responsible) and EntityGetWithTag("snapshot") and Random(1, 100) > 25 then
        local thingy = EntityGetWithTag("snapshot")[1]
        local x2, y2 = EntityGetTransform(thingy)
        if thingy and x2 and y2 and EntityGetIsAlive(thingy) then
            EntityApplyTransform(thingy, x, y)
            EntityApplyTransform(me, x2, y2)
            EntityRemoveTag(thingy, "snapshot")

            EntityLoad("data/entities/particles/teleportation_source.xml", x, y - 2)
            EntityLoad("data/entities/particles/teleportation_target.xml", x2, y2 - 2)
            GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/teleport/tick", x2, y2)

            local sprite = EntityGetFirstComponent(thingy, "SpriteComponent", "snapshot")
            if sprite then EntityRemoveComponent(thingy, sprite) end
            local char = EntityGetFirstComponent(me, "CharacterDataComponent")
            if char then ComponentSetValue2(char, "mVelocity", 0, 0) end
            return 0, 0
        end
    end
    return damage, crit_hit_chance
end