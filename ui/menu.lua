local state = require("core.state")
local button = require("ui.elements.button")
local tracking = require("util.tracking.tracking")
local audio = require("util.audio")

local M = {}

local start_menu_button = button:new(0, 1, -2, 0, 0, 0, 2, 0.5, "Start", 0.25)
local pause_menu_resume_button = button:new(0.6, 1, -2, 0, 0, 0, 1, 0.5, "Resume", 0.25)
local pause_menu_quit_button = button:new(-0.6, 1, -2, 0, 0, 0, 1, 0.5, "Quit", 0.25)
local end_menu_seek_button = button:new(0.6, 0.8, -3, 0, 0, 0, 1, 0.5, "Preview", 0.25)
local end_menu_quit_button = button:new(-0.6, 0.8, -3, 0, 0, 0, 1, 0.5, "Quit", 0.25)
local show_start_menu = true
local show_pause_menu = false
local show_end_menu = false

--- Drawer function for the start menu
---@param pass Pass
function M.start_menu_draw(pass)
    if show_start_menu then
        pass:setColor(0.2, 0.2, 0.2)
        pass:text("Hello World!", 0, 2.2, -2, 0.5)
        pass:text("BeatSketch", 0, 1.6, -2, 0.25)
        start_menu_button:draw(pass)
    end
end

--- Update handler for the start menu
function M.start_menu_update()
    if show_start_menu then
        start_menu_button:handler(M.start_menu_handler)
    end
end

--- Start Menu Button handler
function M.start_menu_handler()
    show_start_menu = false
    state.set_disp(0)
    state.set_mode("r")
    audio.start()
end

--- Drawer function for the pause menu
---@param pass Pass
function M.pause_menu_draw(pass)
    if show_pause_menu then
        pass:setColor(0.2, 0.2, 0.2)
        pass:text("PAUSED", 0, 1.8, -2, 0.5)
        pause_menu_resume_button:draw(pass)
        pause_menu_quit_button:draw(pass)
    end
end

--- Update handler for the pause menu
function M.pause_menu_update()
    if show_pause_menu then
        pause_menu_resume_button:handler(M.pause_menu_handler)
        pause_menu_quit_button:handler(function()
            lovr.event.quit(0)
        end)
    end
    tracking.handle_buttons({ "a", "b", "x", "y" }, function()
        if not show_start_menu then
            show_pause_menu = true
            state.set_mode("m")
            audio.stop()
        end
    end)
end

function M.pause_menu_handler()
    show_pause_menu = false
    state.set_mode("r")
    audio.start()
end

--- Drawer function for the pause menu
---@param pass Pass
function M.end_menu_draw(pass)
    if show_end_menu then
        pass:setColor(0.2, 0.2, 0.2)
        pass:text("RECORDING FINISHED", 0, 1.8, -3, 0.5)
        pass:text("You have finished recording the map", 0, 1.55, -3, 0.2)
        pass:text("it is now being processed.", 0, 1.4, -3, 0.2)
        pass:text("You may exit or preview the map once processing is done", 0, 1.25, -3, 0.2)
        end_menu_seek_button:draw(pass)
        end_menu_quit_button:draw(pass)
    end
end

--- Update handler for the pause menu
function M.end_menu_update()
    if show_end_menu then
        end_menu_seek_button:handler(function()
            show_pause_menu = false
            state.set_mode("v")
            audio.start()
        end)
        end_menu_quit_button:handler(function()
            lovr.event.quit(0)
        end)
    end
end

function M.open_end_menu()
    show_end_menu = true
end

return M
