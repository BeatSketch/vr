local lanes = require("ui.elements.lanes")
local menu = require("ui.menu")
local platform = require("ui.elements.platform")
local grid = require("ui.elements.grid")
local handlines = require("ui.elements.handlines")
local M = {}

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
        menu.draw(pass)
    end
end

--- Update the state (from lovr.update function)
function M.update()
    menu.update()
end

return M
