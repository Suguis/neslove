local Nes = require "nes"
local Cartridge = require "cartridge"
local debug = false

nes = Nes:new()

function love.load()
    local cart = Cartridge:new(arg[2])
    nes:insert_cartridge(cart)
    cart:print_info()
end

function love.update(dt)
end

function love.keyreleased(key, scancode)
    if key == "d" then
        if debug == false then
            love.window.setMode(Nes.SCREEN_WIDTH + 256, Nes.SCREEN_HEIGHT)
            debug = true
        else
            love.window.setMode(Nes.SCREEN_WIDTH, Nes.SCREEN_HEIGHT)
            debug = false
        end
    end
end

function love.draw()
end
