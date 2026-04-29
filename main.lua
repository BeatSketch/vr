local sabers = require("ui.controllers.sabers")
local tracking = require("util.tracking.tracking")
local render = require("ui.render")
local ipc = require("util.ipc")
local cli = require("util.cli")

cli.parse_cli_opts()

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
    ipc.send_json(tracking.get_for_transmit())
end

-- TODO: Allow gets (but only if certain args are set)
ipc.init(false)
