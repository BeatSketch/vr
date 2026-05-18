local state = require("core.state")
local sabers = require("ui.controllers.sabers")
local tracking = require("util.tracking.tracking")
local render = require("ui.render")
local ipc = require("util.ipc")
local cli = require("util.cli")
local printing = require("util.printing")
local audio = require("util.audio")

-- CLI Argument style is key=val, so for song e.g.
-- song=<PATH>
print("CLI ARGUMENTS:")
local args = cli.parse_cli_opts()
printing.print(args)
local launch_with_launcher = args["launcher"] and args["launcher"] == "true"
if not args["song"] then
	local cwd = os.getenv("PWD")
	args["song"] = cwd .. "/test/audio.mp3"
	args["mirror"] = "true"
end

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
	t.identity = "beatsketch"
	t.window.width = 1920
	t.window.resizable = true
end

local x, y, z = -3, 3, 3
local view = lovr.math.newMat4():lookAt(vec3(x, y, z), vec3(0, 0, 0))
-- ┌                                               ┐
-- │        Load audio file (and textures)         │
-- └                                               ┘
function lovr.load()
	if args["song"] then
		audio.load(args["song"])
	else
		print("\n[WARNING] No song specified, thus no audio was loaded")
	end
end

-- ┌                                               ┐
-- │                    Drawing                    │
-- └                                               ┘
-- Drawing the screen is called once every frame
function lovr.draw(pass)
	sabers.draw(pass)
	render.draw(pass)
end

-- TODO: Possibly a separate desktop mirror
-- (to draw it from 3rd person instead, could be a good effect for demo,
-- and doesn't look to be hard: https://lovr.org/docs/Flatscreen/Spectator_Camera)
if not args["mirror"] or args["mirror"] == "false" then
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
	tracking.update_hands()
	render.update()
	state.update(delta_time)
	if launch_with_launcher then
		ipc.send_json(tracking.get_for_transmit())
	end
	-- NOTE: This works, sorta well
	-- printing.print_table(ipc.get_data())
end

ipc.init(launch_with_launcher)
