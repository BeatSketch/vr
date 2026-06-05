local M = {}

--- Parse all CLI arguments into a table
---@return table - The CLI args
function M.parse_cli_opts()
	local parsed_args = {}
	for _, value in ipairs(arg) do
		local key = value:gmatch("[0-9a-zA-Z-_]+=")()
		if key ~= nil and key:len() > 0 then
			key = key:sub(0, key:len() - 1)

			-- 2 is actually correct here, because some weird lua thing (first char is actually idx 1)
			local val = value:gmatch("=.*")()
			if val ~= nil and val:len() > 1 then
				parsed_args[key] = val:sub(2)
			end
		end
	end

	if parsed_args["dev"] then
		parsed_args["song"] = "assets/audio.ogg"
		parsed_args["mirror"] = "true"
		parsed_args["bpm"] = 120
		parsed_args["njs"] = 10
	end

	return parsed_args
end

return M
