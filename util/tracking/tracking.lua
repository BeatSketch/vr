local trackers = require("util.tracking.trackers")
local audio = require("util.audio")
local M = {}

--- @class AxisState
--- @field x number x value of the axis of the analog device
--- @field y number y value of the axis of the analog device

--- @class TrackerStates
--- @field head PositionState
--- @field left PositionState
--- @field right PositionState

--- Returns the current position of the thumbstick
---@param device controllers
function M.get_thumbstick_axes(device)
	local x, y = lovr.headset.getAxis(device, "thumbstick")
	return {
		x = x,
		y = y,
	}
end

--- @type TrackerStates
local tracker_states = {
	head = {
		pos = lovr.math.newVec3(0, 0, 0),
		direction = lovr.math.newVec3(0, 0, 0),
		angle = lovr.math.newQuat(0, 0, 0, 1),
		timestamp = 0,
		buttons = {},
	},
	left = {
		pos = lovr.math.newVec3(0, 0, 0),
		direction = lovr.math.newVec3(0, 0, 0),
		angle = lovr.math.newQuat(0, 0, 0, 1),
		timestamp = 0,
		buttons = {},
	},
	right = {
		pos = vec3(0, 0, 0),
		direction = vec3(0, 0, 0),
		angle = quat(0, 0, 0, 1),
		timestamp = 0,
		buttons = {},
	},
}

--- Store the positions for the hands
function M.update_hands()
	tracker_states.left = trackers.get_hand("left", audio.get_pos())
	tracker_states.right = trackers.get_hand("right", audio.get_pos())
end

--- Store the position for the headset
---@param dt number The time since the last call
function M.update_head(dt)
	tracker_states.head = trackers.get_head(dt)
end

--- Get the position states of the hands
--- @return table<string, PositionState>
function M.get_hands()
	return {
		left = tracker_states.left,
		right = tracker_states.right,
	}
end

--- Get the position state of the headset
---@return PositionState
function M.get_head()
	return tracker_states.head
end

--- Execute a callback if a button is pressed
---@param buttons button[] The button to check for
---@param cb function The callback to execute if the button is pressed
function M.handle_buttons(buttons, cb)
	for _, button in pairs(buttons) do
		M.handle_button(button, cb)
	end
end

--- Execute a callback if specified button is pressed
---@param button button The button to check for
---@param cb function The callback to execute if the button is pressed
function M.handle_button(button, cb)
	for _, value in pairs(tracker_states.left.buttons) do
		if value == button then
			cb()
		end
	end
	for _, value in pairs(tracker_states.right.buttons) do
		if value == button then
			cb()
		end
	end
end

--- Get the current state in transmittable form
---@return table
function M.get_for_transmit()
	return M.get_for_transmit_from_state(tracker_states, not audio.is_playing())
end

--- Transform the tracker state into a state sendable to the launcher
---@param state TrackerStates
---@param paused boolean If the recording was paused
---@return table
function M.get_for_transmit_from_state(state, paused)
	return {
		left = {
			timestamp = state.left.timestamp,
			pos = {
				state.left.pos:unpack(),
			},
			direction = {
				state.left.direction:unpack(),
			},
			quat = {
				state.left.angle:unpack(),
			},
			tip = {
				(state.left.pos + state.left.direction):unpack(),
			},
			buttons = state.left.buttons,
		},
		right = {
			timestamp = state.right.timestamp,
			pos = {
				state.right.pos:unpack(),
			},
			direction = {
				state.right.direction:unpack(),
			},
			quat = {
				state.right.angle:unpack(),
			},
			tip = {
				(state.right.pos + state.left.direction):unpack(),
			},
			buttons = state.right.buttons,
		},
		head = {
			timestamp = state.head.timestamp,
			pos = {
				state.head.pos:unpack(),
			},
			direction = {
				state.head.direction:unpack(),
			},
			quat = {
				state.head.angle:unpack(),
			},
			tip = {
				(state.head.pos + state.head.direction):unpack(),
			},
			buttons = state.head.buttons,
		},
		paused = paused,
	}
end

return M
