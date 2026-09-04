local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
if ComponentGetValue2(this, "mTimesExecuted") == 0 then
	local frame = GameGetFrameNum()
	local str = "castclever" .. tostring(frame)
	EntityAddTag(me, str)
	ComponentSetValue2(this, "script_material_area_checker_success", str)

	local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
	local list = EntityGetWithTag(str)
	for i = 1, #list do
		local proj2 = EntityGetFirstComponentIncludingDisabled(list[i], "ProjectileComponent")
		if proj and proj2 and (proj ~= proj2) then
			local function ugh(comp, comp2, id)
				local big = math.max(ComponentObjectGetValue2(comp, "damage_by_type", id), ComponentObjectGetValue2(comp2, "damage_by_type", id))
				ComponentObjectSetValue2(comp, "damage_by_type", id, big)
				ComponentObjectSetValue2(comp2, "damage_by_type", id, big)
			end
			-- ????
			ugh(proj, proj2, "melee")
			ugh(proj, proj2, "slice")
			ugh(proj, proj2, "fire")
			ugh(proj, proj2, "ice")
			ugh(proj, proj2, "drill")
		end
	end
end