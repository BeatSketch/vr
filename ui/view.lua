local audio = require("util.audio")
local button = require("ui.elements.button")
local state = require("core.state")
local time = require("ui.elements.time")
local pause = require("ui.menus.pause")

-- Pregenerate the button, etc to save time
local view_play_button = button:new(-2, 1, -3, 0, 0, 0, 0.75, 0.5, "Play", 0.25)
local view_pause_button = button:new(-2, 1, -3, 0, 0, 0, 0.75, 0.5, "Pause", 0.25)
local view_exit_button = button:new(-2, 0.5, -3, 0, 0, 0, 0.75, 0.5, "Exit", 0.25)
local view_record_from_here_button = button:new(2.2, 1.4, -3, 0, 0, 0, 1.2, 0.3, "Record from here", 0.15)
local view_continue_recording_button = button:new(2.2, 1, -3, 0, 0, 0, 1.2, 0.3, "Continue recording", 0.15)

local M = {}

M.time_pos = {
	x = 0,
	y = 3,
	z = -5,
}

M.time_size = {
	w = 2,
	h = 0.2,
}

--- Drawer function for the preview menu elements
---@param pass Pass
function M.draw(pass)
	if state.mode == "v" then
		if state.processing.is_processing then
			pass:text("Processing", 0, 1.7, -4, 0.4, 0, 0, 0, 0)
			pass:text("Please wait", 0, 1.3, -4, 0.2, 0, 0, 0, 0)
		else
			if audio.is_playing() then
				view_pause_button:draw(pass)
			else
				view_play_button:draw(pass)
			end
			view_record_from_here_button:draw(pass)
			view_continue_recording_button:draw(pass)
			view_exit_button:draw(pass)

			time.draw(pass, M.time_pos.x, M.time_pos.y, M.time_pos.z, M.time_size.w, M.time_size.h, true)
		end
	end
end

--- Update handler for the preview menu elements
function M.update()
	if state.mode == "v" then
		if audio.is_playing() then
			view_pause_button:handler(function()
				audio.stop()
			end)
		else
			view_play_button:handler(function()
				audio.start()
			end)
		end
		view_exit_button:handler(function()
			state.set_mode("m")
			pause.open_menu()
		end)
		view_record_from_here_button:handler(function()
			state.prev_disp = state.disp
			audio.store_current_pos()
			state.set_mode("r")
			audio.start()
		end)
		view_continue_recording_button:handler(function()
			state.set_mode("r")
			audio.start()
		end)
	end
end

return M
