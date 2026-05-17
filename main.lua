local state = require("core.state")
local sabers = require("ui.controllers.sabers")
local tracking = require("util.tracking.tracking")
local render = require("ui.render")
local ipc = require("util.ipc")
local cli = require("util.cli")
local printing = require("util.printing")
local audio = require("util.audio")

print("CLI ARGUMENTS:")
local args = cli.parse_cli_opts()

args["song"] = "C:/projects/vr/test/RideOn.ogg"

printing.print_table(args)

--[[
 ___               _   ___   _           _         _
(  _ \            ( )_(  _ \( )         ( )_      ( )
| (_) )  __    _ _|  _) (_(_) |/ )   __ |  _)  ___| |__
|  _ ( / __ \/ _  ) |  \__ \|   (  / __ \ |  / ___)  _  \
| (_) )  ___/ (_| | |_( )_) | |\ \(  ___/ |_( (___| | | |
(____/ \____)\__ _)\__)\____)_) (_)\____)\__)\____)_) (_)

--]]

-- ┌                                               ┐
-- │                 Configuration                 │
-- └                                               ┘
function lovr.conf(t)
	-- We can also start the headset session later on (by calling lovr.headset.start and do a desktop UI first)
	-- I have yet to figure out the resizing and stuff
	t.headset.start = true
	t.window.resizable = true
end

-- ┌                                               ┐
-- │        Load audio file (and textures)         │
-- └                                               ┘
function lovr.load()
	-- Comment this line to test VR app without running Launcher (IPC)
	--audio.load(args["song"])
end

-- ┌                                               ┐
-- │                    Drawing                    │
-- └                                               ┘
-- Drawing the screen is called once every frame
--- @param pass Pass
function lovr.draw(pass)
	sabers.draw(pass)
	render.draw(pass)
end

-- ┌                                               ┐
-- │              Physics / Tracking               │
-- └                                               ┘
-- Tracking and the like get continuous updates
function lovr.update(delta_time)
	tracking.update_hands(delta_time)
	render.update()
	state.update(delta_time)
	-- ipc.send_json(tracking.get_for_transmit())
	-- NOTE: This works, sorta well
	-- printing.print_table(ipc.get_data())
end

ipc.init(true)

-- TODO: Possibly a separate desktop mirror
-- (to draw it from 3rd person instead, could be a good effect for demo,
-- and doesn't look to be hard: https://lovr.org/docs/Flatscreen/Spectator_Camera)
