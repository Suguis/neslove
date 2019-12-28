local util = {}

function util.printf(fstring, ...)
    print(string.format(fstring, ...))
end

function util.rgb(r, g, b)
    return {r/255, g/255, b/255}
end

return util
