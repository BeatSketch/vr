-- Import json library
local json = require("json")

-- ── Begin TYPEDEF ────────────────────────────────────────────────
--- @class InfoFileIndices
--- @field difficultyBeatmaps number

--- @class Song
--- @field title string The Song title
--- @field subtitle string The subtitle for the song
--- @field author string The artist(s) for the song

--- @class Audio
--- @field songFilename string The file name for the song file to use
--- @field songDuration number Song's duration in seconds
--- @field audioDataFilename string The filename for the audio data
--- @field bpm number The default (or most common) bpm (displayed in UI)
--- @field lufs number The loudness of the song (defaults to zero as in no change)
--- @field previewStartTime number The point in the song in which the preview in the menu is played
--- @field previewDuration number How long that preview is played for

--- @alias DifficultyLevels "Easy" | "Normal" | "Hard" | "Expert" | "Expert+"
--- @alias Difficulties table<number, Difficulty>

--- @class Difficulty
--- @field characteristic "Standard" The kind of beatmap, only standard supported, could also be OneSaber, etc
--- @field difficulty DifficultyLevels The difficulty
--- @field beatmapAuthors BeatMapAuthors
--- @field environmentNameIdx integer The environment index in the environments table in info
--- @field beatmapColorSchemeIdx integer The color scheme index (default: -1, uses env defaults)
--- @field noteJumpMovementSpeed number The Note Jump Speed
--- @field noteJumpStartBeatOffset number NJS offset
--- @field beatmapDataFilename string The file of the Beatmap (default: <Difficulty>.dat)
--- @field lightShowDataFilename string The file of the Lightshow (default: Lightshow.dat)

--- @class BeatMapAuthors
--- @field mappers table<string>
--- @field lighters table<string>

--- @class InfoFileContent
--- @field version string The Info file version to use
--- @field difficultyBeatmaps Difficulties A list of difficulties
--- @field song Song The song that this map is for
--- @field audio Audio Audio details / cache / config
--- @field songPreviewFilename string The File to use for the audio preview (default: Same as song)
--- @field coverImageFilename string The File to use as cover image
--- @field environmentNames table<number, string>

--- The BeatMap file abstraction. Only use the provided functions
--- to mutate the state as they provide some guards
--- @class InfoFile
--- @field data InfoFileContent
--- @field counts InfoFileIndices
local InfoFile = {}
-- ── End TYPEDEF ──────────────────────────────────────────────────

--- Create a new InfoFile
--- @param bpm number
--- @param audio_file string
--- @param song_duration number
--- @param name string
--- @param subtitle string
--- @param author string
--- @return InfoFile
function InfoFile:new(bpm, audio_file, song_duration, name, subtitle, author)
	if type(bpm) ~= "number" then
		error("BPM not a number")
	end
	local o = {
		data = {
			version = "4.0.0",
			difficultyBeatmaps = {},
			song = {
				title = name,
				subtitle = subtitle,
				author = author,
			},
			audio = {
				songFilename = audio_file,
				songDuration = song_duration,
				audioDataFilename = "BPMInfo.dat",
				bpm = bpm,
				lufs = 0,
				previewStartTime = 20,
				previewDuration = song_duration - 20,
			},
			songPreviewFilename = audio_file,
			coverImageFilename = "cover.png",
			environmentNames = {
                "DefaultEnvironment"
            },
		},
		counts = {
			difficultyBeatmaps = 0,
		},
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

--- Save to disk
--- @param dir string The directory to save to
function InfoFile:save(dir)
	local file = io.open(dir .. "/Info.dat", "w")
	if file then
		file:write(json.encode(self.data))
		file:close()
	end
end

--- Add a beatmap difficulty to the map
--- @param difficulty string The file path to save to
--- @param njs number The note jump speed
--- @param njs_offset number Note jump offset
function InfoFile:add_beatmap(difficulty, njs, njs_offset)
	self.data.difficultyBeatmaps[self.counts.difficultyBeatmaps] = {
		characteristic = "Standard",
		difficulty = difficulty,
		beatmapAuthors = {
			mappers = {
				"BeatSketch",
			},
			lighters = {},
		},
		environmentNameIdx = 0,
		beatmapColorSchemeIdx = -1, -- means use default
		noteJumpMovementSpeed = njs,
		noteJumpStartBeatOffset = njs_offset,
		beatmapDataFilename = difficulty .. ".dat",
		lightShowDataFilename = "Lightshow.dat",
	}
	self.counts.difficultyBeatmaps = self.counts.difficultyBeatmaps + 1
end

return InfoFile
