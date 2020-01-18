local opcodes = require "cpu.opcodes"
local addr_modes = require "cpu.addr_modes"
local instructions = require "cpu.instructions"

Cpu = {}
Cpu.__index = Cpu

local flags = {
    N = 0x80,
    V = 0x40,
    B = 0x10,
    D = 0x08,
    I = 0x04,
    Z = 0x02,
    C = 0x01
}

function Cpu:new()
    return setmetatable({
        PC = 0, SP = 0xff,
        A = 0, X = 0, Y = 0,
        flags = 0,
        op_value = nil,
        op_addr = nil,
        wait_cycles = 0,
        total_cycles = 0,
        zero_page = {},
        stack = {},
        ram = {},
    }, self)
end

function Cpu:set_flag(flag, value)
    if value == 0 then
        self.flags = bit.band(self.flags, bit.bnot(flags[flag]))
    else
        self.flags = bit.bor(self.flags, flags[flag])
    end
end

function Cpu:get_flag(flag)
    local mask = flags[flag]
    local req_flag = self.flags
    while mask ~= 0x01 do
        mask = bit.rshift(mask, 1)
        req_flag = bit.rshift(req_flag, 1)
    end
    return bit.band(req_flag, 0x01)
end

function Cpu:read(addr)
    if addr >= 0x0000 and addr < 0x0100 then
        return self.zero_page[addr + 1]
    elseif addr < 0x0200 then
        return self.stack[addr - 0xff]
    elseif addr < 0x0800 then
        local value = self.ram[addr - 0x1ff]
        if value then return value
        else print("WARNING: Reading an unwritten value of RAM, returning 0xff"); return 0xff end
    elseif addr < 0x2000 then -- Mirrors $0000-$07ff
        return self:read(addr % 0x800)
    elseif addr < 0x4000 then
        local value = nes.io[1][((addr - 0x2000) % 8) + 1]
        if value then return value
        else print("WARNING: Reading an unwritten value of I/O, returning 0xff"); return 0xff end
    elseif addr < 0x4020 then
        local value = nes.io[1][addr - 0x3fff]
        if value then return value
        else print("WARNING: Reading an unwritten value of I/O, returning 0x00"); return 0x00 end
    elseif addr >= 0x8000 and addr < 0xffff then
        return nes.cartridge.mapper:read(addr - 0x8000)
    else
        error("Reading out of range")
    end
end

function Cpu:write(addr, data)
    if addr >= 0x0000 and addr < 0x0100 then
        self.zero_page[addr + 1] = data
    elseif addr < 0x0200 then
        self.stack[addr - 0xff] = data
    elseif addr < 0x0800 then
        self.ram[addr - 0x1ff] = data
    elseif addr < 0x2000 then
        self:write(addr % 0x0800, data)
    elseif addr < 0x4000 then
        nes.io[1][((addr - 0x200) % 8) + 1] = data
    elseif addr < 0x4020 then
        nes.io[1][addr - 0x3fff] = data
    elseif addr >= 0x8000 and addr < 0xffff then
        print("ROM writing not supported yet")
    end
end

function Cpu:reset()
    self.PC = bit.bor(self:read(0xfffc), bit.lshift(self:read(0xfffd), 8))
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
        local diff_page
        self.op_value, self.op_addr, diff_page = address()
        run_instruction()
        -- If the opcode indicates that one aditional cycle is required if page boundary crossed
        if operation.add_if_page_crossed and diff_page then
            self.wait_cycles = self.wait_cycles + operation.cycles + 1
        else
            self.wait_cycles = self.wait_cycles + operation.cycles
        end
    else
        error(string.format("Instruction $%02x not implemented", opcode))
    end
end

function Cpu:run()
    local cycles = 21441960 / 60
    while cycles > 0 do
        self:cycle()
        cycles = cycles - 1
    end
end

function Cpu:cycle()
    self.total_cycles = self.total_cycles + 1
    if self.wait_cycles == 0 then
        self:fetch()
    end
    self.wait_cycles = self.wait_cycles - 1
end

return Cpu
