function getPositionFromElementOffset(element, offX, offY, offZ)
    local m = getElementMatrix(element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

function dxDrawBorderedText(text, x, y, w, h, color, ...)
    local uncolored = text:gsub('#%x%x%x%x%x%x', '')
    for ox = -1, 1 do
        for oY = -1, 1 do
            dxDrawText(uncolored, x + ox, y + oY, w + ox, h + oY, tocolor(0, 0, 0, 225), ...)
        end
    end
    dxDrawText(text, x, y, w, h, color, ...)
end
