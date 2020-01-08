local bit = require "bit"

-- Set flags according to the argument
local function set_negative(byte) nes.cpu.N = bit.rshift(bit.band(0x80, byte), 7) end -- (0x80 & byte) >> 7
local function set_zero(byte) nes.cpu.Z = byte == 0x00 and 1 or 0 end

local instructions = { 
    CLC = function() nes.cpu.C = 0 end,
    CLD = function() nes.cpu.D = 0 end,
    CLI = function() nes.cpu.I = 0 end,
    CLV = function() nes.cpu.V = 0 end,
    LDA = function()
        local value = nes.cpu.op_value
        nes.cpu.A = value
        set_negative(value)
        set_zero(value)
    end,
    LDX = function()
        local value = nes.cpu.op_value
        nes.cpu.X = value
        set_negative(value)
        set_zero(value)
    end,
    SEC = function() nes.cpu.C = 1 end,
    SED = function() nes.cpu.D = 1 end,
    SEI = function() nes.cpu.I = 1 end,
    STA = function() nes.cpu:write(nes.cpu.op_addr, nes.cpu.A) end,
    TXS = function()
        local X = nes.cpu.X
        nes.cpu.SP = X
        set_negative(X)
        set_zero(X)
    end,
    TSX = function()
        local SP = nes.cpu.SP
        nes.cpu.X = SP
        set_negative(SP)
        set_zero(SP)
    end
}

return instructions
