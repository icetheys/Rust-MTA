sW, sH = guiGetScreenSize()

scaleValue = math.max(math.floor(sH / 1080), 0.75)

pixels = function(...)
    local values = {}
    for k, v in ipairs(arg) do
        values[k] = scaleValue * v
    end
    return unpack(values)
end

local textures = {}
local blacklist = {}

local defaultTexture = dxCreateTexture('logo.png', 'argb', true, 'clamp')

function getTexture(str)
    if str and not blacklist[str] then
        if textures[str] then
            return textures[str]
        else
            local file = str and fileExists(str)
            if file then
                local tex = dxCreateTexture(str, 'argb', true, 'clamp')
                if tex then
                    textures[str] = tex
                    return textures[str]
                else
                    blacklist[str] = true
                end
            else
                blacklist[str] = true
            end
        end
    end
    return defaultTexture
end

local cos = math.cos
local sin = math.sin
local rad = math.rad
local floor = math.floor

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

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak,
    postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY, bgColor)
    local outline = (scale or 1) * (outline or 1)
    text = tostring(text)
    fRotation = fRotation or 0
    fRotationCenterX = fRotationCenterX or 0
    fRotationCenterY = fRotationCenterY or 0
    if not color then
        color = tocolor(255, 255, 255, 255)
    end
    local alpha = bitExtract(color, 24, 8) or 255
    bgColor = bgColor or tocolor(0, 0, 0, alpha)
    font = font or 'default-bold'
    local nonColor = text:gsub('#%x%x%x%x%x%x', '')
    local right = right or left
    local bottom = bottom or top
    dxDrawText(nonColor, left - outline, top - outline, right - outline, bottom - outline, bgColor, scale, font, alignX,
        alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left + outline, top - outline, right + outline, bottom - outline, bgColor, scale, font, alignX,
        alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left - outline, top + outline, right - outline, bottom + outline, bgColor, scale, font, alignX,
        alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left + outline, top + outline, right + outline, bottom + outline, bgColor, scale, font, alignX,
        alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left - outline, top, right - outline, bottom, bgColor, scale, font, alignX, alignY, clip,
        wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left + outline, top, right + outline, bottom, bgColor, scale, font, alignX, alignY, clip,
        wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left, top - outline, right, bottom - outline, bgColor, scale, font, alignX, alignY, clip,
        wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left, top + outline, right, bottom + outline, bgColor, scale, font, alignX, alignY, clip,
        wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded,
        subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end
