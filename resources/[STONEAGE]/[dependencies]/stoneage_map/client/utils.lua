sW, sH = guiGetScreenSize()

deg = math.deg
cos = math.cos
rad = math.rad
sin = math.sin
min = math.min
atan2 = math.atan2

ReMap = function(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
end

FindRotation = function(x1, y1, x2, y2)
    local r = -deg(atan2(x2 - x1, y2 - y1))
    return (r < 0 and r + 360) or r
end

GetPointFromDistanceRotation = function(x, y, distance, angle)
    x = x + cos(rad(90 - angle)) * distance
    y = y + sin(rad(90 - angle)) * distance
    return x, y
end

local textures = {}
GetTexture = function(str)
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
        textures[str] = 'assets/map.png'
    end
    return 'assets/map.png'
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
