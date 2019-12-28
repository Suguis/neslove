local Nes = require "nes"
local Cartridge = require "cartridge"
local debug = false

nes = Nes:new()

function love.load()
    local cart = Cartridge:new(arg[2])
    nes:insert_cartridge(cart)
    cart:print_info()
end

function love.keyreleased(key, scancode)
    if key == "d" then
        if debug == false then
            love.window.setMode(Nes.DISPLAY_WIDTH + 256, Nes.DISPLAY_HEIGHT)
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
end
