local M = {}

--- Print a table (recursively)
--- @param t table the table to print
function M.print_table(t)
    --- Print helper
    ---@param t table the table to print
    ---@param idx integer The index (depth)
    local function table_print_helper(t, idx)
        local out = ""
        if rawget(t, 1) ~= nil or next(t) == nil then
            -- Is array
            for _, value in pairs(t) do
                if type(value) == "table" then
                    out = out .. table_print_helper(value, idx + 1) .. "\n"
                else
                    out =  out .. (" "):rep((idx + 1) * 2) .. value .. "\n"
                end
            end
            return (" "):rep(idx * 2) .. "[\n" .. out .. (" "):rep(idx * 2) .. "]"
        else
            -- is dict
            for key, value in pairs(t) do
                if type(value) == "table" then
                    out = out .. table_print_helper(value, idx + 1) .. "\n"
                else
                    out = out .. (" "):rep((idx + 1) * 2) .. key .. ": " .. value .. "\n"
                end
            end
            return (" "):rep(idx * 2) .. "{\n" .. out .. (" "):rep(idx * 2) .. "}"
        end
    end

    print(table_print_helper(t, 0))
end

return M
