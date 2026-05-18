local M = {}

--- Print a table (recursively)
--- @param t any the table to print
function M.print(t)
	if t == nil then
		print("{}")
		return
	end

	local function non_table_helper(data)
		if type(data) == "number" or type(data) == "string" or type(data) == "boolean" then
			return tostring(data)
		elseif type(data) == "userdata" then
			return "<USERDATA>"
		else
            return "<UNKNOWN TYPE, " .. type(data) .. ">"
		end
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
						out = out .. (" "):rep((idx + 1) * 2) .. non_table_helper(value) .. "\n"
					end
				end
				return (" "):rep(idx * 2) .. "[\n" .. out .. (" "):rep(idx * 2) .. "]"
			else
				-- is dict
				for key, value in pairs(data) do
					if type(value) == "table" then
						out = out .. table_print_helper(value, idx + 1) .. "\n"
					else
						out = out .. (" "):rep((idx + 1) * 2) .. non_table_helper(key) .. ": " .. non_table_helper(value) .. "\n"
					end
				end
				return (" "):rep(idx * 2) .. "{\n" .. out .. (" "):rep(idx * 2) .. "}"
			end
		end

		print(table_print_helper(t, 0))
	else
		print(non_table_helper(t))
	end
end

return M
