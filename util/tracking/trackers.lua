--- @alias hands "left" | "right"

local M = {}

local helpers = {}

--- @class AngleList
--- @field x integer
--- @field y integer
--- @field z integer

--- The angle of the saber in relation to the default rotation
--- @type AngleList In degrees
helpers.angles = {
	x = -20,
	y = 0,
	z = 0,
}

local button_list = {
	"trigger",
	"thumbrest",
	"grip",
	"menu",
	"a",
	"b",
	"x",
	"y",
	"nib",
}

--- @alias button "trigger" | "thumbrest" | "grip" | "menu" | "a" | "b" | "x" | "y" | "nib"
--- @alias controllers "left" | "right"
--- @alias device "head" | controllers

--- Get all buttons on the device that are pressed
--- @param device device
--- @param buttons button[]
--- @return string[]
function helpers.get_down_buttons(device, buttons)
	local pressed = {}
	local idx = 1

	for _, value in pairs(buttons) do
		if lovr.headset.isDown(device, value) then
			pressed[idx] = value
			idx = idx + 1
		end
	end

	return pressed
end

-- Pre-generate unit vectors
local unit_vec_x = lovr.math.newVec3(1, 0, 0)
local unit_vec_y = lovr.math.newVec3(0, 1, 0)
local unit_vec_z = lovr.math.newVec3(0, 0, 1)

--- Rotate a vector around an axis
---@param axis "x" | "y" | "z" The axis to rotate it around
---@param controller_quat Quat The tracked device's rotation
---@param vec Vec3 The vector to rotate
---@param angle integer Angle in degrees
function helpers.rotate_vector_along_own_frame_axis(axis, controller_quat, vec, angle)
	local axis_vec = (axis == "x" and unit_vec_x) or (axis == "y" and unit_vec_y or unit_vec_z)
	local rot_axis = controller_quat:mul(axis_vec):normalize()
	local rot = quat(angle / 180 * math.pi, rot_axis:unpack())
	return rot:mul(vec)
end

--- Rotate a vector according to the configuration set for each angle
---@param controller_quat Quat
---@param vec Vec3
function helpers.rotate_vec_according_to_config(controller_quat, vec)
	---@type Vec3
	local rotated = vec
	if helpers.angles["x"] ~= 0 then
		rotated = helpers.rotate_vector_along_own_frame_axis("x", controller_quat, vec, helpers.angles["x"])
	end
	if helpers.angles["y"] ~= 0 then
		rotated = helpers.rotate_vector_along_own_frame_axis("y", controller_quat, vec, helpers.angles["y"])
	end
	if helpers.angles["z"] ~= 0 then
		rotated = helpers.rotate_vector_along_own_frame_axis("z", controller_quat, vec, helpers.angles["z"])
	end

	return rotated
end

--- Set the rotation of the saber along its own axes (clockwise)
---@param x integer Rotation along the controller's x axis
---@param y integer Rotation along the controller's y axis
---@param z integer Rotation along the controller's z axis
function M.set_saber_angles(x, y, z)
	helpers.angles.x = x
	helpers.angles.y = y
	helpers.angles.z = z
end

--- Get the tracked position of a hand
--- @param hand hands The hand to get the data for
--- @param time number The current time
--- @return PositionState
function M.get_hand(hand, time)
	local dir = lovr.math.newVec3(lovr.headset.getDirection(hand))
	local controller_quat = quat(lovr.headset.getOrientation(hand))

	return {
		pos = lovr.math.newVec3(lovr.headset.getPosition(hand)),
		direction = lovr.math.newVec3(helpers.rotate_vec_according_to_config(controller_quat, dir)),
		angle = controller_quat,
		timestamp = time,
		buttons = helpers.get_down_buttons(hand, button_list),
	}
end

--- Get the tracked position of the headset
--- @param dt number the time since the last call
--- @return PositionState
function M.get_head(dt)
	return {
		pos = vec3(lovr.headset.getPosition("head")),
		direction = vec3(lovr.headset.getDirection("head")),
		angle = quat(lovr.headset.getOrientation("head")),
		delta = dt,
		buttons = {},
	}
end

return M
