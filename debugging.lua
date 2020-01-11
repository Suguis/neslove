local bit = require "bit"
local opcodes = require "cpu.opcodes"

local debugging = {
    DISPLAY_LENGTH = 256,
    LINES = 14,
    font = love.graphics.newFont("terminus.ttf"),
    on = true,
    full_running = false,
    toggle_key = "d",
    step_key = "s",
    run_key = "r"
}

local function disas(addr)
    local opcode = nes.cpu:read(addr)
    local operation = opcodes[opcode]
    if operation then
        if operation.addr_mode == "ABSOLUTE" then
            local last = nes.cpu:read(addr + 1)
            local first = nes.cpu:read(addr + 2)
            local addr = bit.bor(bit.lshift(first, 8), last)
            return string.format("%s $%04x", operation.instruction, addr), 3
        elseif operation.addr_mode == "ABSOLUTE,X" then
            local last = nes.cpu:read(addr + 1)
            local first = nes.cpu:read(addr + 2)
            local addr = bit.bor(bit.lshift(first, 8), last)
            return string.format("%s $%04x,X", operation.instruction, addr), 3
        elseif operation.addr_mode == "ABSOLUTE,Y" then
            local last = nes.cpu:read(addr + 1)
            local first = nes.cpu:read(addr + 2)
            local addr = bit.bor(bit.lshift(first, 8), last)
            return string.format("%s $%04x,Y", operation.instruction, addr), 3
        elseif operation.addr_mode == "IMPLIED" then
            return operation.instruction, 1
        elseif operation.addr_mode == "INDIRECT,Y" then
            local operator = nes.cpu:read(addr + 1)
            return string.format("%s ($%02x),Y", operation.instruction, operator), 2
        elseif operation.addr_mode == "INMEDIATE" then
            return string.format("%s #$%02x", operation.instruction, nes.cpu:read(addr + 1)), 2
        elseif operation.addr_mode == "RELATIVE" then
            local len = 2
            local offset = nes.cpu:read(addr + 1)
            return string.format("%s $%04x", operation.instruction, addr + len + (bit.band(0x80, offset) == 0x80 and (offset - 0x100) or offset)), len
        elseif operation.addr_mode == "ZERO_PAGE" then
            local addr = nes.cpu:read(addr + 1)
            return string.format("%s $%02x", operation.instruction, addr), 2
        end
    else
        return "???", 1
    end
end

function debugging.update(key)
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
        debugging.full_running = false
    elseif key == debugging.run_key then
        debugging.full_running = true
    end
end

function debugging.draw()
    love.graphics.setFont(debugging.font)
    love.graphics.print(string.format("PC=$%04x SP=$%02x cycles=%d\nA=$%02x X=$%02x Y=$%02x\nC=%d Z=%d I=%d D=%d B=%d V=%d N=%d",
    nes.cpu.PC, nes.cpu.SP, nes.cpu.total_cycles, nes.cpu.A, nes.cpu.X, nes.cpu.Y, nes.cpu.C, nes.cpu.Z, nes.cpu.I, nes.cpu.D, nes.cpu.B, nes.cpu.V, nes.cpu.N),
    debugging.DISPLAY_LENGTH + 1, 0)
    local curr_addr = nes.cpu.PC
    for i = 1, debugging.LINES do
        local ins, len = disas(curr_addr)
        love.graphics.print(string.format("%s$%04x: %s", curr_addr == nes.cpu.PC and ">" or " ", curr_addr, ins), nes.DISPLAY_WIDTH + 1, (i+4) * 12)
        curr_addr = curr_addr + len
    end
end

return debugging
