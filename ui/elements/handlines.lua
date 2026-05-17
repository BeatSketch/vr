local state = require("core.state")
local M = {}

--- Draw a visualisation of the current tracking history
--- @param pass Pass
M.draw = function(pass)
    local data = state.history:get()

    local l_color_normal = {1, 0, 0, 1}
    local l_color_highlight = {0.5, 0, 0, 1}

    local r_color_normal = {0, 0, 1, 1}
    local r_color_highlight = {0, 0, 0.5, 1}

    M.draw_line(pass, data.left, l_color_normal, l_color_highlight)
    M.draw_line(pass, data.right, r_color_normal, r_color_highlight)
end

--- Draw a visualisation for a single hand line
--- @param pass Pass
--- @param arr table<number, PositionState>
--- @param color_normal table<number, number>
--- @param color_highlight table<number, number>
M.draw_line = function(pass, arr, color_normal, color_highlight)
    local n = #arr
    if (n == 0) then return end

    -- Treat first explicitly
    local point = arr[1].pos + lovr.math.vec3(0, 0, state.disp - state.history_disp[1])
    pass:setColor(color_highlight)
    pass:points(point)

    local prev = point
    for i = 2, n, 1 do
        -- Need to be shifted by grid displacement at time of recording and current grid disp
        point = arr[i].pos + lovr.math.vec3(0, 0, state.disp - state.history_disp[i])

        pass:setColor(color_highlight)
        pass:points(point)

        pass:setColor(color_normal)
        pass:line(prev, point)

        prev = point
    end
end


return M