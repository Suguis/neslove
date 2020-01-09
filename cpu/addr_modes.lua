local addr_modes = { 
    ABSOLUTE = function()
        local last = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local first = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local addr = bit.bor(bit.lshift(first, 8), last) -- (first << 8) | last
        local value = nes.cpu:read(addr)
        return value, addr
    end,
    IMPLIED = function() end,
    INMEDIATE = function()
        local value = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        return value
    end,
    RELATIVE = function()
        local offset = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        -- If has the signed bit
        if bit.band(offset, 0x80) == 0x80 then
            -- We force it to be a negative Lua number
            offset = offset - 0x100
        end
        local addr = nes.cpu.PC + offset
        return nil, addr
    end
}

return addr_modes
