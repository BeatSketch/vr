local M = {}

--- Parse all CLI arguments into a table
---@return table - The CLI args
function M.parse_cli_opts()
    local parsed_args = {}
    for _, value in ipairs(arg) do
        local key = value:gmatch("[0-9a-zA-Z-_]+=")()
        key = key:sub(0, key:len() - 1)

        -- 2 is actually correct here, because some weird lua thing (first char is actually idx 1)
        parsed_args[key] = value:gmatch("=[0-9a-zA-Z-_]+")():sub(2)
    end

    return parsed_args
end

return M
