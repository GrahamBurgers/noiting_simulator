-- lots of repetition in this file so SUE ME
return {
	get_mult = function(me, tag)
		local multiplier = 1
		local comps = EntityGetComponent(me, "VariableStorageComponent", tag) or {}
		for i = 1, #comps do
			multiplier = multiplier * ComponentGetValue2(comps[i], "value_float")
		end
		return multiplier
	end,
    get_mult_with_id = function(me, id)
        local comps = EntityGetComponent(me, "VariableStorageComponent") or {}
        for i = 1, #comps do
            if (ComponentHasTag(comps[i], "dmg_mult_collision") or ComponentHasTag(comps[i], "dmg_mult_collision")) and ComponentGetValue2(comps[i], "name") == id then
                return ComponentGetValue2(comps[i], "value_float")
            end
        end
    end,
    add_mult = function(me, id, amount, tags)
        local comps = EntityGetComponent(me, "VariableStorageComponent") or {}
        for i = 1, #comps do
            if (ComponentHasTag(comps[i], "dmg_mult_collision") or ComponentHasTag(comps[i], "dmg_mult_collision")) and ComponentGetValue2(comps[i], "name") == id then
                ComponentSetValue2(comps[i], "value_float", ComponentGetValue2(comps[i], "value_float") + amount)
                return comps[i]
            end
        end
        -- no comp was found
        return EntityAddComponent2(me, "VariableStorageComponent", {
            _tags=tags,
            name=id,
            value_float=1 + amount,
        })

    end,
    set_mult = function(me, id, amount, tags)
        local comps = EntityGetComponent(me, "VariableStorageComponent") or {}
        for i = 1, #comps do
            if (ComponentHasTag(comps[i], "dmg_mult_collision") or ComponentHasTag(comps[i], "dmg_mult_collision")) and ComponentGetValue2(comps[i], "name") == id then
                ComponentSetValue2(comps[i], "value_float", amount)
                return comps[i]
            end
        end
        -- no comp was found
        return EntityAddComponent2(me, "VariableStorageComponent", {
            _tags=tags,
            name=id,
            value_float=amount,
        })

    end,
}