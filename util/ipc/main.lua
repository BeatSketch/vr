-- Abstraction for inter-process communication with the python-based launcher, which also does the processing
local json = require("json")

--- IPC abstraction utilities
--- Can be used to communicate with the launcher
local M = {}
local allow_get = false
local init_done = false

function M.init(allow_gets)
	if init_done then
		return false
	end
	init_done = true
	allow_get = allow_gets
	print("[BeatSketch] IPC INIT COMPLETE")
end

--- Trim a string
---@param s string the string to process
---@return string
function M.trim_string(s)
	return s:match("^%s*(.*)"):match("(.-)%s*$")
end

--- BLOCKING! Get all the data from the parent, until parent tells us to move on
--- @return table<integer, string | table> data The data that is retrieved
function M.get_data()
	if not allow_get or not init_done then
		return {}
	end

	-- Ask the python application to respond (as we otherwise may deadlock)
	print("proc:instr-await")
	io.flush()

	--- @type string | nil
	local line = io.read()
	local data = {}
	local idx = 0

	while line ~= nil and line ~= "proc:last-instr" do
		if line then
			if string.sub(line, 0, 5) == "json:" then
				data[idx] = json.decode(string.sub(line, 6))
			else
				data[idx] = M.trim_string(line)
			end
		end
		--- @type string | nil
		line = io.read()
		idx = idx + 1
	end

	return data
end

--- Send JSON data to the parent process
--- @param data table The table to send
function M.send_json(data)
	if not init_done then
		return false
	end

	print("json:" .. json.encode(data))
	io.flush()
end

--- Send text to the parent process
---@param data string The string to send
function M.send_text(data)
	M.send_plain("str:" .. data)
end

function M.send_plain(data)
	if not init_done then
		return false
	end

	print(data)
	io.flush()
end

return M
