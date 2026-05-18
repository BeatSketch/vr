local tracking = require("util.tracking.tracking")
local Tracking = require("util.tracking.history")
local printing = require("util.printing")
local M = {}
--- Global data for the vr application, use setters whenever possible

--- @class Sizes
--- @field h number
--- @field w number

--- @class Offsets
--- @field x number
--- @field y number

--- Current vr app mode
--- @type "r" | "v" | "m"
M.mode = "m"

--- The time signature for the song
--- @type table<"top" | "bottom", integer>
M.signature = {
	top = 4,
	bottom = 4,
}

--- The distance between time units on the grid
M.dist = 0

--- The sizes of the grid in each direction
--- @type Sizes
M.size = {
	h = 0.666,
	w = 0.666,
}

--- The sizes of the blocks in each direction
--- @type number
M.block_size = 0.3

--- The grid offsets in each direction
--- @type Offsets
M.offsets = {
	x = -1.333,
	y = 0,
}

--- Current Song's bpm
--- @type number
M.bpm = 120

--- Amount of grid subdivision within 1 beat
--- @type 1 | 2 | 4 | 8 | 16
M.beat_div = 4

-- TODO: Get from audio.get_duration()
--- Current Song's length in seconds
--- @type number
M.len = 160

--- How fast notes move towards user (NJS)
--- @type number
M.spd = 10

--- Speed multiplier when moving using the controller
--- @type number
M.seek_speed = 2

--- Current timestamp within selected song
--- @type number
M.time = 0

--- Displacement of the grid (i.e. position within level)
--- @type number
M.disp = 0

--- Previous displacement. Stored when entering `v`, returned to when entering `r`
--- @type number
M.prev_disp = 0

--- Current tracking history
--- @type Tracking
M.history = Tracking:new()

--- Displacement data for tracking history
--- @type number[]
M.history_disp = {}

--- Tracking frequency: Maximum number of hand tracking points per second
--- @type number
M.tracking_freq = 20

--- Set current vr app mode
--- @param new_mode "r" | "v" | "m" record, view or menu
M.set_mode = function(new_mode)
	if M.mode == "r" and new_mode == "v" then
		--- Store displacement when seeking
		M.prev_disp = M.disp
	elseif M.mode == "v" and new_mode == "r" then
		--- revert to previous displacement after seeking
		M.disp = M.prev_disp
		M.prev_disp = 0
	end
	M.mode = new_mode
end

--- Set current displacement for rendering
--- @param disp number
M.set_disp = function(disp)
	M.disp = disp
end

--- Set current song's bpm
--- @param bpm number
M.set_bpm = function(bpm)
	M.bpm = bpm
end

--- Groups all state update functions, is passed to lovr.update
--- @param dt number delta time
M.update = function(dt)
	M.update_disp(dt)
	M.update_history(dt)
end

--- Update current displacement
--- @param dt number deltatime
M.update_disp = function(dt)
	-- FIXME: This may not be accurate, can instead use the audio
	-- module's tracker, which is accurate
	M.time = M.time + dt
	if M.mode == "r" then
		M.disp = M.disp + (dt * M.spd)
	elseif M.mode == "v" then
		--- move via controller input
		M.disp = M.disp
			+ dt * tracking.get_thumbstick_axes("left").y * M.seek_speed
			+ dt * tracking.get_thumbstick_axes("right").y * M.seek_speed
		printing.print(tracking.get_thumbstick_axes("left"))
	end
end

--- Return to origin (reset displacement)
M.reset_disp = function()
	M.disp = 0
	M.prev_disp = 0
end

-- FIXME: Can use audio playback position instead of this
local track_delta = 0
local count = 0
local target = 1 / M.tracking_freq
--- Try to insert current position of hands into history (see `state.tracking_freq`)
--- @param dt number delta time
M.update_history = function(dt)
	-- Only track if mode is set to recording
	if M.mode ~= "r" then
		return
	end

	track_delta = track_delta + dt
	if track_delta >= target then
		local hands = tracking.get_hands()
		M.history:hands(hands.left, hands.right)
		M.history_disp[count + 1] = M.disp
		count = count + 1
		track_delta = 0
	end
end

return M
