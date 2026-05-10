local lanes = require("ui.elements.lanes")
local menu = require("ui.menu")
local platform = require("ui.elements.platform")
local grid = require("ui.elements.grid")
local M = {}

-- NOTE: Can use the line function directly to draw the history (can add any number of points using it in one go)
-- pass:line(position, tip)

--- Draw the UI
--- @param pass Pass
function M.draw(pass)
	lanes.draw_lanes(pass)
    platform.draw_platform(pass)
	grid.draw_grid(pass)
	menu.pause_menu_draw(pass)
	menu.start_menu_draw(pass)
end

--- Update the state (from lovr.update function)
function M.update()
	menu.pause_menu_update()
	menu.start_menu_update()
end

return M
