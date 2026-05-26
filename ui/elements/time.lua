local audio = require("util.audio")
local M = {}

--- Draw the time at the specified position
---@param pass Pass
---@param x number
---@param y number
---@param z number
---@param width number
---@param height number
---@param show_text boolean
function M.draw(pass, x, y, z, width, height, show_text)
	pass:setColor(0.1, 0.1, 0.1)
	pass:box(x, y, z, width, height, 0.05)

	local w = width * audio.get_pos() / audio.get_duration()
	pass:setColor(0.3, 0.3, 0.3)
	pass:box(x - width / 2 + w / 2, y, z + 0.025, w, height, 0.05)

	if show_text then
		pass:text(M.number_to_time(audio.get_pos(), false), x - width / 2, y + height * 1.05, z, height * 0.6, 0, 0, 0)
		pass:text(
			M.number_to_time(audio.get_duration(), false),
			x + width / 2,
			y + height * 1.05,
			z,
			height * 0.6,
			0,
			0,
			0
		)
	end
end

--- Turn a number of seconds into human-readable time
---@param num number The time in seconds to convert
---@param hours boolean Whether or not to display hours
function M.number_to_time(num, hours)
	if hours then
		return string.format(
			"%d.%s.%s",
			math.floor(num / 3600),
			M.zero_extend(math.floor(num / 60) % 60),
			M.zero_extend(math.floor(num) % 60)
		)
	else
		return string.format("%d.%s", math.floor(num / 60) % 60, M.zero_extend(num % 60))
	end
end

--- Zero-extend a number
---@param num number The number to extend
---@return string
function M.zero_extend(num)
	if num < 10 then
		return string.format("0%d", num)
	else
		return string.format("%d", num)
	end
end

return M
