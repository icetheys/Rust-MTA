deg = math.deg
atan2 = math.atan2
cos = math.cos
sin = math.sin
rad = math.rad
floor = math.floor
pi = math.pi

sW, sH = guiGetScreenSize()
centerX, centerY = sW * 0.5, sH * 0.45

function findRotation(x1, y1, x2, y2)
    local t = -deg(atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

function rotFix(rot)
    if rot > 360 then
        return rot - 360
    elseif rot < 0 then
        return 360 - rot
    else
        return rot
    end
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

function findSection(cx, cy, quantity)
    local lambda = 360 / quantity
    local offset = 0
    local rotation = findRotation(cx, cy, sW / 2, sH / 2)
    for i = 0, quantity do
        local rotA = rotFix((i * lambda) - (lambda / 2) + offset)
        local rotB = rotFix(rotA + lambda)
        if (rotation >= rotA) and (rotation <= rotB) then
            return i
        end
    end
    return quantity
end

function getPositionFromElementOffset(element, offX, offY, offZ)
    local m = getElementMatrix(element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

scaleValue = math.max(math.floor(sH / 1080), 0.75)

pixels = function(...)
    local values = {}
    for k, v in ipairs(arg) do
        values[k] = scaleValue * v
    end
    return unpack(values)
end

local textures = {}

function getTexture(str)
    if str then
        if textures[str] then
            return textures[str]
        else
            local file = str and fileExists(str)
            if file then
                local tex = dxCreateTexture(str, 'dxt3', true, 'clamp')
                if tex then
                    textures[str] = tex
                    return textures[str]
                end
            end
        end
        textures[str] = 'assets/logo.png'
    end
    return 'assets/logo.png'
end

function dxDrawRing(posX, posY, radius, width, startAngle, amount, color, anglesPerLine)
    local stopAngle = (amount * 360) + startAngle

    anglesPerLine = anglesPerLine or 1
    radius = radius or 50
    width = width or 10

    local offA = radius - width
    local offB = radius + width

    color = color or tocolor(255, 255, 255, 255)

    local runs = 0
    for i = startAngle, stopAngle - 1, anglesPerLine do
        local rad_i = rad(i)

        local cos_rad_i = cos(rad_i)
        local sin_rad_i = sin(rad_i)

        local startX = cos_rad_i * (offA)
        local startY = sin_rad_i * (offA)
        local endX = cos_rad_i * (offB)
        local endY = sin_rad_i * (offB)

        dxDrawLine(floor(startX + posX), floor(startY + posY), floor(endX + posX), floor(endY + posY), color, width)
        runs = runs + anglesPerLine
    end
end

_getCursorPosition = function(absolute)
    if not isCursorShowing() then
        return false
    end
    local x, y = getCursorPosition()
    if absolute then
        x, y = x * sW, y * sH
    end
    return x, y
end

local highlightCache = {
    ob = false,
    r = false,
    g = false,
    b = false,
    a = false
}

highlightObject2 = function(ob, r, g, b, a)
    if (highlightCache.ob ~= ob) or (highlightCache.r ~= r) or (highlightCache.g ~= g) or (highlightCache.b ~= b) or (highlightCache.a ~= a) then
        highlightCache = {
            ob = ob,
            r = r,
            g = g,
            b = b,
            a = a
        }
        exports['stoneage_highlight']:highlightObject(ob, {r, g, b, a})
    end
end
