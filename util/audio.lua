local M = {}
local pos = 0
local start = 0
local is_playing = false
local init = false
local prev_pos = 0

--- Load the music file
--- @param file string The audio file to load
function M.load(file)
	if file:sub(0, 1) == '"' then
		file = file:sub(2, file:len() - 1)
	end
	local f = io.open(file, "rb")	--- Must be "rb" else no audio on Windows
	if f then
		M.load_blob(lovr.data.newBlob(f:read("a")))
	else
		error("Failed to load audio file '" .. file .. "' because it was not found or not readable")
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
		pos = M.get_pos()
        is_playing = false
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
	if not init then
		return -1
	end
	if not is_playing or start == 0 then
		return pos
	end
	return math.min(pos + (lovr.timer.getTime() - start), AudioSource:getDuration())
end

--- Seek to playback position
--- @param position number The position to seek to
function M.seek(position)
	local new_pos = math.max(math.min(position, AudioSource:getDuration()), 0)
	AudioSource:seek(new_pos)
	pos = new_pos
end

--- Store the current playback position.
--- Only one can be stored at a time
function M.store_current_pos()
	prev_pos = M.get_pos()
end

--- Seek to the stored playback position
function M.seek_to_stored_pos()
	M.seek(prev_pos)
end

--- Get the song duration
---@return number
function M.get_duration()
	return AudioSource:getDuration()
end

--- Check if the player is currently active
---@return boolean
function M.is_playing()
	return is_playing
end

return M
