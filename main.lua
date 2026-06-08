--[[
     ___               _   ___   _           _         _
    (  _ \            ( )_(  _ \( )         ( )_      ( )
    | (_) )  __    _ _|  _) (_(_) |/ )   __ |  _)  ___| |__
    |  _ ( / __ \/ _  ) |  \__ \|   (  / __ \ |  / ___)  _  \
    | (_) )  ___/ (_| | |_( )_) | |\ \(  ___/ |_( (___| | | |
    (____/ \____)\__ _)\__)\____)_) (_)\____)\__)\____)_) (_)


    A VR Beat Saber Map maker allowing you to simply play the map to create it
    Copyright (C) 2026 BeatSketch Maintainers

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

local sabers = require("ui.controllers.sabers")
local render = require("ui.render")
local ipc = require("util.ipc.main")
local cli = require("util.cli")
local audio = require("util.audio")
local updates = require("core.updates")
local blocks = require("ui.elements.blocks")
local state = require("core.state")
local launch_details = require("ui.launch_details")

-- CLI Argument style is key=val, so for song e.g. song=<PATH>
local args = cli.parse_cli_opts()
local launch_with_launcher = args["launcher"] and args["launcher"] == "true"
if not launch_with_launcher then
	print("NOTICE: This application is not meant to be launched without the launcher, apart from testing purposes")
end

-- ┌                                               ┐
-- │                 Configuration                 │
-- └                                               ┘
function lovr.conf(t)
	-- We can also start the headset session later on (by calling lovr.headset.start and do a desktop UI first)
	-- I have yet to figure out the resizing and stuff
	t.headset.start = true
	t.identity = "beatsketch"
	t.window.title = "BeatSketch VR"
	t.window.resizable = true
end

-- ┌                                               ┐
-- │        Load audio file (and textures)         │
-- └                                               ┘
function lovr.load()
	if args["song"] then
		audio.load(args["song"])
		state.len = audio.get_duration()
		ipc.send_plain("proc:duration:" .. tostring(state.len))
	else
		print("\n[WARNING] No song specified, thus no audio was loaded")
	end
	blocks.load_texture()
end

-- ┌                                               ┐
-- │                    Drawing                    │
-- └                                               ┘
if args["song"] then
	-- Drawing the screen is called once every frame
	function lovr.draw(pass)
		sabers.draw(pass)
		render.draw(pass)
		blocks.draw(pass)
	end

	-- Desktop mirror. Can be disabled
	if args["mirror"] and args["mirror"] == "true" then
		local x, y, z = -3, 3, 3
		local view = lovr.math.newMat4():lookAt(vec3(x, y, z), vec3(0, 0, 0))
		function lovr.mirror(pass)
			pass:transform(view)
			sabers.draw(pass)
			render.draw(pass)
			return false
		end
	end

	-- ┌                                               ┐
	-- │              Physics / Tracking               │
	-- └                                               ┘
	-- Tracking and the like get continuous updates
	function lovr.update(delta_time)
		updates.update_handler(delta_time, launch_with_launcher)
	end

	updates.configure(args)
	ipc.init(launch_with_launcher)
else
	function lovr.draw(pass)
        launch_details.draw(pass)
    end
end

-- Load existing blocks
-- CONCEPT: Send request for them over IPC and then await them (using the ipc.get_data function)
-- then add them, and proceed
