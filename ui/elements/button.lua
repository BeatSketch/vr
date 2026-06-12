local tracking = require("util.tracking.main")
--- @alias ColorType "active"|"hover"|"normal"
--- @class Color
--- @field r number
--- @field g number
--- @field b number

--- @class Button
--- @field text string
--- @field text_size number Fraction of normal scale
--- @field position vector
--- @field width number
--- @field height number
--- @field private hovered boolean
--- @field private active boolean
--- @field private active_color Color
--- @field private color Color
--- @field private hovered_color Color
--- @field private active_color_text Color
--- @field private color_text  Color
--- @field private hovered_color_text Color
local Button = {}

--- Create a new button
---@param x number X coordinate
---@param y number Y coordinate
---@param z number Z coordinate
---@param rx number Rotation around X axis
---@param ry number Rotation around Y axis
---@param rz number Rotation around Y axis
---@param w number width
---@param h number height
---@param text string The button's text to display
---@param text_size number The text size as fraction of normal scale
---@return Button a new button
function Button:new(x, y, z, rx, ry, rz, w, h, text, text_size)
	local o = {
		text = text,
		text_size = text_size,
		position = vector.pack(x, y, z),
		rotation = vector.pack(rx, ry, rz),
		width = w,
		height = h,
		hover = false,
		active = false,
		active_color = {
			r = 0.4,
			g = 0.4,
			b = 0.4,
		},
		hovered_color = {
			r = 0.2,
			g = 0.2,
			b = 0.2,
		},
		color = {
			r = 0.1,
			g = 0.1,
			b = 0.1,
		},
		active_color_text = {
			r = 1,
			g = 1,
			b = 1,
		},
		hovered_color_text = {
			r = 1,
			g = 1,
			b = 1,
		},
		color_text = {
			r = 1,
			g = 1,
			b = 1,
		},
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

local function raycast(rayPos, rayDir, planePos, planeDir)
	local dot = rayDir:dot(planeDir)
	if math.abs(dot) < 0.001 then
		return nil
	else
		local distance = (planePos - rayPos):dot(planeDir) / dot
		if distance > 0 then
			return rayPos + rayDir * distance
		else
			return nil
		end
	end
end

--- Set the color for the button
---@param kind ColorType
---@param r number
---@param g number
---@param b number
function Button:set_color(kind, r, g, b)
	local col = {
		r = r,
		g = g,
		b = b,
	}
	if kind == "active" then
		self.active_color = col
	elseif kind == "hover" then
		self.hovered_color = col
	else
		self.color = col
	end
end

--- Set the text color for the button
---@param kind ColorType
---@param r number
---@param g number
---@param b number
function Button:set_text_color(kind, r, g, b)
	local col = {
		r = r,
		g = g,
		b = b,
	}
	if kind == "active" then
		self.active_color_text = col
	elseif kind == "hover" then
		self.hovered_color_text = col
	else
		self.color_text = col
	end
end

--- Set the text of the button
---@param text string
function Button:set_text(text)
	self.text = text
end

--- Set the text of the button
---@param size number
function Button:set_text_size(size)
	self.text_size = size
end

--- Set the text of the button
---@param x number X coordinate
---@param y number Y coordinate
---@param z number Z coordinate
---@param rx number Rotation around X axis
---@param ry number Rotation around Y axis
---@param rz number Rotation around Y axis
function Button:set_position(x, y, z, rx, ry, rz)
	self.position = vector.pack(x, y, z)
	self.rotation = vector.pack(rx, ry, rz)
end

---Draw a button at specified position with given text.
---On press, cb is executed
---@param pass Pass
function Button:draw(pass)
	-- Button background
	if self.active then
		pass:setColor(self.active_color.r, self.active_color.g, self.active_color.b)
	elseif self.hover then
		pass:setColor(self.hovered_color.r, self.hovered_color.g, self.hovered_color.b)
	else
		pass:setColor(self.color.r, self.color.g, self.color.b)
	end
	pass:plane(self.position, self.width, self.height)

	-- Button text (add a small amount to the z to put the text slightly in front of button)
	if self.active then
		pass:setColor(self.active_color_text.r, self.active_color_text.g, self.active_color_text.b)
	elseif self.hover then
		pass:setColor(self.hovered_color_text.r, self.hovered_color_text.g, self.hovered_color_text.b)
	else
		pass:setColor(self.color_text.r, self.color_text.g, self.color_text.b)
	end
	pass:text(self.text, self.position + vector.pack(0, 0, 0.001), self.text_size)
end

--- Button's event handler (should be called from lovr.update)
---@param cb function The callback function
function Button:handler(cb)
	-- From https://lovr.org/docs/Interaction/Pointer_UI, modified
	self.hover, self.active = false, false

	for hand, state in pairs(tracking.get_hands()) do
		-- Call the raycast helper function to get the intersection point of the ray and the button plane
		local hit = raycast(state.pos, state.direction, self.position, vector.pack(0, 0, 1))

		local inside = false
		if hit then
			local bx, by = self.position:unpack()
			local bw, bh = self.width / 2, self.height / 2
			inside = (hit.x > bx - bw) and (hit.x < bx + bw) and (hit.y > by - bh) and (hit.y < by + bh)
		end

		-- If the ray intersects the plane, do a bounds test to make sure the x/y position of the hit
		-- is inside the button, then mark the button as hover/active based on the trigger state.
		if inside then
			if lovr.headset.isDown(hand, "trigger") then
				self.active = true
			else
				self.hover = true
			end

			if lovr.headset.wasReleased(hand, "trigger") then
				cb()
			end
		end
	end
end

return Button
