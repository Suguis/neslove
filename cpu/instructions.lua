local bit = require "bit"
local different_page = (require "util").different_page

-- Set flags according to the argument
local function set_negative(byte) nes.cpu.N = bit.rshift(bit.band(0x80, byte), 7) end -- (0x80 & byte) >> 7
local function set_zero(byte) nes.cpu.Z = byte == 0x00 and 1 or 0 end

local function branch(register, value)
    return function()
        local addr = nes.cpu.op_addr
        if nes.cpu[register] == value then
            nes.cpu.wait_cycles = nes.cpu.wait_cycles + 1
            if different_page(nes.cpu.PC, addr) then
                nes.cpu.wait_cycles = nes.cpu.wait_cycles + 1
            end
            nes.cpu.PC = addr
        end
    end
end

local instructions = {
    BCS = branch("C", 1),
    BPL = branch("N", 0),
    CLC = function() nes.cpu.C = 0 end,
    CLD = function() nes.cpu.D = 0 end,
    CLI = function() nes.cpu.I = 0 end,
    CLV = function() nes.cpu.V = 0 end,
    CMP = function()
        local A = nes.cpu.A
        local value = nes.cpu.op_value
        nes.cpu.C = A >= value and 1 or 0
        nes.cpu.Z = A == value and 1 or 0
        set_negative(A)
    end,
    JSR = function()
        local addr = nes.cpu.op_addr
        local stack_addr = bit.bor(nes.cpu.SP, 0x100)
        nes.cpu:write(stack_addr, nes.cpu.PC - 1)
        nes.cpu.SP = nes.cpu.SP - 1
        nes.cpu.PC = addr
    end,
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
    LDY = function()
        local value = nes.cpu.op_value
        nes.cpu.Y = value
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
