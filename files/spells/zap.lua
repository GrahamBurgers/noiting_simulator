local function findtarget(x, y, radius, who_did_it)
	local target = nil
	local targets = EntityGetInRadiusWithTag(x, y, radius, "projectile") or {}
	while #targets > 0 do
		target = Random(1, #targets)
		local proj = EntityGetFirstComponent(targets[target], "ProjectileComponent")
		if (proj and ComponentGetValue2(proj, "mWhoShot") == who_did_it) and (not EntityHasTag(targets[target], "already_zapped")) then
			EntityAddTag(targets[target], "already_zapped")
			return targets[target], proj
		end
		table.remove(targets, target)
	end
end

function DoHit(who_got_hit, types, is_heart, v, x, y, who_did_it, component_id, proj_entity)
	local me = GetUpdatedEntityID()
	local list = EntityGetComponentIncludingDisabled(me, "VariableStorageComponent", "zap") or {}
	if component_id ~= list[1] then return end
	local radius = 64 * #list
	EntityAddTag(me, "already_zapped")
	local target = findtarget(x, y, radius, who_did_it)
	radius = radius * 0.75
	local time = 8
	while target do
		-- particles
		local x2, y2 = EntityGetTransform(target)
		local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
		local dx, dy = x2 - x, y2 - y
		local count = distance * 2
		for i = 1, count do
			x = x + dx / count
			y = y + dy / count
			time = time + 12 / 60
			GameCreateCosmeticParticle("ns_paint_pink_transparent", x, y, 1, 0, 0, nil, time / 30, time / 30, true, false, false, false, 0, 0)
		end
		x, y = x2, y2
		-- function
		-- dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
		-- ProjHit(target, proj, who_got_hit, 1, x, y, who_did_it)
		EntityAddComponent2(target, "VariableStorageComponent", {
			_tags="hit_this_entity_now",
			value_int=who_got_hit,
		})
		target = findtarget(x, y, radius, who_did_it)
	end
end