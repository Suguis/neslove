local instructions = require "instructions"

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

function Cpu:cycle()
    self.total_cycles = self.total_cycles + 1
    if self.wait_cycles == 0 then
        local instruction = self:decode_instruction(self:read(self.PC))
        if instruction then
            instruction.run()
            self.wait_cycles = instruction.cycles
        else
            error(string.format("Instruction $%02x not implemented", self:read(self.PC)))
        end
    else
        self.wait_cycles = self.wait_cycles - 1
    end
end

return Cpu
