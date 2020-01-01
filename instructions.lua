local instructions = {}

instructions[0x18] = {
    name = "CLC",
    run = function()
        nes.cpu.C = 0
        nes.cpu.PC = nes.cpu.PC + 1
    end,
    disassembled = function() return "CLC" end,
    cycles = 2
}

instructions[0x38] = {
    name = "SEC",
    run = function()
        nes.cpu.C = 1
        nes.cpu.PC = nes.cpu.PC + 1
    end,
    disassembled = function() return "SEC" end,
    cycles = 2
}

instructions[0x58] = {
    name = "CLI",
    run = function()
        nes.cpu.I = 0
        nes.cpu.PC = nes.cpu.PC + 1
    end,
    disassembled = function() return "CLI" end,
    cycles = 2
}

instructions[0x78] = {
    name = "SEI",
    run = function()
        nes.cpu.I = 1
        nes.cpu.PC = nes.cpu.PC + 1
    end,
    disassembled = function() return "SEI" end,
    cycles = 2
}

instructions[0xb8] = {
    name = "CLV",
    run = function()
        nes.cpu.V = 0
        nes.cpu.PC = nes.cpu.PC + 1
    end,
    disassembled = function() return "CLV" end,
    cycles = 2
}

instructions[0xd8] = {
    name = "CLD",
    run = function()
        nes.cpu.D = 0
        nes.cpu.PC = nes.cpu.PC + 1
    end,
    disassembled = function() return "CLD" end,
    cycles = 2
}

instructions[0xf8] = {
    name = "SED",
    run = function()
        nes.cpu.D = 1
        nes.cpu.PC = nes.cpu.PC + 1
    end,
    disassembled = function() return "SED" end,
    cycles = 2
}

return instructions
