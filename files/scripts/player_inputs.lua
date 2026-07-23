-- Will pause new inputs for one frame and replace them with custom inputs, if given.
-- nil input = player inputs are disabled.
return function(new_inputs)
	new_inputs = new_inputs or {}
	local player = EntityGetWithTag("player_unit")[1]
	local controls = EntityGetFirstComponent(player, "ControlsComponent")
	local controls2 = EntityGetFirstComponent(player, "ControlsComponent", "read_me_please")
	if not (controls and controls2) then return {} end
	ComponentSetValue2(controls, "enabled", false)
	ComponentSetValue2(controls, "mButtonFrameTransformDown", GameGetFrameNum())
	local output = {}
	output.left = ComponentGetValue2(controls2, "mButtonDownLeft")
	output.frameleft = ComponentGetValue2(controls2, "mButtonFrameLeft")
	ComponentSetValue2(controls, "mButtonDownLeft", new_inputs.left == true)
	ComponentSetValue2(controls, "mButtonFrameLeft", new_inputs.frameleft or 0)

	output.right = ComponentGetValue2(controls2, "mButtonDownRight")
	output.frameright = ComponentGetValue2(controls2, "mButtonFrameRight")
	ComponentSetValue2(controls, "mButtonDownRight", new_inputs.right == true)
	ComponentSetValue2(controls, "mButtonFrameRight", new_inputs.frameright or 0)

	output.up = ComponentGetValue2(controls2, "mButtonDownUp")
	output.frameup = ComponentGetValue2(controls2, "mButtonFrameUp")
	ComponentSetValue2(controls, "mButtonDownUp", new_inputs.up == true)
	ComponentSetValue2(controls, "mButtonFrameUp", new_inputs.frameup or 0)

	output.down = ComponentGetValue2(controls2, "mButtonDownDown")
	output.framedown = ComponentGetValue2(controls2, "mButtonFrameDown")
	ComponentSetValue2(controls, "mButtonDownDown", new_inputs.down == true)
	ComponentSetValue2(controls, "mButtonFrameDown", new_inputs.framedown or 0)

	output.interact = ComponentGetValue2(controls2, "mButtonDownInteract")
	output.frameinteract = ComponentGetValue2(controls2, "mButtonFrameInteract")
	ComponentSetValue2(controls, "mButtonDownInteract", new_inputs.interact == true)
	ComponentSetValue2(controls, "mButtonFrameInteract", new_inputs.frameinteract or 0)

	output.fire = ComponentGetValue2(controls2, "mButtonDownFire")
	output.framefire = ComponentGetValue2(controls2, "mButtonFrameFire")
	ComponentSetValue2(controls, "mButtonDownFire", new_inputs.fire == true)
	ComponentSetValue2(controls, "mButtonFrameFire", new_inputs.framefire or 0)

	return output
end