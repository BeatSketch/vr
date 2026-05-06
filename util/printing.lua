local M = {}

--- Print a table (recursively)
--- @param t any the table to print
function M.print_table(t)
	if t == nil then
		print("{}")
		return
	end

	if type(t) == "table" then
		--- Print helper
		---@param data table the table to print
		---@param idx integer The index (depth)
		local function table_print_helper(data, idx)
			local out = ""
			if rawget(data, 1) ~= nil or next(data) == nil then
				-- Is array
				for _, value in pairs(data) do
					if type(value) == "table" then
						out = out .. table_print_helper(value, idx + 1) .. "\n"
					else
						out = out .. (" "):rep((idx + 1) * 2) .. value .. "\n"
					end
				end
				return (" "):rep(idx * 2) .. "[\n" .. out .. (" "):rep(idx * 2) .. "]"
			else
				-- is dict
				for key, value in pairs(data) do
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
    elseif type(t) == "number" or type(t) == "string" or type(t) == "boolean" then
        print(t)
    else
        print("UNSUPPORTED TYPE PASSED", type(t))
	end
end

return M
