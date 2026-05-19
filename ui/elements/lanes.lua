local state = require("core.state")
local M = {}

--- Draw the Beat Saber block lanes
--- @param pass Pass
M.draw = function(pass)
    local step = math.abs(state.offsets.x * 2) / 4
    local base = -math.abs(state.offsets.x) + step / 2
    local width = state.size.w * 0.9
	pass:setColor(0.1, 0.1, 0.1, 1)
	pass:box(base, 0, -103, width, 0.025, 200)
	pass:box(base + step, 0, -103, width, 0.025, 200)
	pass:box(base + 2 * step, 0, -103, width, 0.025, 200)
	pass:box(base + 3 * step, 0, -103, width, 0.025, 200)
end

return M
