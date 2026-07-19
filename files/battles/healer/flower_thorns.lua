function collision_trigger(colliding_entity_id)
	local me = GetUpdatedEntityID()
	local x, y = EntityGetTransform(me)
	local x2, y2 = EntityGetTransform(colliding_entity_id)
	local projcomp = EntityGetFirstComponent(me, "ProjectileComponent")
	if y2 > y + 5 and projcomp and EntityGetHerdRelation(me, colliding_entity_id) < 50 then
		dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
		ProjHit(me, projcomp, colliding_entity_id, 1, x2, y2, ComponentGetValue2(projcomp, "mWhoShot"))
	end
end