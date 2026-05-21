local finish = require("ui.menus.finish")
local start = require("ui.menus.start")
local pause = require("ui.menus.pause")

local M = {}

--- Menu draw function. To be called by lovr.draw
---@param pass Pass the rendering pass
function M.draw(pass)
    finish.draw(pass)
    start.draw(pass)
    pause.draw(pass)
end

--- Update function for all menus, to be called by lovr.update
function M.update()
    finish.update()
    start.update()
    pause.update()
end

function M.open_end_menu()
    finish.open_menu()
end

function M.get_menu_open()
    return start.get_open() or finish.get_open() or pause.get_open()
end

return M
