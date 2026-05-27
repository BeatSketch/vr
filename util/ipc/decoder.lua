local M = {}

--- Validate the received data as a block and transform into correct format
---@param data table
function M.decode_block(data)
	--- Blocks
	---@type Block[]
	local blocks = {}
	local idx = 0
	for _, value in pairs(data) do
		blocks[idx] = {
			x = value.x,
			y = value.y,
			hand = value.hand == 1 and "right" or "left",
			beat = value.beat,
			orientation = value.orientation,
		}
		idx = idx + 1
	end
	return blocks
end

return M
