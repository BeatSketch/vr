--- @alias hands "left" | "right"

local M = {}

--- @type number In degrees
M.angle = -20

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
--- Get all buttons on the device that are pressed
---@param device "head" | "left" | "right"
---@param buttons button[]
---@return string[]
local function get_down_buttons(device, buttons)
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

--- Get the tracked position of a hand
---@param hand hands The hand to get the data for
---@param dt number The delta time since last call
---@return PositionState
function M.get_hand(hand, dt)
	-- 1. Get vector
	local dir = vec3(lovr.headset.getDirection(hand))

	-- 2. Create quaternion to rotate
	local rot_axis_quat = quat(lovr.headset.getOrientation(hand))
	local rot_axis = rot_axis_quat:mul(vec3(1, 0, 0)):normalize()
	local rot = quat(M.angle / 180 * math.pi, rot_axis:unpack())

	-- 3. Rotate the direction vector around the new vector with quat rot
	return {
		pos = vec3(lovr.headset.getPosition(hand)),
		direction = rot:mul(dir),
		angle = rot_axis_quat,
		delta = dt,
		buttons = get_down_buttons(hand, button_list),
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
