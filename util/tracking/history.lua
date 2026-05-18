-- Import json library
local json = require("json")

-- ── Begin TYPEDEF ────────────────────────────────────────────────
--- Tracking and storing of the tracking. This can then be used to compute the map
--- Only use the provided functions to mutate the state as they provide some guards
--- @class Tracking
--- @field data TrackingData
--- @field private idx TrackingIndices
local Tracking = {}

--- @class TrackingData
--- @field left PositionStates
--- @field right PositionStates
--- @field head PositionStates

--- @class TrackingIndices
--- @field left number
--- @field right number
--- @field head number

--- @class PositionState
--- @field pos Vec3
--- @field direction Vec3 The direction vector
--- @field angle Quat
--- @field timestamp number
--- @field buttons button[]

--- @alias PositionStates table<number, PositionState>

--- @class Coordinate
--- @field x number X coordinate
--- @field y number Y coordinate
--- @field z number Z coordinate

--- @alias Coordinates table<number, Coordinate>
-- ── End TYPEDEF ──────────────────────────────────────────────────

--- Create a new Tracking store
--- @return Tracking
function Tracking:new()
	local o = {
		data = {
			left = {},
			right = {},
			head = {},
		},
		idx = {
			left = 0,
			right = 0,
			head = 0,
		},
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

--- Store the hand position
--- @param left PositionState The tracking data for the left controller to store
--- @param right PositionState The tracking data for the right controller to store
function Tracking:hands(left, right)
	self.data.left[self.idx.left] = left
	self.data.right[self.idx.right] = right
	self.idx.left = self.idx.left + 1
	self.idx.right = self.idx.right + 1
end

--- Store the headset position
--- @param head PositionState The tracking data for the headset to store
function Tracking:store_head(head)
	self.data.head[self.idx.head] = head
	self.idx.head = self.idx.head + 1
end

--- Save the tracking data to a json file
---@param path string The path to save to
function Tracking:save(path)
	local file = io.open(path, "w")
	if file then
		file:write(json.encode(self.data))
		file:close()
	end
end

--- Get the tracking data
---@return TrackingData - The tracking data object
function Tracking:get()
	return self.data
end

--- Get the tip at the specified index
--- @param length number
--- @return Vec3 left - The tracking data object
--- @return Vec3 right - The tracking data object
function Tracking:get_tips(length, idx)
	return (self.data.left[idx].direction + self.data.left[idx].direction * length),
		(self.data.right[idx].direction + self.data.right[idx].direction * length)
end

return Tracking
