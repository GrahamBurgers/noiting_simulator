function kick(me)
	local x, y = EntityGetTransform(me)

	-- kick script
	local kick_radius = 2
	local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
	local types = {typeless = 0.04}
	local hittable = EntityGetInRadiusWithTag(x, y, 128, "hittable")

	dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
	for i = 1, #hittable do
		if touchinghitbox(kick_radius, hittable[i], true) then
			DamageHeart(hittable[i], types, 1, me, nil, x, y, false)
		end
	end
end