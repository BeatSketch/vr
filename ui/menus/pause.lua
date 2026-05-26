local audio = require("util.audio")
local button = require("ui.elements.button")
local state = require("core.state")
local tracking = require("util.tracking.tracking")
local start = require("ui.menus.start")
local finish = require("ui.menus.finish")
local processing = require("ui.processing")

-- Pregenerate the button, etc to save time
local pause_menu_resume_button = button:new(1.1, 1, -2, 0, 0, 0, 1, 0.5, "Resume", 0.25)
local pause_menu_preview_button = button:new(0, 1, -2, 0, 0, 0, 1, 0.5, "Preview", 0.25)
local pause_menu_quit_button = button:new(-1.2, 1, -2, 0, 0, 0, 1, 0.5, "Quit", 0.25)
local show_menu = false

local M = {}

--- Drawer function for the pause menu
---@param pass Pass
function M.draw(pass)
	if show_menu then
		pass:setColor(0.2, 0.2, 0.2)
		pass:text("PAUSED", 0, 1.8, -2, 0.5)
		pause_menu_resume_button:draw(pass)
		pause_menu_preview_button:draw(pass)
		pause_menu_quit_button:draw(pass)
	end
end

--- Update handler for the pause menu
--- @param dt number delta time
function M.update(dt)
	if show_menu then
		pause_menu_resume_button:handler(M.pause_menu_handler)
		pause_menu_quit_button:handler(function()
			lovr.event.quit(0)
		end)
		pause_menu_preview_button:handler(function()
			-- TODO: Start processing automatically
			-- and wait for it to complete?
			processing.start_processing()
			show_menu = false
			state.set_mode("v")
		end)
	end
	if state.mode == "r" then
		tracking.handle_buttons({ "a", "b", "x", "y" }, function()
			if not start.get_open() and not finish.get_open() then
				show_menu = true
				state.set_mode("m")
				audio.stop()
			end
		end)
	end
	-- TODO: Remove -> Move somewhere else
	processing.update(dt)
end

function M.pause_menu_handler()
	show_menu = false
	-- TODO: Mode switch when using pause menu in view mode
	state.set_mode("r")
	audio.start()
end

function M.open_menu()
	show_menu = true
end

function M.get_open()
	return show_menu
end

return M
