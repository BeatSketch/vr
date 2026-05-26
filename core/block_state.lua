local M = {}

--- @class Block
--- @field x integer The lane the block is in
--- @field y integer The layer the block is in
--- @field orientation integer The orientation of the block
--- @field beat number The beat of the block
--- @field hand hands The hand of the block

--- @type Block[]
M.blocks = {}

--- The render distance at which to start rendering blocks
--- @type integer
M.render_distance = 40

M.idx = 0

--- @type nil | Model
M.arrow_block_model = nil
--- @type nil | Model
M.dot_block_model = nil

--- Add a block to the map
---@param block Block
function M.add_block(block)
	M.blocks[M.idx] = block
	M.idx = M.idx + 1
end

--- Add a list of blocks at once
---@param block_table Block[]
function M.add_block_table(block_table)
	for _, block in pairs(block_table) do
		M.add_block(block)
	end
end

--- Remove a block from the rendering
---@param idx integer The index to remove at
---@return Block The block that was removed
function M.remove_block(idx)
	local block = M.blocks[idx]
	for i = idx + 1, M.idx, 1 do
		M.blocks[i - 1] = M.blocks[i]
	end

	return block
end

return M
