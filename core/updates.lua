local state = require("core.state")
local tracking = require("util.tracking.tracking")
local render = require("ui.render")
local ipc = require("util.ipc.main")

local M = {}

local time_delta = 0
--- Wrapper to be called by lovr.update function
---@param dt number the delta time
---@param launch_with_launcher boolean Whether to attach to the launcher or not
function M.update_handler(dt, launch_with_launcher)
	tracking.update_hands()
	render.update()
	state.update(dt)

    -- leave this in please, I have chosen to send the data simultaneously and store it in Python
    -- because we need EVERY POSSIBLE data frame we can get to be able to pick enough
    -- data to feed the classifier with a sufficient number of data frames for inference
	if launch_with_launcher then
		ipc.send_json(tracking.get_for_transmit())
	end
	-- NOTE: This works, sorta well
    -- TODO: Finish this up
	-- printing.print_table(ipc.get_data())
end

--- Configure the application with the args provided
---@param args table<string, string>
function M.configure(args)
    print(args)
end

return M
