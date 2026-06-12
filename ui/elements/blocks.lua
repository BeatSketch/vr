local state = require("core.state")
local block_state = require("core.block_state")
local M = {}

local angle_translations = { 0, 4, 2, 6, 1, 7, 3, 5 }

local data = {}

function M.load_texture()
	data.arrow_left = lovr.graphics.newModel("assets/red_up.obj", {})
	data.arrow_right = lovr.graphics.newModel("assets/blue_up.obj", {})
end

local base_quat = quaternion.angleaxis(-math.pi * 0.5, 1, 0, 0) * quaternion.angleaxis(math.pi, 0, 0, 1)
--- Draw the blocks
---@param pass Pass
function M.draw(pass)
	for _, block in pairs(block_state.blocks) do
		-- beat in time -> to displacement
		local pos = -(block.beat * 60 / state.bpm) * state.njs + state.disp
		if pos < -block_state.render_distance or pos > block_state.render_distance then
			-- that's actually pretty cool that there is goto
			goto continue
		end

		if block.hand == "left" then
			pass:setColor(1, 0, 0, 1)
		else
			pass:setColor(0, 0, 1, 1)
		end

		--- @type quaternion
		local rot = base_quat
			* quaternion.angleaxis(0.25 * math.pi * angle_translations[block.orientation + 1], 0, 1, 0)
		pass:draw(
			block.hand == "left" and data.arrow_left or data.arrow_right,
			state.offsets.x + block.x * state.size.w + state.size.w * 0.5,
			state.offsets.y + block.y * state.size.h + state.size.h * 0.5,
			pos,
			state.block_size,
			rot:unpack()
		)
		::continue::
	end
end

return M
