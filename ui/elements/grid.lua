local state = require("core.state")
local math = require("math")
local M = {}

--- Draw a grid for possible colornote positions
--- @param pass Pass
M.grid = function(pass)
	local m, n = 3, 4
	--- Amount of grid layers
	local d = math.floor(state.bpm * (state.len / 60)) * state.beat_div
	local size = 0.666
	--- Distance between grid layers
	local dist = 60 / state.bpm * state.spd / state.beat_div
	local o = {
		x = -1.333,
		y = 0,
		z = 0, --- Must start here to align with song bpm's 0
	}
	o.z = o.z + state.disp

	local color_normal = { 0.1, 0.1, 0.1, 1 }
	local color_highlight = { 0.2, 0.2, 0.2, 1 }

	pass:setColor(color_normal)
	for i = 0, n, 1 do
		for j = 0, m, 1 do
			local points = {
				o.x + i * size,
				o.y + j * size,
				o.z,
				o.x + i * size,
				o.y + j * size,
				o.z - d * dist,
			}
			pass:line(points)
		end
	end

	for k = 0, d, 1 do
		if k % state.beat_div == 0 then
			pass:setColor(color_highlight)
		else
			pass:setColor(color_normal)
		end
		for i = 0, n, 1 do
			local points = {
				o.x + i * size,
				o.y,
				o.z - k * dist,
				o.x + i * size,
				o.y + m * size,
				o.z - k * dist,
			}
			pass:line(points)
		end
		for j = 0, m, 1 do
			local points = {
				o.x,
				o.y + j * size,
				o.z - k * dist,
				o.x + n * size,
				o.y + j * size,
				o.z - k * dist,
			}
			pass:line(points)
		end
	end
end

return M
