local state = require("core.state")
local M = {}

local angle_translations = { 0, 4, 2, 6, 1, 7, 3, 5 }

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

function M.load_texture()
	-- TODO: Create the 3D model for the block and load it
end

--- Draw the blocks
---@param pass Pass
function M.draw(pass)
	for _, block in pairs(M.blocks) do
		local pos = state.disp - block.beat * state.spd
		if pos < -M.render_distance or pos > M.render_distance then
            -- that's actually pretty cool that there is goto
			goto continue
		end

		if block.hand == "left" then
			pass:setColor(0, 0, 1, 1)
		else
			pass:setColor(1, 0, 0, 1)
		end

		-- TODO: Update the sizing
		pass:box(
			state.offsets.x + block.x * state.size.w + state.size.w * 0.5,
			state.offsets.y + block.y * state.size.h + state.size.h * 0.5,
			pos,
			state.block_size,
			state.block_size,
			state.block_size,
			0.25 * math.pi * angle_translations[block.orientation + 1],
			0,
			0,
			1
		)
		::continue::
	end
end

--- Add a block to the map
---@param block Block
function M.add_block(block)
	print("added block with orientation", block.orientation)
	M.blocks[M.idx] = block
	M.idx = M.idx + 1
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
