local function opcode(ins, addrm, cyc)
    return {
        instruction = ins,
        addr_mode = addrm,
        cycles = cyc
    }
end

local opcodes = {
    [0x10] = opcode("BPL", "RELATIVE", 2),
    [0x18] = opcode("CLC", "IMPLIED", 2),
    [0x38] = opcode("SEC", "IMPLIED", 2),
    [0x58] = opcode("CLI", "IMPLIED", 2),
    [0x78] = opcode("SEI", "IMPLIED", 2),
    [0x8d] = opcode("STA", "ABSOLUTE", 3),
    [0x9a] = opcode("TXS", "IMPLIED", 2),
    [0xa2] = opcode("LDX", "INMEDIATE", 2),
    [0xa9] = opcode("LDA", "INMEDIATE", 2),
    [0xad] = opcode("LDA", "ABSOLUTE", 4),
    [0xb8] = opcode("CLV", "IMPLIED", 2),
    [0xba] = opcode("TSX", "IMPLIED", 2),
    [0xd8] = opcode("CLD", "IMPLIED", 2),
    [0xf8] = opcode("SED", "IMPLIED", 2),
}

return opcodes
