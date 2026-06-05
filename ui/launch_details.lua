local M = {}

--- Draw the launch details menu
---@param pass Pass
function M.draw(pass)
	pass:setColor(0.2, 0.2, 0.2)
	pass:text("BeatSketch", 0, 1.8, -3, 0.5)
	pass:text("Please launch using the BeatSketchLauncher", 0, 1.55, -3, 0.2)
	pass:text("executable. This is the VR application", 0, 1.4, -3, 0.2)
	pass:text("It is not intended for standalone use", 0, 1.25, -3, 0.2)
end

return M
