local util = {}

function util.printf(fstring, ...)
    print(string.format(fstring, ...))
end

return util
