local Cpu = require "cpu.cpu"
local util = require "util"
local rgb = util.rgb

Nes = { 
    DISPLAY_WIDTH = 256,
    DISPLAY_HEIGHT = 240 
}
Nes.__index = Nes 

function Nes:new()
    local pixels = {}
    for i = 1, self.DISPLAY_HEIGHT do
        pixels[i] = {}
        for j = 1, self.DISPLAY_WIDTH do
            pixels[i][j] = rgb(255, 255, 255)
        end
    end
    return setmetatable({
        cpu = Cpu:new(),
        cartridge = nil,
        pixels = pixels,
        display = love.graphics.newCanvas(DISPLAY_WIDTH, DISPLAY_HEIGHT),
        io = {{}, {}} -- first for $2000-$2007, second for $4000-$401F
    }, self)
end

function Nes:insert_cartridge(cartridge)
    self.cartridge = cartridge
end

function Nes:reset()
    self.cartridge.mapper:reset()
    self.cpu:reset()
end

function Nes:render_display()
    self.display:renderTo(function()
        for i = 1, self.DISPLAY_HEIGHT do
            for j = 1, self.DISPLAY_WIDTH do
                love.graphics.setColor(self.pixels[i][j])
                love.graphics.points(j - 0.5, i - 0.5)
            end
        end
    end)
end

function Nes:get_display()
    return self.display
end

return Nes 
