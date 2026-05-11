local button = require("ui.elements.button")
local tracking = require("util.tracking.tracking")
local audio = require("util.audio")

local M = {}

local start_menu_button = button:new(0, 1, -2, 0, 0, 0, 2, 0.5, "Start", 0.25)
local pause_menu_resume_button = button:new(0.6, 1, -2, 0, 0, 0, 1, 0.5, "Resume", 0.25)
local pause_menu_quit_button = button:new(-0.6, 1, -2, 0, 0, 0, 1, 0.5, "Quit", 0.25)
local show_pause_menu = false
local show_start_menu = true

--- Drawer function for the start menu
---@param pass Pass
function M.start_menu_draw(pass)
	if show_start_menu then
		pass:setColor(0.2, 0.2, 0.2)
		pass:text("Hello World!", 0, 2.2, -2, 0.5)
		pass:text("BeatSketch", 0, 1.6, -2, 0.25)
		start_menu_button:draw(pass)
	end
end

--- Update handler for the start menu
function M.start_menu_update()
	if show_start_menu then
		start_menu_button:handler(function()
			show_start_menu = false
            audio.start()
		end)
	end
end

--- Drawer function for the pause menu
---@param pass Pass
function M.pause_menu_draw(pass)
	if show_pause_menu then
		pass:setColor(0.2, 0.2, 0.2)
		pass:text("PAUSED", 0, 1.8, -2, 0.5)
		pause_menu_resume_button:draw(pass)
		pause_menu_quit_button:draw(pass)
	end
end

--- Update handler for the pause menu
function M.pause_menu_update()
	if show_pause_menu then
		pause_menu_resume_button:handler(function()
			show_pause_menu = false
            audio.start()
		end)
		pause_menu_quit_button:handler(function()
			lovr.event.quit(0)
		end)
	end
	tracking.handle_buttons({ "a", "b", "x", "y" }, function()
		if not show_start_menu then
			show_pause_menu = true
            audio.stop()
		end
	end)
end

return M
