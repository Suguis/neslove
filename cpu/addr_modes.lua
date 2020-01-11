local different_page = (require "util").different_page

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
    ["ABSOLUTE,X"] = function()
        local last = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local first = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local addr = bit.bor(bit.lshift(first, 8), last) + nes.cpu.X
        local value = nes.cpu:read(addr)
        if different_page(addr, nes.cpu.PC) then nes.cpu.wait_cycles = nes.cpu.wait_cycles + 1 end
        return value, addr
    end,
    ["ABSOLUTE,Y"] = function()
        local last = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local first = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local addr = bit.bor(bit.lshift(first, 8), last) + nes.cpu.Y
        local value = nes.cpu:read(addr)
        if different_page(addr, nes.cpu.PC) then nes.cpu.wait_cycles = nes.cpu.wait_cycles + 1 end
        return value, addr
    end,
    IMPLIED = function() end,
    INMEDIATE = function()
        local value = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        return value
    end,
    ["INDIRECT,Y"] = function()
        local operand = nes.cpu:read(nes.cpu.PC)
        nes.cpu.PC = nes.cpu.PC + 1
        local last = nes.cpu:read(operand)
        local first = nes.cpu:read(operand + 1)
        local addr = bit.bor(bit.lshift(first, 8), last) + nes.cpu.Y
        local value = nes.cpu:read(addr)
        return value, addr
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
    end,
    ZERO_PAGE = function()
        local addr = nes.cpu:read(nes.cpu.PC)
        local value = nes.cpu:read(addr)
        nes.cpu.PC = nes.cpu.PC + 1
        return value, addr
    end
}

return addr_modes
