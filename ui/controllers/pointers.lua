local tracking = require "util.tracking.main"
local M = {}

M.length = 10

--- Draw the pointers
---@param pass Pass the render pass
function M.draw(pass)
	-- Pointers
	for _, state in pairs(tracking.get_hands()) do
		pass:setColor(1, 1, 1)
		pass:sphere(state.pos, 0.01)

		pass:line(state.pos, state.pos + state.direction * M.length)
	end
end

return M
