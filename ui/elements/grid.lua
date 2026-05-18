local state = require("core.state")
local math = require("math")
local M = {}

M.bar_count = {
	future = 4,
	past = 4,
}
M.render_z_axis_lines = false

local color_normal = { 0.1, 0.1, 0.1, 1 }
local color_highlight = { 0.2, 0.2, 0.2, 1 }
local m, n = 3, 4

--- Draw a grid for possible colornote positions
--- @param pass Pass
M.grid = function(pass)
	--- Number of grid layers (beats)
	local d = math.floor(state.bpm * (state.len / 60))
	--- Distance between grid layers
    state.dist = 60 / state.bpm * state.spd

	local time = state.disp / state.spd
	local curr_idx = math.ceil(time / state.len * d)
	local max_idx = math.min(curr_idx + state.signature.top * M.bar_count.future, d)
	local min_idx = math.max(curr_idx - state.signature.top * M.bar_count.past, 1)

	--- Offsets for different coordinates
	local o = {
		x = state.offsets.x,
		y = 0,
		z = 0, --- Must start here to align with song bpm's 0
	}
	o.z = o.z + state.disp

	if M.render_z_axis_lines then
		-- line along z axis
		pass:setColor(color_normal)
		for i = 0, n, 1 do
			for j = 0, m, 1 do
				local points = {
					o.x + i * state.size.w,
					o.y + j * state.size.h,
					o.z,
					o.x + i * state.size.w,
					o.y + j * state.size.h,
					o.z - d * state.dist,
				}
				pass:line(points)
			end
		end
	end

	for k = min_idx, max_idx, 1 do
		if k % state.signature.top == 0 then
			pass:setColor(color_highlight)
		else
			pass:setColor(color_normal)
		end
		for i = 0, n, 1 do
			local points = {
				o.x + i * state.size.w,
				o.y,
				o.z - k * state.dist,
				o.x + i * state.size.w,
				o.y + m * state.size.h,
				o.z - k * state.dist,
			}
			pass:line(points)
		end
		for j = 0, m, 1 do
			local points = {
				o.x,
				o.y + j * state.size.h,
				o.z - k * state.dist,
				o.x + n * state.size.w,
				o.y + j * state.size.h,
				o.z - k * state.dist,
			}
			pass:line(points)
		end
	end
end

return M
