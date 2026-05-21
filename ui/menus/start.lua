local state = require("core.state")
local button = require("ui.elements.button")
local audio = require("util.audio")

local M = {}

local start_menu_button = button:new(0, 1, -2, 0, 0, 0, 2, 0.5, "Start", 0.25)
local show_menu = true

--- Drawer function for the start menu
---@param pass Pass
function M.draw(pass)
	if show_menu then
		pass:setColor(0.2, 0.2, 0.2)
		pass:text("Hello World!", 0, 2.2, -2, 0.5)
		pass:text("BeatSketch", 0, 1.6, -2, 0.25)
		start_menu_button:draw(pass)
	end
end

--- Update handler for the start menu
function M.update()
	if show_menu then
		start_menu_button:handler(M.start_menu_handler)
	end
end

--- Start Menu Button handler
function M.start_menu_handler()
	show_menu = false
	state.set_disp(0)
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
