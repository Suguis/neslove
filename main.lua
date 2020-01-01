local debugging = require "debugging"
local Nes = require "nes"
local util = require "util"
local printf = util.printf
local Cartridge = require "cartridge"

nes = Nes:new()

function love.load()
    local cart = Cartridge:new(arg[2])
    nes:insert_cartridge(cart)
    cart:print_info()
    nes:reset()
end

function love.keyreleased(key, scancode)
    if key == debugging.toggle_key then
        if not debugging.on then
            love.window.setMode(Nes.DISPLAY_WIDTH + debugging.DISPLAY_LENGTH, Nes.DISPLAY_HEIGHT)
            debugging.on = true
        else
            love.window.setMode(Nes.DISPLAY_WIDTH, Nes.DISPLAY_HEIGHT)
            debugging.on = false
        end
    end
end

function love.update(dt)
    nes:render_display()
end

function love.draw()
    love.graphics.draw(nes:get_display(), 0, 0)
    if debugging.on then
        debugging.draw()
    end
end
