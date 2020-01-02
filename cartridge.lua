local Mapper = require "mapper"
local bit = require "bit"
local util = require "util"
local printf = util.printf

Cartridge = {}
Cartridge.__index = Cartridge

function Cartridge:new(filename)
    file = assert(io.open(filename, "rb"))
    if file:read(3) == "NES" and file:read(1):byte(1) == 0x1A then
        local prg_banks = file:read(1):byte(1)
        local chr_banks = file:read(1):byte(1)
        local ctrl_byte1 = file:read(1):byte(1)
        local ctrl_byte2 = file:read(1):byte(1)
        local ram_banks = file:read(1):byte(1); if ram_banks == 0 then ram_banks = 1 end

        local has_batt_ram = bit.band(0x02, ctrl_byte1) ~= 0
        local has_trainer = bit.band(0x04, ctrl_byte1) ~= 0
        local mirroring_mode = bit.band(0x08, ctrl_byte1) == 0
        and bit.band(0x01, ctrl_byte1) or 2 -- (0x08 & ctrl_byte1 == 0) ? (0x01 & ctrl_byte1) : 2
        local mapper_index = bit.bor(bit.band(ctrl_byte2, 0xF0), bit.rshift(ctrl_byte1, 4)) -- (ctrl_byte2 & 0xF0) || (ctrl_byte1 >> 4)

        file:read(7) -- Unused bytes for the iNES format

        if has_trainer then file:read(512) end -- We ignore the trainer for now

        -- We fill the PRG and CHR banks with the file contents
        local prg = {}
        local chr = {}
        for bank = 1, prg_banks do
            prg[bank] = {}
            for dir = 0x0001, 0x4000 do
                prg[bank][dir] = file:read(1):byte(1)
            end
        end

        for bank = 1, chr_banks do
            chr[bank] = {}
            for dir = 0x0001, 0x2000 do
                chr[bank][dir] = file:read(1):byte(1)
            end
        end

        return setmetatable({
            ram_banks = ram_banks,
            has_batt_ram = has_batt_ram,
            has_trainer = has_trainer,
            mirroring_mode = ({"HORIZONTAL", "VERTICAL", "FOUR SCREEN"})[mirroring_mode + 1],
            mapper = Mapper:new(mapper_index, prg, chr)
        }, self)
    else
        error("The file is not a valid iNES rom", 2)
    end
end

function Cartridge:print_info()
    print "Cartridge info:"
    printf("Number of 16KiB PRG-ROM banks: %d", #self.mapper.prg)
    printf("Number of 8KiB CHR-ROM/VROM banks: %d", #self.mapper.chr)
    printf("Number of 8KiB RAM banks: %d", self.ram_banks)
    if has_batt_ram then print "Has a battery-backed RAM" end
    if has_trainer then print "Has 512-byte trainer at $7000-$71FF" end
    printf("The game uses %s mirroring", self.mirroring_mode)
    printf("Mapper number: %d", self.mapper.index)
end

-- Reads a direction from the rom (direction between $0000 and $7FFF)
function Cartridge:read(dir)
    return self.mapper:read(dir)
end

return Cartridge
