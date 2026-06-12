local state = require("core.state")
local tracking = require("util.tracking.main")
local render = require("ui.render")
local ipc = require("util.ipc.main")
local audio = require("util.audio")
local processing = require("util.processing")

local M = {}

--- Wrapper to be called by lovr.update function
---@param dt number the delta time
---@param launch_with_launcher boolean Whether to attach to the launcher or not
function M.update_handler(dt, launch_with_launcher)
	tracking.update_hands()
	render.update()
	state.update(dt)

	-- leave this in please, I have chosen to send the data simultaneously and store it in Python
	-- because we need EVERY POSSIBLE data frame we can get to be able to pick enough
	-- data to feed the classifier with a sufficient number of data frames for inference
	if launch_with_launcher then
		ipc.send_json(tracking.get_for_transmit())
	end

	-- FIXME: This should go in a different file,
	-- but for that need to refactor core/state.lua
	if state.mode == "r" and audio.get_pos() >= state.len and not state.finished_recording then
        state.finished_recording = true
		audio.stop()
		render.open_end_menu()
	end

	processing.update(dt)
end

--- Configure the application with the args provided
---@param args table<string, string>
function M.configure(args)
	if args["bpm"] then
		state.bpm = tonumber(args["bpm"]) or 150
	end
	if args["njs"] then
		state.njs = tonumber(args["njs"]) or 10.0
	end
	local x = tonumber(args["rx"] or "-20") or -20
	local y = tonumber(args["ry"] or "0") or 0
	local z = tonumber(args["rz"] or "0") or 0
	tracking.set_saber_angles(x, y, z)
	-- tracking.enable_vibrate = args["vibrate"] and args["vibrate"] == "true"
end

return M
