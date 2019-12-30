local Nes = require "nes"
local util = require "util"
local printf = util.printf
local Cartridge = require "cartridge"
local debug = false
local DEBUG_DISPLAY_LENGTH = 256

nes = Nes:new()

function love.load()
    local cart = Cartridge:new(arg[2])
    nes:insert_cartridge(cart)
    cart:print_info()
    nes:reset()
end

function love.keyreleased(key, scancode)
    if key == "d" then
        if not debug then
            love.window.setMode(Nes.DISPLAY_WIDTH + DEBUG_DISPLAY_LENGTH, Nes.DISPLAY_HEIGHT)
            debug = true
        else
            love.window.setMode(Nes.DISPLAY_WIDTH, Nes.DISPLAY_HEIGHT)
            debug = false
        end
    end
end

function love.update(dt)
    nes:render_display()
end

function love.draw()
    love.graphics.draw(nes:get_display(), 0, 0)
    if debug then
        for i = 1, 10 do
            dir = nes.cpu.PC - 5 + i
            local val = nes.cpu:read(dir)
            if dir > 0xFFFF or dir < 0x8000 then val = 0 end
            love.graphics.print(string.format("0x%04x: 0x%02x", dir, val), DEBUG_DISPLAY_LENGTH + 4, (i-1) * 12)
        end
    end
end
