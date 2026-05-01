local M = {}

function M.parse_cli_opts()
	-- TODO: CLI args should not have to be sorted?
    -- but instead use key-val pairs (or maybe normal flags?)
	for idx, value in ipairs(arg) do
		print("CLI ARG " .. idx, value)
		print(arg[0])
	end

	return {
		song = arg[0],
		bpm = arg[1],
	}
end

return M
