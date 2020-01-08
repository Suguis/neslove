local bit = require "bit"
local opcodes = require "cpu.opcodes"

local debugging = {
    DISPLAY_LENGTH = 256,
    LINES = 14,
    font = love.graphics.newFont("terminus.ttf"),
    on = false,
    toggle_key = "d",
    step_key = "s"
}

local function disas(dir)
    local opcode = nes.cpu:read(dir)
    local operation = opcodes[opcode]
    if operation then
        if operation.addr_mode == "ABSOLUTE" then
            local last = nes.cpu:read(dir + 1)
            local first = nes.cpu:read(dir + 2)
            local dir = bit.bor(bit.lshift(first, 8), last)
            return string.format("%s $%04x", operation.instruction, dir), 3
        elseif operation.addr_mode == "IMPLIED" then
            return operation.instruction, 1
        elseif operation.addr_mode == "INMEDIATE" then
            return string.format("%s #$%02x", operation.instruction, nes.cpu:read(dir + 1)), 2
        end
    else
        return "???", 1
    end
end

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
    local curr_dir = nes.cpu.PC
    for i = 1, debugging.LINES do
        local ins, len = disas(curr_dir)
        love.graphics.print(string.format("%s$%04x: %s", curr_dir == nes.cpu.PC and ">" or " ", curr_dir, ins), nes.DISPLAY_WIDTH + 1, (i+4) * 12)
        curr_dir = curr_dir + len
    end
end

return debugging
