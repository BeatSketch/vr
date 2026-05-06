-- Abstraction for inter-process communication with the python-based launcher, which also does the processing
local json = require("json")

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

--- BLOCKING! Get all the data from the parent, until parent tells us to move on
--- @return table<integer, string | table> data The data that is retrieved
function M.get_data()
    if not allow_get or not init_done then
        return {}
    end

    -- Ask the python application to respond (as we otherwise may deadlock)
    -- TODO: Consider rewriting this? (Currently could block for a long time)
    -- I have tried the io.lines and io.read("a") approach and both also block until
    -- new data becomes available, so no option
    print("proc:instr-await")
    io.flush()

    --- @type string | nil
    local line = io.read()
    local data = {}
    local idx = 0

    while line ~= nil and line ~= "proc:last-instr" do
        line = io.read()
        if string.sub(line, 0, 5) == "json:" then
            data[idx] = json.decode(string.sub(line, 0, 5))
        else
            data[idx] = line
        end
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
    if not init_done then
        return false
    end

    print("str:" .. data)
    io.flush()
end

return M
