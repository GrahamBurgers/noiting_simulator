local me = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(me)
local dmg = EntityGetFirstComponent(me, "DamageModelComponent")
if dmg and ComponentGetValue2(dmg, "hp") < ComponentGetValue2(dmg, "max_hp") then
	GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
	EntityInflictDamage(me, -0.04, "DAMAGE_HEALING", "$ns_n_honey", "NONE", 0, 0, me)
end