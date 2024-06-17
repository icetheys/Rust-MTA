sW, sH = guiGetScreenSize()

scaleValue = math.max(math.floor(sH / 1080), 0.75)

pixels = function(...)
    local values = {}
    for k, v in ipairs(arg) do
        values[k] = scaleValue * v
    end
    return unpack(values)
end
