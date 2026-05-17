local trackers = require("util.tracking.trackers")
local audio = require("util.audio")
local M = {}

--- @type PositionStates
local tracker_states = {
	head = {
		pos = lovr.math.newVec3(0, 0, 0),
		direction = lovr.math.newVec3(0, 0, 0),
		angle = lovr.math.newQuat(0, 0, 0, 1),
		delta = 0,
		buttons = {},
	},
	left = {
		pos = lovr.math.newVec3(0, 0, 0),
		direction = lovr.math.newVec3(0, 0, 0),
		angle = lovr.math.newQuat(0, 0, 0, 1),
		delta = 0,
		buttons = {},
	},
	right = {
		pos = vec3(0, 0, 0),
		direction = vec3(0, 0, 0),
		angle = quat(0, 0, 0, 1),
		delta = 0,
		buttons = {},
	},
}

--- Store the positions for the hands
--- @param dt number The time since the last call
function M.update_hands(dt)
	tracker_states.left = trackers.get_hand("left", dt)
	tracker_states.right = trackers.get_hand("right", dt)
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

function M.get_for_transmit()
	return {
		left = {
			timestamp = audio.get_pos(),
			pos = {
				tracker_states.left.pos:unpack(),
			},
			direction = {
				tracker_states.left.direction:unpack(),
			},
			quat = {
				tracker_states.left.angle:unpack(),
			},
			tip = {
				(tracker_states.left.pos + tracker_states.left.direction):unpack(),
			},
			buttons = tracker_states.left.buttons,
		},
		right = {
			timestamp = audio.get_pos(),
			pos = {
				tracker_states.right.pos:unpack(),
			},
			direction = {
				tracker_states.right.direction:unpack(),
			},
			quat = {
				tracker_states.right.angle:unpack(),
			},
			tip = {
				(tracker_states.right.pos + tracker_states.left.direction):unpack(),
			},
			buttons = tracker_states.right.buttons,
		},
		head = {
			timestamp = audio.get_pos(),
			pos = {
				tracker_states.head.pos:unpack(),
			},
			direction = {
				tracker_states.head.direction:unpack(),
			},
			quat = {
				tracker_states.head.angle:unpack(),
			},
			tip = {
				(tracker_states.head.pos + tracker_states.head.direction):unpack(),
			},
			buttons = tracker_states.head.buttons,
		},
		paused = not audio.is_playing(),
	}
end

return M
