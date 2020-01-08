local addr_modes = { 
    ABSOLUTE = function()
        local last = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local first = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local dir = bit.bor(bit.lshift(first, 8), last) -- (first << 8) | last
        local value = nes.cpu:read(dir)
        return value, dir
    end,
    IMPLIED = function() end,
    INMEDIATE = function()
        local value = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        return value
    end,
}

return addr_modes
