sW, sH = guiGetScreenSize()

local scaleValue = math.max(math.floor(sH / 1080), 0.75)

pixels = function(q)
    return scaleValue * q
end

local cos = math.cos
local sin = math.sin
local rad = math.rad
local floor = math.floor

GetPointFromDistanceRotation = function(x, y, z, distance, angle)
    x = x + cos(rad(90 - angle)) * distance
    y = y + sin(rad(90 - angle)) * distance
    return x, y, z
end

function dxDrawRing(posX, posY, radius, width, startAngle, amount, color, postGUI, absoluteAmount, anglesPerLine)
    if (type(posX) ~= 'number') or (type(posY) ~= 'number') or (type(startAngle) ~= 'number') or
        (type(amount) ~= 'number') then
        return false
    end

    local stopAngle
    if absoluteAmount then
        stopAngle = amount + startAngle
    else
        stopAngle = (amount * 360) + startAngle
    end

    anglesPerLine = anglesPerLine or 1
    radius = radius or 50
    width = width or 5
    color = color or tocolor(255, 255, 255, 255)

    for i = startAngle, stopAngle, anglesPerLine do
        local rad_i = rad(i)
        local cos_rad_i = cos(rad_i)
        local sin_rad_i = sin(rad_i)

        local startX = floor(cos_rad_i * (radius - width))
        local startY = floor(sin_rad_i * (radius - width))
        local endX = floor(cos_rad_i * (radius + width))
        local endY = floor(sin_rad_i * (radius + width))

        dxDrawLine(startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI or false)
    end
end
