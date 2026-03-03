local me = GetUpdatedEntityID()
local comps = EntityGetAllComponents(me)
for i = 1, #comps do
	if ComponentHasTag(comps[i], "enabled_in_world2") then
		ComponentAddTag(comps[i], "enabled_in_world")
		ComponentRemoveTag(comps[i], "enabled_in_world2")
	end
end