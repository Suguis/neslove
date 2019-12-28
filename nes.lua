Nes = {
    SCREEN_WIDTH = 256,
    SCREEN_HEIGHT = 240
}
Nes.__index = Nes

function Nes:new()
    return setmetatable({}, self)
end

function Nes:insert_cartridge(cartridge)
    self.cartridge = cartridge
end

return Nes
