local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
if ComponentGetValue2(this, "mTimesExecuted") == 0 then
	local frame = GameGetFrameNum()
	local str = "castcharming" .. tostring(frame)
	EntityAddTag(me, str)
	ComponentSetValue2(this, "script_material_area_checker_success", str)

	local list = EntityGetWithTag(str)
	if #list % 2 == 0 then
		local p = EntityGetComponent(me, "ParticleEmitterComponent", "quantum") or {}
		for i = 1, #p do
			ComponentSetValue2(p[i], "emitted_material_name", "ns_paint_blue_transparent")
		end
	end
end
EntityRemoveTag(me, "charmy_zap")