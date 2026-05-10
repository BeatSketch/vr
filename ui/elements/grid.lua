local M = {}

--- Draw a grid for possible colornote positions
--- @param pass Pass
M.draw_grid = function(pass)
    local m, n, d = 3, 4, 200
    local size, dist = 0.666, 0.666     --- dist should probably be dynamic via bpm
    local o = {
        x = -1.333,
        y = 0,
        z = -3
    }

    pass:setColor(0.05, 0.05, 0.05, 1)

    for i = 0, n, 1 do
        for j = 0, m, 1 do
            local points = {
                o.x + i*size, o.y + j*size, o.z,
                o.x + i*size, o.y + j*size, o.z - d*dist
            }
            pass:line(points)
        end
    end

    for k = 0, d, 1 do
        for i = 0, n, 1 do
            local points = {
                o.x + i*size, o.y, o.z - k*dist;
                o.x + i*size, o.y + m*size, o.z - k*dist
            }
            pass:line(points)
        end
        for j = 0, m, 1 do
            local points = {
                o.x, o.y + j*size, o.z - k*dist,
                o.x + n*size, o.y + j*size, o.z - k*dist
            }
            pass:line(points)
        end
    end
end

return M