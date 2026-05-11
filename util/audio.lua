local M = {}
local pos = 0
local start = 0
local is_playing = false
local init = false

--- Load the music file
--- @param file string The audio file to load
function M.load(file)
	local f = io.open(file, "r")
	if f then
		M.load_blob(lovr.data.newBlob(f:read("a")))
    else
        error("Failed to load audio file")
	end
end

--- Load the music file as a blob
---@param blob Blob
function M.load_blob(blob)
	if init then
		error("Audio Source already initialized")
	end
	AudioSource = lovr.audio.newSource(blob, {
		pitchable = false,
		spatial = false,
		decode = false,
	})
	AudioSource:setLooping(false)
	init = true
	is_playing = false
	pos = 0
end

--- Stop playback
function M.stop()
	if is_playing then
		is_playing = false
		pos = M.get_pos()
        AudioSource:pause()
	end
end

--- Start playback
function M.start()
	if not is_playing and init then
		is_playing = true
		start = lovr.timer.getTime()
        AudioSource:play()
	end
end

--- Get the playback position
---@return number
function M.get_pos()
	if start == 0 or not init or not is_playing then
		return -1
	end
	return math.min(pos + (lovr.timer.getTime() - start), AudioSource:getDuration())
end

--- Seek to playback position
--- @param position number The position to seek to
function M.seek(position)
	AudioSource:seek(math.max(math.min(position, AudioSource:getDuration()), 0))
end

function M.is_playing()
	return is_playing
end

return M
