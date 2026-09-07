function kick(me)
	local x, y = EntityGetTransform(me)

	-- kick script
	local kick_radius = 2
	local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
	local hittable = EntityGetInRadiusWithTag(x, y, 128, "hittable")

	dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
	for i = 1, #hittable do
		if touchinghitbox(kick_radius, hittable[i], true) and hittable[i] ~= me then -- check herd? or kick friendlies?
			ProjHit(nil, nil, hittable[i], 1, x, y, me, {typeless = 0.04})
			if EntityHasTag(hittable[i], "heart") then
				local kicksksks = tonumber(GlobalsGetValue("KICKS_THIS_BATTLE", "0"))
				kicksksks = kicksksks + 1
				GlobalsSetValue("KICKS_THIS_BATTLE", tostring(kicksksks))
				if kicksksks == 30 then
					dofile("mods/noiting_simulator/files/wands/_list.lua")
					Generate_wand("oldreliable", x, y)
					EntityLoad("data/entities/particles/image_emitters/orb_effect.xml", x, y)
				end
			end
		end
	end

	local controls = EntityGetFirstComponent(me, "ControlsComponent")
	if not (controls) then return end
	local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
	local dir = math.atan2(dy or 0, -dx or 0)

	local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
	local spoopballs = EntityGetInRadiusWithTag(x, y, 140, "spoopball") or {}
	for i = 1, #spoopballs do
		local proj = EntityGetFirstComponent(spoopballs[i], "ProjectileComponent")
		local vel = EntityGetFirstComponent(spoopballs[i], "VelocityComponent")
		local lua = EntityGetFirstComponent(spoopballs[i], "LuaComponent", "spoopball")
		local particle = EntityGetFirstComponent(spoopballs[i], "ParticleEmitterComponent", "spoopball_bounce")
		if touchinghitbox(16, spoopballs[i], true) and vel and proj and lua and particle then
			local vx, vy = ComponentGetValue2(vel, "mVelocity")
			local magnitude = math.max(125, math.sqrt(vx^2 + vy^2)) + 25
			ComponentSetValue2(vel, "mVelocity", dx * magnitude, dy * magnitude)

			local starting_lifetime = ComponentGetValue2(proj, "mStartingLifetime")
			ComponentSetValue2(proj, "lifetime", math.max(ComponentGetValue2(proj, "lifetime"), starting_lifetime))
			ComponentSetValue2(proj, "mStartingLifetime", starting_lifetime - 10)
			ComponentSetValue2(proj, "bounces_left", ComponentGetValue2(lua, "limit_how_many_times_per_frame"))
			ComponentSetValue2(particle, "is_emitting", true)

			q.add_mult(spoopballs[i], "ballllllz", 0.75, "dmg_mult_collision,dmg_mult_explosion")
		end
	end

	dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
	local wave_kick_count = (tonumber(GlobalsGetValue("SPELL_WAVE_KICK_COUNT", "0")) or 0) * 3
	if wave_kick_count > 0 then
		Shoot({file = "mods/noiting_simulator/files/spells/wave_kick.xml", target = dir, count = wave_kick_count, deg_between = 90 / wave_kick_count, whoshot = me, do_muzzle_flash = true})
	end
end