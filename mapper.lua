local Mapper = {}
Mapper.__index = Mapper

local load_rom_functions = {
    [0] = load_rom

function Mapper:new(n, )
    return setmetatable({
        load_rom = function(self)
            
end
