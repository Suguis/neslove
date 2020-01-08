local bit = require "bit"

local instructions = { 
    CLC = function() nes.cpu.C = 0 end,
    CLD = function() nes.cpu.D = 0 end,
    CLI = function() nes.cpu.I = 0 end,
    CLV = function() nes.cpu.V = 0 end,
    LDA = function()
        local operand = nes.cpu.operand
        nes.cpu.A = operand
        nes.cpu.N = bit.band(0x80, operand) == 0x80 and 1 or 0
        nes.cpu.Z = operand == 0x00 and 1 or 0
    end,
    SEC = function() nes.cpu.C = 1 end,
    SED = function() nes.cpu.D = 1 end,
    SEI = function() nes.cpu.I = 1 end,
    STA = function() nes.cpu:write(nes.cpu.operand, nes.cpu.A) end
}

return instructions
