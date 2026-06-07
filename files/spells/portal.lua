local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not (sprite and proj) then return end
local size = 6

local function init()
	local my_id = 0
	local invalid_id = true
	local portals = EntityGetWithTag("portal")
	local possible_pair = nil
	while invalid_id do
		my_id = my_id + 1
		invalid_id = false
		possible_pair = nil
		for i = 1, #portals do
			local c = EntityGetFirstComponent(portals[i], "LuaComponent", "portal_logic")
			if c and ComponentGetValue2(c, "limit_how_many_times_per_frame") == my_id then
				if possible_pair then
					invalid_id = true
					break
				else
					possible_pair = portals[i]
				end
			end
		end
	end
	ComponentSetValue2(this, "limit_how_many_times_per_frame", my_id)
	local img = "mods/noiting_simulator/files/spells/gfx/portal_" .. tostring(my_id) .. ".xml"
	if not ModDoesFileExist(img) then
		-- NOPE!
		EntityKill(me)
		return
	end
	ComponentSetValue2(sprite, "image_file", img)
	EntityRefreshSprite(me, sprite)
	if possible_pair then -- pair up <3
		local c = EntityGetFirstComponent(possible_pair, "LuaComponent", "portal_logic") or 0
		ComponentSetValue2(c, "limit_to_every_n_frame", me)
		ComponentSetValue2(this, "limit_to_every_n_frame", possible_pair)
	end
end

local my_pair = ComponentGetValue2(this, "limit_to_every_n_frame")
if ComponentGetValue2(this, "mTimesExecuted") == 0 or (not EntityGetIsAlive(my_pair)) or (my_pair == me) then
	init()
else
	local proj2 = EntityGetFirstComponentIncludingDisabled(my_pair, "ProjectileComponent")
	if proj and proj2 then
		local lifetime1 = ComponentGetValue2(proj, "lifetime")
		local lifetime2 = ComponentGetValue2(proj2, "lifetime")
		if lifetime1 > 0 and lifetime2 > 0 and math.abs(lifetime1 - lifetime2) > 1 then
			-- this is weird
			if lifetime1 > lifetime2 then
				lifetime1, lifetime2 = lifetime2, lifetime1
				proj, proj2 = proj2, proj
			end
			ComponentSetValue2(proj, "lifetime", lifetime1 + 1)
			ComponentSetValue2(proj2, "lifetime", lifetime2 - 1)
		end
	end
	local projs = EntityGetInRadiusWithTag(x, y, size, "projectile")
	for i = 1, #projs do
		local yes_go = true
		local comps = EntityGetComponentIncludingDisabled(projs[i], "LuaComponent", "portal_no_go") or {}
		for j = 1, #comps do
			if ComponentGetValue2(comps[j], "limit_how_many_times_per_frame") == me then
				yes_go = false
				break
			end
		end
		if (not EntityHasTag(projs[i], "portal")) and yes_go then
			local x2, y2 = EntityGetTransform(my_pair)
			local x3, y3 = EntityGetTransform(projs[i])
			local rx, ry = x3 - x, y3 - y
			EntitySetTransform(projs[i], x2 + rx, y2 + ry)
			EntityAddComponent2(projs[i], "LuaComponent", {
				_tags="portal_no_go",
				script_source_file="mods/noiting_simulator/files/spells/portal_cooldown.lua",
				limit_how_many_times_per_frame=my_pair,
			})
			local particle = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "portal_poof")
			if particle then
				ComponentSetValue2(particle, "is_emitting", true)
				ComponentSetValue2(particle, "m_next_emit_frame", GameGetFrameNum())
			end
			local particle2 = EntityGetFirstComponentIncludingDisabled(my_pair, "ParticleEmitterComponent", "portal_poof")
			if particle2 then
				ComponentSetValue2(particle2, "is_emitting", true)
				ComponentSetValue2(particle2, "m_next_emit_frame", GameGetFrameNum())
			end
		end
	end
end