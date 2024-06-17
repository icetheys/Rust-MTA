GetPositionFromElementOffset = function(element, xx, yy, zz)
    local m = getElementMatrix(element)
    local x = xx * m[1][1] + yy * m[2][1] + zz * m[3][1] + m[4][1]
    local y = xx * m[1][2] + yy * m[2][2] + zz * m[3][2] + m[4][2]
    local z = xx * m[1][3] + yy * m[2][3] + zz * m[3][3] + m[4][3]
    return x, y, z
end

