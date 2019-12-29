require "bit"
local util = require "util"
local printf = util.printf

Cartridge = {}
Cartridge.__index = Cartridge

function Cartridge:new(filename)
    file = assert(io.open(filename, "rb"))
    if file:read(3) == "NES" and file:read(1):byte(1) == 0x1A then
        local pgr_banks_num = file:read(1):byte(1)
        local chr_banks_num = file:read(1):byte(1)
        local ctrl_byte1 = file:read(1):byte(1)
        local ctrl_byte2 = file:read(1):byte(1)
        local ram_banks_num = file:read(1):byte(1); if ram_banks_num == 0 then ram_banks = 1 end

        local has_batt_ram = bit.band(0x02, ctrl_byte1) ~= 0
        local has_trainer = bit.band(0x04, ctrl_byte1) ~= 0
        local mirroring_mode = bit.band(0x08, ctrl_byte1) == 0
        and bit.band(0x01, ctrl_byte1) or 2 -- (0x08 & ctrl_byte1 == 0) ? (0x01 & ctrl_byte1) : 2
        local mapper = bit.bor(bit.band(ctrl_byte2, 0xF0), bit.rshift(ctrl_byte1, 4)) -- (ctrl_byte2 & 0xF0) || (ctrl_byte1 >> 4)

        file:read(7) -- Unused bytes for the iNES format
        if has_trainer then file:read(512) end -- We ignore the trainer for now

        -- We fill the PGR and CHR banks with the file contents
        local pgr_banks = {}
        local chr_banks = {}
        for pgr = 1, pgr_banks_num do
            pgr_banks[pgr] = {}
            for dir = 0x0001, 0x4000 do
                pgr_banks[pgr][dir] = file:read(1):byte(1)
            end
        end

        for chr = 1, chr_banks_num do
            chr_banks[chr] = {}
            for dir = 0x0001, 0x2000 do
                chr_banks[chr][dir] = file:read(1):byte(1)
            end
        end

        return setmetatable({
            pgr_banks = pgr_banks,
            chr_banks = chr_banks,
            ram_banks_num = ram_banks_num,
            has_batt_ram = has_bat_ram,
            has_trainer = has_trainer,
            mirroring_mode = ({"HORIZONTAL", "VERTICAL", "FOUR SCREEN"})[mirroring_mode + 1],
            mapper = mapper,
            pgr = pgr,
            chr = chr,
            current_pgr_banks = {nil, nil} -- The two current accessible banks
        }, self)
    else
        error("The file is not a valid iNES rom", 2)
    end
end

function Cartridge:print_info()
    print "Cartridge info:"
    printf("Number of 16KiB PGR-ROM banks: %d", #self.pgr_banks)
    printf("Number of 8KiB CHR-ROM/VROM banks: %d", #self.chr_banks)
    printf("Number of 8KiB RAM banks: %d", self.ram_banks_num)
    if has_batt_ram then print "Has a battery-backed RAM" end
    if has_trainer then print "Has 512-byte trainer at $7000-$71FF" end
    printf("The game uses %s mirroring", self.mirroring_mode)
    printf("Mapper number: %d", self.mapper)
end

-- No mapper only
function Cartridge:load_rom()
    current_pgr_banks[1] = pgr_banks[1]
    if #pgr_banks == 1 then current_pgr_banks[2] = pgr_banks[1]
    else current_pgr_banks[2] = pgr_banks[1] end
end

-- Reads a direction from the rom (direction between $0000 and $7FFF)
function Cartridge:read(dir)
    if dir >= 0x0000 and dir < 0x4000 then
        return current_pgr_banks[1][dir]
    elseif dir >= 0x4000 and dir < 0x8000 then
        return current_pgr_banks[2][dir - 0x4000]
    else
        error("The address " .. dir .. " is invalid", 2)
    end
end

return Cartridge
