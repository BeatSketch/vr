local ipc = require("util.ipc.main")
local blocks = require("core.block_state")
local decoder = require("util.ipc.decoder")

-- Utility to manage the processing step
local M = {}

M.is_processing = false

function M.start_processing()
	M.is_processing = true
	ipc.send_plain("proc:do-processing")
end

local time_delta = 0
--- lovr update function callback
---@param dt number the time since last call
function M.update(dt)
	if M.is_processing then
		time_delta = time_delta + dt
		if time_delta > 1 then
			M.process_blocks()
		end
	end
end

function M.request_existing_blocks()
	ipc.send_text("proc:existing-blocks")
	M.process_blocks()
end

function M.process_blocks()
	local data = ipc.get_data()

	local next_is_blocks = false
	for _, value in pairs(data) do
		if type(value) == "string" then
			if value == "data:blocks" then
				next_is_blocks = true
			end
		else
			if next_is_blocks then
				next_is_blocks = false
				blocks.add_block_table(decoder.decode_block(value))
				M.is_processing = false
			end
		end
	end
end

return M
