local Mapper = {}
Mapper.__index = Mapper

function Mapper:new(index, prg_banks, chr_banks)
    return setmetatable({
        prg = prg_banks,
        current_prg = {},
        chr = chr_banks,
        current_chr = {},
        reset = Mapper.actions[index].reset,
        read = Mapper.actions[index].read,
        index = index,
    }, self)
end

Mapper.actions = {}
-- We throw an error when try to access an unimplemented mapper index
setmetatable(Mapper.actions, { __index = function(t, i) error("Unimplemented mapper number " .. i, 2) end })

Mapper.actions[0] = {
    reset = function(self)
        self.current_prg[1] = self.prg[1]
        if #self.prg == 1 then self.current_prg[2] = self.prg[1]
        else self.current_prg[2] = self.prg[2] end
    end,
    read = function(self, dir)
        if dir >= 0x0000 and dir < 0x4000 then
            return self.current_prg[1][dir + 1]
        elseif dir >= 0x4000 and dir < 0x8000 then
            return self.current_prg[2][dir - 0x4000 + 1]
        else
            error(string.format("The address 0x%04x is invalid", dir), 2)
        end 
    end
}

return Mapper
