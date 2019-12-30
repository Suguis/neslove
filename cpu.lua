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
        N = 0
    }, self)
end

function Cpu:read(addr, data)
    if addr >= 0x8000 and addr < 0xFFFF then
        return nes.cartridge:read(addr - 0x8000)
    end
end
        
function Cpu:write(addr, data)
    if addr >= 0x8000 and addr < 0xFFFF then
    end
end

function Cpu:reset()
    self.PC = bit.bor(self:read(0xFFFC), bit.lshift(self:read(0xFFFD), 8))
end

return Cpu
