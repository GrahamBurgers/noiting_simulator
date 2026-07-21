function kick(me)
	local x, y = EntityGetTransform(me)

	-- kick script
	local kick_radius = 2
	local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
	local hittable = EntityGetInRadiusWithTag(x, y, 128, "hittable")

	dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
	for i = 1, #hittable do
		if touchinghitbox(kick_radius, hittable[i], true) then
			ProjHit(nil, nil, hittable[i], 1, x, y, me, {typeless = 0.04})
		end
	end

	local controls = EntityGetFirstComponent(me, "ControlsComponent")
	if not (controls) then return end
	local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
	local dir = math.atan2(dy or 0, -dx or 0)

	dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
	local wave_kick_count = (tonumber(GlobalsGetValue("SPELL_WAVE_KICK_COUNT", "0")) or 0) * 3
	if wave_kick_count > 0 then
		Shoot({file = "mods/noiting_simulator/files/spells/wave_kick.xml", target = dir, count = wave_kick_count, deg_between = 90 / wave_kick_count, whoshot = me, do_muzzle_flash = true})
	end
end