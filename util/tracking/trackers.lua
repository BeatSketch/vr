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
local unit_vec_x = vector.pack(1, 0, 0)
local unit_vec_y = vector.pack(0, 1, 0)
local unit_vec_z = vector.pack(0, 0, 1)

--- Rotate a vector around an axis
---@param axis "x" | "y" | "z" The axis to rotate it around
---@param controller_quat quaternion The tracked device's rotation
---@param vec vector The vector to rotate
---@param angle integer Angle in degrees
function helpers.rotate_vector_along_own_frame_axis(axis, controller_quat, vec, angle)
	if controller_quat and vec then
		local axis_vec = (axis == "x" and unit_vec_x) or (axis == "y" and unit_vec_y or unit_vec_z)
		local rot_axis = (controller_quat * axis_vec):normalize()
		local rot = quaternion.angleaxis(angle / 180 * math.pi, rot_axis:unpack())
		return rot * vec
    else
        return vector.pack(0, 0, 0)
	end
end

--- Rotate a vector according to the configuration set for each angle
---@param controller_quat quaternion
---@param vec vector
function helpers.rotate_vec_according_to_config(controller_quat, vec)
	---@type vector
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
	local dir = vector.pack(lovr.headset.getDirection(hand))
	local controller_quat = quaternion.angleaxis(lovr.headset.getOrientation(hand))
	local pos = vector.pack(lovr.headset.getPosition(hand))

	if dir and controller_quat and pos then
		return {
			pos = pos,
			direction = helpers.rotate_vec_according_to_config(controller_quat, dir),
			angle = controller_quat,
			timestamp = time,
			buttons = helpers.get_down_buttons(hand, button_list),
		}
	else
		return {
			pos = vector.pack(0, 0, 0),
			direction = vector.pack(0, 0, 0),
			angle = quaternion.angleaxis(0, 0, 1, 0),
			timestamp = time,
			buttons = {},
		}
	end
end

--- Get the tracked position of the headset
--- @param dt number the time since the last call
--- @return PositionState
function M.get_head(dt)
	return {
		pos = vector.pack(lovr.headset.getPosition("head")),
		direction = vector.pack(lovr.headset.getDirection("head")),
		angle = quaternion.angleaxis(lovr.headset.getOrientation("head")),
		delta = dt,
		buttons = {},
	}
end

return M
