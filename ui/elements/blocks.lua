local M = {}

--- @class Block
--- @field x integer The lane the block is in
--- @field y integer The layer the block is in
--- @field orientation integer The orientation of the block
--- @field beat number The beat of the block
--- @field hand hands The hand of the block

--- @type Block[]
M.blocks = {}

--- Draw the blocks
---@param pass Pass
function M.draw(pass)
	pass:box()
end

--- Add a block to the map
---@param block Block
function M.add_block(block)
	print("Block added")
end

function M.remove_block(idx) end

return M
