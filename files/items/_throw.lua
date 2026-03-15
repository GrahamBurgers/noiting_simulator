function throw_item( from_x, from_y, to_x, to_y )
	local me = GetUpdatedEntityID()
	local comp = EntityGetFirstComponentIncludingDisabled(me, "PhysicsBodyComponent")
	local shape = EntityGetFirstComponentIncludingDisabled(me, "PhysicsImageShapeComponent")
	if not (comp and shape) then return end
	local off_x, off_y = ComponentGetValue2(shape, "offset_x"), ComponentGetValue2(shape, "offset_y")
	-- watch these
	off_x = off_x / 4
	off_y = off_y / 4
	local x, y, rot, vx, vy, ax = PhysicsComponentGetTransform(comp)
    local rot_set = math.pi - math.atan2(vy, -vx)

	-- this is nonsense
	local sx = math.max(0, math.sin(rot_set))
	local sy = math.max(0, -math.cos(rot_set))

	x = x + off_x * sx
	y = y + off_y * sy

	PhysicsComponentSetTransform(comp, x, y, rot_set, vx, vy, ax)
end