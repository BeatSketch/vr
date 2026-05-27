local state = require("core.state")
local M = {}

M.count = {
	future = 3,
	past = 3,
}
M.max_count = {
	future = 200,
	past = 200,
}

local l_color_normal = { 1, 0, 0, 1 }
local l_color_highlight = { 0.5, 0, 0, 1 }

local r_color_normal = { 0, 0, 1, 1 }
local r_color_highlight = { 0, 0, 0.5, 1 }

--- Draw a visualisation of the current tracking history
--- @param pass Pass
M.draw = function(pass)
	local data = state.history:get()

	M.draw_line(pass, data.left, l_color_normal, l_color_highlight)
	M.draw_line(pass, data.right, r_color_normal, r_color_highlight)
end

--- Draw a visualisation for a single hand line
--- @param pass Pass
--- @param arr PositionStates
--- @param color_normal table<number, number>
--- @param color_highlight table<number, number>
M.draw_line = function(pass, arr, color_normal, color_highlight)
	local n = #arr
	if n == 0 then
		return
	end

	-- Get curr pos (then render 100 ahead and 100 back)
	local time = state.disp / state.spd
	local curr_idx = math.floor(time * state.tracking_freq)
	local newest_idx = math.min(curr_idx + math.min(M.count.future * state.tracking_freq, M.max_count.future), n)
	local oldest_idx = math.max(curr_idx - math.min(M.count.past * state.tracking_freq, M.max_count.past), 2)

	-- Treat first explicitly
	if arr[oldest_idx - 1] == nil then
        print("The array", arr[oldest_idx - 1], "idx", oldest_idx - 1)
        print("The next el is", arr[oldest_idx - 1])
        print("The prev el is", arr[oldest_idx - 2])
        print("The len is", #arr)
	end
	local point = arr[oldest_idx - 1].pos + lovr.math.vec3(0, 0, state.disp - state.history_disp[oldest_idx - 1])
	pass:setColor(color_highlight)
	pass:points(point)

	local prev = point
	for i = oldest_idx, newest_idx, 1 do
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
