local instructions = require "instructions"
local bit = require "bit"

local debugging = {
    DISPLAY_LENGTH = 256,
    font = love.graphics.newFont("terminus.ttf"),
    on = false,
    toggle_key = "d",
    step_key = "s"
}

function debugging.update()
    if key == debugging.toggle_key then
        if not debugging.on then
            love.window.setMode(Nes.DISPLAY_WIDTH + debugging.DISPLAY_LENGTH, Nes.DISPLAY_HEIGHT)
            debugging.on = true
        else
            love.window.setMode(Nes.DISPLAY_WIDTH, Nes.DISPLAY_HEIGHT)
            debugging.on = false
        end
    elseif key == debugging.step_key then
        nes.cpu:cycle()
    end 
end

function debugging.draw()
    love.graphics.setFont(debugging.font)
    love.graphics.print(string.format("PC=$%04x SP=$%02x cycles=%d\nA=$%02x X=$%02x Y=$%02x\nC=%d Z=%d I=%d D=%d B=%d V=%d N=%d",
    nes.cpu.PC, nes.cpu.SP, nes.cpu.total_cycles, nes.cpu.A, nes.cpu.X, nes.cpu.Y, nes.cpu.C, nes.cpu.Z, nes.cpu.I, nes.cpu.D, nes.cpu.B, nes.cpu.V, nes.cpu.N),
    debugging.DISPLAY_LENGTH + 1, 0)
    for i = 1, 10 do 
        dir = nes.cpu.PC - 5 + i 
        local val = nes.cpu:read(dir)
        if dir > 0xFFFF or dir < 0x8000 then val = 0 end 
        love.graphics.print(string.format("%s$%04x: $%02x %s", dir == nes.cpu.PC and ">" or " ", dir, val, instructions[val] and instructions[val].disassembled() or ""), debugging.DISPLAY_LENGTH + 1, (i+4) * 12) 
    end
end

return debugging
