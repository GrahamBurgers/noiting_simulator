local me = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(me)
local dmg = EntityGetFirstComponent(me, "DamageModelComponent")
if dmg and ComponentGetValue2(dmg, "hp") < ComponentGetValue2(dmg, "max_hp") then
	GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
	local healing = -0.04 * (1.5 ^ (tonumber(GlobalsGetValue("SPELL_HONEY_COUNT", "0")) or 0))
	EntityInflictDamage(me, healing, "DAMAGE_HEALING", "$ns_n_honey", "NONE", 0, 0, me)
end