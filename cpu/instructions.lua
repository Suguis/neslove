local instructions = { 
    CLC = function() nes.cpu.C = 0 end,
    SEC = function() nes.cpu.C = 1 end,
    CLI = function() nes.cpu.I = 0 end,
    SEI = function() nes.cpu.I = 1 end,
    CLV = function() nes.cpu.V = 0 end,
    CLD = function() nes.cpu.D = 0 end,
    SED = function() nes.cpu.D = 1 end,
}

return instructions
