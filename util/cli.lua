local M = {}

function M.parse_cli_opts()
	for _, value in ipairs(arg) do
		print("CLI ARG 1", value)
        print(arg[0])
	end

    return {
        song = arg[0],
        bpm = arg[1]
    }
end

return M
