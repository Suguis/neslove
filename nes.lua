local nes = {}

function nes.load_cart(cart)
    cart = assert(io.open(cart, "rb"))
    if cart:read(3) == "NES" and cart:read(1):byte(1) == 0x1A then
        print "Valid format!"
    else
        print "Error, the file is not a valid NES rom"
    end
end

return nes
