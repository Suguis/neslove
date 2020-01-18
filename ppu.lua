local Ppu = {}
Ppu.__index = Ppu

function Ppu:new()
    return setmetatable({
        pattern_tables = {},
        name_tables = {},
        palettes = {},
        spr_ram = {}
    }, self)
end
