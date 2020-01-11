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

function love.keypressed(key, scancode)
    if debugging then -- If the debugging module is loaded
        debugging.update(key)
    end
end

function love.update(dt)
    nes:render_display()
    if debugging.full_running then nes.cpu:run() end
end

function love.draw()
    love.graphics.draw(nes:get_display(), 0, 0)
    if debugging.on then
        debugging.draw()
    end
end
