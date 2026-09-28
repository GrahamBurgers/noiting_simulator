function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	GlobalsSetValue("LAST_DAMAGE_TAKEN_FRAME", tostring(GameGetFrameNum()))
end