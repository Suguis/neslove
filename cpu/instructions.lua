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
    BCC = branch("C", 0),
    BCS = branch("C", 1),
    BMI = branch("N", 1),
    BNE = branch("Z", 0),
    BEQ = branch("Z", 1),
    BPL = branch("N", 0),
    BVC = branch("V", 0),
    BVS = branch("V", 1),
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
    CPX = function()
        local X = nes.cpu.X
        local value = nes.cpu.op_value
        nes.cpu.C = X >= value and 1 or 0
        nes.cpu.Z = X == value and 1 or 0
        set_negative(X)
    end,
    CPY = function()
        local Y = nes.cpu.Y
        local value = nes.cpu.op_value
        nes.cpu.C = Y >= value and 1 or 0
        nes.cpu.Z = Y == value and 1 or 0
        set_negative(Y)
    end,
    DEX = function()
        local new_X = bit.band(nes.cpu.X - 1, 0xff)
        nes.cpu.X = new_X
        set_negative(new_X)
        set_zero(new_X)
    end,
    DEY = function()
        local new_Y = bit.band(nes.cpu.Y - 1, 0xff)
        nes.cpu.Y = new_Y
        set_negative(new_Y)
        set_zero(new_Y)
    end,
    INX = function()
        local new_X = bit.band(nes.cpu.X + 1, 0xff)
        nes.cpu.X = new_X
        set_negative(new_X)
        set_zero(new_X)
    end,
    INY = function()
        local new_Y = bit.band(nes.cpu.Y + 1, 0xff)
        nes.cpu.Y = new_Y
        set_negative(new_Y)
        set_zero(new_Y)
    end,
    JSR = function()
        local addr = nes.cpu.op_addr
        local stack_addr = bit.bor(nes.cpu.SP, 0x100)
        nes.cpu:write(stack_addr, nes.cpu.PC - 1)
        nes.cpu.SP = bit.band(nes.cpu.SP - 1, 0xff)
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
    STX = function() nes.cpu:write(nes.cpu.op_addr, nes.cpu.X) end,
    TAX = function()
        local A = nes.cpu.A
        nes.cpu.X = A
        set_negative(A)
        set_zero(A)
    end,
    TAY = function()
        local A = nes.cpu.A
        nes.cpu.Y = A
        set_negative(A)
        set_zero(A)
    end,
    TXA = function()
        local X = nes.cpu.X
        nes.cpu.A = X
        set_negative(X)
        set_zero(X)
    end,
    TYA = function()
        local Y = nes.cpu.Y
        nes.cpu.A = Y
        set_negative(Y)
        set_zero(Y)
    end,
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
