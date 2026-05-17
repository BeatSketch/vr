local M = {}
--- Global data for the vr application

--- Current vr app mode
--- @type "r" | "v" | "m"
M.mode = "m"

--- Current Song's bpm
--- @type number
M.bpm = 120

--- Amount of grid subdivision within 1 beat
--- @type 1 | 2 | 4 | 8 | 16
M.beat_div = 4

--- Current Song's length in seconds
--- @type number
M.len = 160

--- How fast notes move towards user
--- @type number
M.spd = 10

--- Current timestamp within selected song 
--- @type number
M.time = 0

--- Displacement of the grid (i.e. position within level)
--- @type number
M.disp = 0

--- Previous displacement. Stored when entering `v`, returned to when entering `r`
--- @type number 
M.prev_disp = 0

--- Set current vr app mode
--- @param new_mode "r" | "v" | "m" record, view or menu
M.set_mode = function(new_mode)
    if (M.mode == 'r' and new_mode == 'v') then
        --- Store displacement when seeking
        M.prev_disp = M.disp
    elseif (M.mode == 'v' and new_mode == 'r') then
        --- revert to previous displacement after seeking
        M.disp = M.prev_disp
        M.prev_disp = 0
    end
    M.mode = new_mode
end

--- Set current displacement for rendering
--- @param disp number
M.set_disp = function(disp)
    M.disp = disp
end

--- Set current song's bpm
--- @param bpm number
M.set_bpm = function(bpm)
    M.bpm = bpm
end

--- Update current displacement
--- @param dt number deltatime
M.update_disp = function(dt)
    M.time = M.time + dt
    if (M.mode =="r") then
        M.disp = M.disp + (dt * M.spd)
    elseif (M.mode == "v") then
        --- move via controller input
    end 
end

--- Return to origin
M.reset_disp = function()
    M.disp = 0
    M.prev_disp = 0
end

return M