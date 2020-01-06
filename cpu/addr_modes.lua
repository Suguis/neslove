local addr_modes = { 
    ABSOLUTE = function()
        local last = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local first = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local operand = bit.bor(bit.lshift(first, 8), last) -- (first << 8) | last
        return operand
    end,
    IMPLIED = function() end,
    INMEDIATE = function()
        local operand = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        return operand
    end,
}

return addr_modes
