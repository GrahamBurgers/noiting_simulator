-- Will pause new inputs for one frame and replace them with custom inputs, if given.
-- nil input = player inputs are disabled.
-- TODO: Functionality on controller
return function(new_inputs)
	new_inputs = new_inputs or {}
	local player = EntityGetWithTag("player_unit")[1]
	local controls = EntityGetFirstComponent(player, "ControlsComponent")
	local controls2 = EntityGetFirstComponent(player, "ControlsComponent", "read_me_please")
	if not (controls and controls2) then return {} end
	ComponentSetValue2(controls, "enabled", false)
	local x, y = EntityGetTransform(player)
	ComponentSetValue2(controls, "mFlyingTargetY", y - 10) -- ???
	ComponentSetValue2(controls, "mButtonFrameTransformDown", GameGetFrameNum())

	local output = {}
	local buttons = {
		left = "Left",
		right = "Right",
		up = "Up",
		down = "Down",
		interact = "Interact",
		fire = "Fire",
		fly = "Fly",
		throw = "Throw",
	}

	for key, suffix in pairs(buttons) do
		local down = "mButtonDown" .. suffix
		local frame = "mButtonFrame" .. suffix

		output[key] = ComponentGetValue2(controls2, down)
		output["frame" .. key] = ComponentGetValue2(controls2, frame)

		ComponentSetValue2(controls, down, new_inputs[key] == true)
		ComponentSetValue2(controls, frame, new_inputs["frame" .. key] or 0)
	end

	return output
end