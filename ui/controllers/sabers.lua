local tracking = require "util.tracking.main"
local M = {}

--- Draw the sabers
---@param pass Pass the render pass
function M.draw(pass)
	-- Sabers
	for hand, state in pairs(tracking.get_hands()) do
		pass:setColor(1, 1, 1)
		pass:cylinder(state.pos - state.direction * 0.1, state.pos + state.direction * 0.05, 0.015, true)

		if hand == "left" then
			pass:setColor(1, 0, 0)
		else
			pass:setColor(0, 0, 1)
		end
		pass:cylinder(state.pos + state.direction * 0.05, state.pos + state.direction * 1, 0.015, true)
	end
end

return M
