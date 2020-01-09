local util = {}

function util.printf(fstring, ...)
    print(string.format(fstring, ...))
end

function util.rgb(r, g, b)
    return {r/255, g/255, b/255}
end

-- Page number is indicated by the most significant byte of the address
function util.different_page(addr1, addr2)
    return bit.rshift(addr1, 8) ~= bit.rshift(addr2, 8)
end

return util
