local opcodes = require "cpu.opcodes"
local addr_modes = require "cpu.addr_modes"
local instructions = require "cpu.instructions"

Cpu = {}
Cpu.__index = Cpu

function Cpu:new()
    return setmetatable({
        PC = 0,
        SP = 0,
        A = 0,
        X = 0,
        Y = 0,
        C = 0,
        Z = 0,
        I = 0,
        D = 0,
        B = 0,
        V = 0,
        N = 0,
        operand = nil,
        wait_cycles = 0,
        total_cycles = 0
    }, self)
end

function Cpu:read(addr)
    if addr >= 0x8000 and addr < 0xFFFF then
        return nes.cartridge.mapper:read(addr - 0x8000)
    end
end
        
function Cpu:write(addr, data)
    if addr >= 0x8000 and addr < 0xFFFF then
    end
end

function Cpu:reset()
    self.PC = bit.bor(self:read(0xFFFC), bit.lshift(self:read(0xFFFD), 8))
end

function Cpu:decode_instruction(opcode)
    return instructions[opcode]
end

function Cpu:fetch()
    local opcode = self:read(self.PC)
    self.PC = self.PC + 1
    local operation = opcodes[opcode]
    if operation then
        local run_instruction = instructions[operation.instruction]
        local address = addr_modes[operation.addr_mode]
        self.wait_cycles = operation.cycles
        self.operand = address()
        run_instruction()
    else
        error(string.format("Instruction $%02x not implemented", opcode))
    end
end

function Cpu:cycle()
    self.total_cycles = self.total_cycles + 1
    if self.wait_cycles == 0 then
        self:fetch()
    else
        self.wait_cycles = self.wait_cycles - 1
    end
end

return Cpu
