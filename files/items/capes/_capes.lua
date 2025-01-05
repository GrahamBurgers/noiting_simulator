-- cloth_color, cloth_color_edge
CapeColors = {
    ["cooldown"] = {-15068647, -12172218},
    ["flash"] = {-5000269, -2105377},

    ["dash"] = {-4290757, -3291532},
    ["parry"] = {-12679465, -14397256},
    ["clock"] = {-12658779, -13985984},
    ["amp"] = {-11184651, -14997097},
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

function CapeShoot(owner, file, x, y, cooldown, parent)
    local modCooldown = tonumber(GlobalsGetValue("CAPE_MOD_COOLDOWN", "1"))
    local modLifetime = tonumber(GlobalsGetValue("CAPE_MOD_LIFETIME", "1"))

    local entity = EntityLoad(file, x, y)
	local comps = EntityGetComponentIncludingDisabled(entity, "ProjectileComponent") or {}
	for i = 1, #comps do
		ComponentSetValue2(comps[i], "mShooterHerdId", StringToHerdId("player"))
		ComponentSetValue2(comps[i], "mWhoShot", owner)
		ComponentSetValue2(comps[i], "mEntityThatShot", GetUpdatedEntityID())
        local lifetime = math.ceil(ComponentGetValue2(comps[i], "lifetime") * modLifetime)
        ComponentSetValue2(comps[i], "lifetime", lifetime)
        ComponentSetValue2(comps[i], "mStartingLifetime", lifetime)
	end
    if parent then EntityAddChild(owner, entity) end
    if cooldown then
        GlobalsSetValue("NS_CAPE_NEXT_FRAME", tostring(GameGetFrameNum() + math.ceil(cooldown * 60 * modCooldown)))
    end
    return entity
end