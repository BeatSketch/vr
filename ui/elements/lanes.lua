local M = {}

--- Draw the Beat Saber block lanes
--- @param pass Pass
M.draw = function(pass)
	pass:setColor(0.1, 0.1, 0.1, 1)
	pass:box(1, 0, -103, 0.6, 0.025, 200)
	pass:box(0.333, 0, -103, 0.6, 0.025, 200)
	pass:box(-0.333, 0, -103, 0.6, 0.025, 200)
	pass:box(-1, 0, -103, 0.6, 0.025, 200)
end

return M
