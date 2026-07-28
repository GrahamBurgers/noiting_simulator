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
	local x, y, rot = EntityGetTransform(player)
	ComponentSetValue2(controls, "mFlyingTargetY", y - 10) -- ???
	ComponentSetValue2(controls, "mButtonFrameTransformDown", GameGetFrameNum())

	local is_gamepad = false
	local joystick_id = 0
	local jx, jy = InputGetJoystickAnalogStick(joystick_id, 0)
	local deadzone = 0.4
	if GameGetIsGamepadConnected() then
		is_gamepad = true
	end
	local output = {}
	dofile_once("data/scripts/debug/keycodes.lua")
	local buttons = {
		left     = {"Left"    , is_gamepad and jx < -deadzone},
		right    = {"Right"   , is_gamepad and jx > deadzone},
		up       = {"Up"      , is_gamepad and jy < -deadzone},
		down     = {"Down"    , is_gamepad and jy > deadzone},
		interact = {"Interact", is_gamepad and InputIsJoystickButtonDown(joystick_id, JOY_BUTTON_0)},
		fire     = {"Fire"    , is_gamepad and InputIsJoystickButtonDown(joystick_id, JOY_BUTTON_ANALOG_01_DOWN)},
		fly      = {"Fly"     , is_gamepad and InputIsJoystickButtonDown(joystick_id, JOY_BUTTON_ANALOG_00_DOWN)},
		kick     = {"Kick"    , is_gamepad and InputIsJoystickButtonDown(joystick_id, JOY_BUTTON_LEFT_THUMB)},
		throw    = {"Throw"   , is_gamepad and InputIsJoystickButtonDown(joystick_id, JOY_BUTTON_3)},
	}

	for key, t in pairs(buttons) do
		local suffix = t[1]
		local down = "mButtonDown" .. suffix
		local frame = "mButtonFrame" .. suffix

		output[key] = t[2] or ComponentGetValue2(controls2, down)
		output["frame" .. key] = ComponentGetValue2(controls2, frame)

		ComponentSetValue2(controls, down, new_inputs[key] == true)
		ComponentSetValue2(controls, frame, new_inputs["frame" .. key] or 0)
	end
	if new_inputs.aim_angle then
		local aiming_vec_distance = 1
		local vx, vy = math.cos(new_inputs.aim_angle) * aiming_vec_distance, math.sin(new_inputs.aim_angle) * aiming_vec_distance
		ComponentSetValue2(controls, "mAimingVector", vx, vy)
		ComponentSetValue2(controls, "mAimingVectorNormalized", vx, vy)
		ComponentSetValue2(controls, "mMousePosition", x + vx * 999, y + vy * 999)
		EntitySetTransform(player, x, y, rot, (-math.cos(new_inputs.aim_angle) * 5 > 0) and -1 or 1, 1)
	end

	return output
end