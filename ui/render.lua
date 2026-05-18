local lanes = require("ui.elements.lanes")
local menu = require("ui.menu")
local platform = require("ui.elements.platform")
local grid = require("ui.elements.grid")
local handlines = require("ui.elements.handlines")
local M = {}

-- NOTE: Can use the line function directly to draw the history (can add any number of points using it in one go)
-- pass:line(position, tip)

--- Show full beatnote grid
M.show_grid = true
M.show_hand_lines = true

--- Draw the UI
--- @param pass Pass
function M.draw(pass)
	lanes.draw(pass)
	platform.draw(pass)
	if not menu.get_menu_open() then
		if M.show_grid then
			grid.grid(pass)
		end
		if M.show_hand_lines then
			handlines.draw(pass)
		end
	else
		menu.pause_menu_draw(pass)
		menu.start_menu_draw(pass)
		menu.end_menu_draw(pass)
	end
end

--- Update the state (from lovr.update function)
function M.update()
	menu.pause_menu_update()
	menu.start_menu_update()
	menu.end_menu_update()
end

return M
