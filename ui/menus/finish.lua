local state = require("core.state")
local button = require("ui.elements.button")

local end_menu_seek_button = button:new(0.6, 0.8, -3, 0, 0, 0, 1, 0.5, "Preview", 0.25)
local end_menu_quit_button = button:new(-0.6, 0.8, -3, 0, 0, 0, 1, 0.5, "Quit", 0.25)
local show_menu = false

local M = {}

--- Drawer function for the pause menu
---@param pass Pass
function M.draw(pass)
	if show_menu then
		pass:setColor(0.2, 0.2, 0.2)
		pass:text("RECORDING FINISHED", 0, 1.8, -3, 0.5)
		pass:text("You have finished recording the map", 0, 1.55, -3, 0.2)
		pass:text("it is now being processed.", 0, 1.4, -3, 0.2)
		pass:text("You may exit or preview the map once processing is done", 0, 1.25, -3, 0.2)
		end_menu_seek_button:draw(pass)
		end_menu_quit_button:draw(pass)
	end
end

--- Update handler for the pause menu
function M.update()
	if show_menu then
		end_menu_seek_button:handler(function()
			show_menu = false
			state.set_mode("v")
		end)
		end_menu_quit_button:handler(function()
			lovr.event.quit(0)
		end)
	end
end

function M.open_menu()
	show_menu = true
	state.set_mode("m")
end

function M.get_open()
	return show_menu
end

return M
