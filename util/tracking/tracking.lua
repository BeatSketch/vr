local trackers = require("util.tracking.trackers")
local M = {}

--- @type PositionStates
local tracker_states = {
	head = {
		pos = vec3(0, 0, 0),
		direction = vec3(0, 0, 0),
		angle = quat(0, 0, 0, 1),
		delta = 0,
		buttons = {},
	},
	left = {
		pos = vec3(0, 0, 0),
		direction = vec3(0, 0, 0),
		angle = quat(0, 0, 0, 1),
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

--- Get the position state of the headset
---@return PositionState
function M.get_head()
	return tracker_states.head
end

function M.get_for_transmit()
    -- FIXME: This currently crashes if only one controller is tracked ever (i.e. make more resilient)
    -- Reason for the crash: The unpacked data somehow produces invalid or mixed keys
	return {
		left = {
			timestamp = tracker_states.left.delta, -- TODO: Make this actually use the absolute time stamp
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
			timestamp = tracker_states.right.delta, -- TODO: Make this actually use the absolute time stamp
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
	}
end

return M
