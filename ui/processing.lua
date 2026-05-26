local ipc = require("util.ipc.main")
local blocks = require("core.block_state")

-- Utility to manage the processing step
local M = {}

M.is_processing = false

--- Draw the processing UI
---@param pass Pass The rendering pass
function M.draw(pass)
	if M.is_processing then
		print(pass)
	end
end

function M.start_processing()
	M.is_processing = true
	ipc.send_plain("proc:do-processing")
end

--- Start a rework section, i.e. telling the launcher that any new data
--- will overwrite the old data from this point onwards
---@param time number
function M.overwrite_from(time)
	ipc.send_text("proc:overwrite-from:" .. tostring(time))
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
	ipc.send_text("proc:get-existing-blocks")
	M.process_blocks()
end

function M.process_blocks()
	local data = ipc.get_data()

	-- TODO: Add function assignment for other kinds of data (if needed) here
	local next_is_blocks = false
	for _, value in pairs(data) do
		if type(value) == "string" then
			if value == "data:blocks" then
				next_is_blocks = true
			end
		else
			if next_is_blocks then
				next_is_blocks = false
				blocks.add_block_table(value)
				M.is_processing = false
			end
		end
	end
end

return M
