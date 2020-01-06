local function opcode(ins, addrm, cyc)
    return {
        instruction = ins,
        addr_mode = addrm,
        cycles = cyc
    }
end

local opcodes = {
    [0x18] = opcode("CLC", "IMPLIED", 2),
    [0x38] = opcode("SEC", "IMPLIED", 2),
    [0x58] = opcode("CLI", "IMPLIED", 2),
    [0x78] = opcode("SEI", "IMPLIED", 2),
    [0xb8] = opcode("CLV", "IMPLIED", 2),
    [0xd8] = opcode("CLD", "IMPLIED", 2),
    [0xf8] = opcode("SED", "IMPLIED", 2),
}

return opcodes
