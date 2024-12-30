-- cloth_color, cloth_color_edge
CapeColors = {
    ["cooldown"] = {-15068647, -12172218},
    ["flash"] = {-5000269, -2105377},

    ["dash"] = {-4290757, -3291532},
    ["parry"] = {-12679465, -14397256},
}

function ColorCape(entity, name)
    local children = EntityGetAllChildren(entity) or {}
	for i = 1, #children do
		if EntityGetName(children[i]) == "cape" then
            local v = EntityGetFirstComponent(children[i], "VerletPhysicsComponent")
            if v then
                ComponentSetValue2(v, "cloth_color", CapeColors[name][1])
                ComponentSetValue2(v, "cloth_color_edge", CapeColors[name][2])
            end
		end
	end
end

function Cape(entity, name)
    local nextframe = tonumber(GlobalsGetValue("NS_CAPE_NEXT_FRAME", "-999"))
    local frame = GameGetFrameNum()
    if frame >= nextframe then
        ColorCape(entity, name)
    elseif frame >= nextframe - 6 then
        ColorCape(entity, "flash")
    else
        ColorCape(entity, "cooldown")
    end
end