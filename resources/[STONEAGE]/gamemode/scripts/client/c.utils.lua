-- //------------------- UI THINGS -------------------\\--
sW, sH = 800, 600
sW, sH = guiGetScreenSize()
local originalW, originalH = sW, sH

scaleValue = math.max(math.floor(sH / 1080), 0.75)
function pixels(q)
    return math.floor(scaleValue * q)
end

local fonts = {}
local cfonts = {}
function createFonts()
    for _, font in pairs(fonts) do
        destroyElement(font)
    end
    fonts = {
        ['futura'] = dxCreateFont('files/fonts/futura.ttf', pixels(14)),
        ['futura:little'] = dxCreateFont('files/fonts/futura.ttf', pixels(11)),
        ['futura:2'] = dxCreateFont('files/fonts/futura.ttf', pixels(17)),
        ['rust'] = dxCreateFont('files/fonts/rust.ttf', pixels(10)),
        ['rust:big'] = dxCreateFont('files/fonts/rust.ttf', pixels(80)),
        ['franklin:little'] = dxCreateFont('files/fonts/franklin.ttf', pixels(10)),
        ['franklin'] = dxCreateFont('files/fonts/franklin.ttf', pixels(14)),
        ['franklin:medium'] = dxCreateFont('files/fonts/franklin.ttf', pixels(24)),
        ['franklin:big'] = dxCreateFont('files/fonts/franklin.ttf', pixels(40)),
    }

    for _, font in pairs(cfonts) do
        destroyElement(font)
    end
    
    cfonts = {
        ['futura'] = guiCreateFont('files/fonts/futura.ttf', pixels(14)),
        ['franklin'] = guiCreateFont('files/fonts/franklin.ttf', pixels(12)),
        ['franklin:little'] = guiCreateFont('files/fonts/franklin.ttf', pixels(10)),
        ['franklin:medium'] = guiCreateFont('files/fonts/franklin.ttf', pixels(22)),
        ['franklin:medium2'] = guiCreateFont('files/fonts/franklin.ttf', pixels(32)),
        ['franklin:big'] = guiCreateFont('files/fonts/franklin.ttf', pixels(40)),
    }
end
addEventHandler('onClientResourceStart', resourceRoot, createFonts)
function font(q)
    return fonts[q] or 'default-bold'
end
function cfont(q, a)
    return cfonts[q] or 'default-bold'
end

local predefinedColors = {
    ['baseBuilding:bg'] = {30, 30, 30, 200},
    ['menu:color1'] = tocolor(200, 35, 35, 250),
    ['menu:color2'] = tocolor(210, 190, 175, 250),
    ['death:color1'] = tocolor(30, 30, 30, 250),
    ['death:color2'] = tocolor(105, 126, 60, 200),
    ['death:color3'] = tocolor(200, 35, 35, 200),
    ['death:color4'] = tocolor(34, 114, 171, 200),
    ['inv:bg'] = {30, 30, 30, 250},
    ['inv:boxColor'] = {255, 255, 255, 20},
    ['inv:boxColor:hover'] = {255, 255, 255, 25},
    ['inv:boxColor:selected'] = {106, 127, 62, 200},
    ['inv:boxColor:selected2'] = {126, 147, 82, 220},
    ['inv:loadingProgress'] = tocolor(255, 255, 255, 15),
    ['inv:boxBorder'] = tocolor(255, 255, 255, 20),
}

function predefinedColor(q)
    return predefinedColors[q]
end
function color(q)
    return predefinedColors[q] or {255, 255, 255, 255}
end

local textures = {}
local blacklist = {}

local defaultTexture = dxCreateTexture('files/images/logo.png', 'argb', true, 'clamp')

function getTexture(str)
    str = str and ('files/images/%s'):format(str)
    if str then
        if not blacklist[str] then
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
    end
    return defaultTexture
end

function dxDrawImage3D(x, y, z, w, h, material, color)
    local startX = x
    local startY = y
    local startZ = z + h

    local endX = x
    local endY = y
    local endZ = z

    dxDrawMaterialLine3D(startX, startY, startZ, endX, endY, endZ, material, w, color or 0xFFFFFFFF)
    return
end

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded,
                            subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY, bgColor)
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
    dxDrawText(nonColor, left - outline, top - outline, right - outline, bottom - outline, bgColor, scale, font, alignX, alignY, clip, wordBreak,
               postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left + outline, top - outline, right + outline, bottom - outline, bgColor, scale, font, alignX, alignY, clip, wordBreak,
               postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left - outline, top + outline, right - outline, bottom + outline, bgColor, scale, font, alignX, alignY, clip, wordBreak,
               postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left + outline, top + outline, right + outline, bottom + outline, bgColor, scale, font, alignX, alignY, clip, wordBreak,
               postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left - outline, top, right - outline, bottom, bgColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded,
               subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left + outline, top, right + outline, bottom, bgColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded,
               subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left, top - outline, right, bottom - outline, bgColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded,
               subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(nonColor, left, top + outline, right, bottom + outline, bgColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded,
               subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning,
               fRotation, fRotationCenterX, fRotationCenterY)
end

function dxDrawRectangleBorders(x, y, w, h, color, width, postGUI)
    width = width or 1
    dxDrawLine(x, y, x + w, y, color, width, postGUI)
    dxDrawLine(x, y + h, x + w, y + h, color, width, postGUI)
    dxDrawLine(x, y, x, y + h, color, width, postGUI)
    dxDrawLine(x + w, y, x + w, y + h, color, width, postGUI)
end

local _debugLine = {}
--[[debugLine(pos:number, align: (horizontal / 1, vertical / 2))]]
function debugLine(pos, align)
    table.insert(_debugLine, {
        pos = pos,
        align = align,
    })
    if #_debugLine == 1 then
        addEventHandler('onClientRender', root, debugLineHandler)
    end
end

function debugLineHandler()
    for k, v in ipairs(_debugLine) do
        if v.align == 'horizontal' or v.align == 1 then
            dxDrawLine(0, v.pos, sW, v.pos, tocolor(math.random(255), math.random(255), math.random(255)), 1, true)
        elseif v.align == 'vertical' or v.align == 2 then
            dxDrawLine(v.pos, 0, v.pos, sH, tocolor(math.random(255), math.random(255), math.random(255)), 1, true)
        end
    end
end

local cos = math.cos
local sin = math.sin
local rad = math.rad
local floor = math.floor

function dxDrawRing(posX, posY, radius, width, startAngle, amount, color, postGUI, absoluteAmount, anglesPerLine)
    if (type(posX) ~= 'number') or (type(posY) ~= 'number') or (type(startAngle) ~= 'number') or (type(amount) ~= 'number') then
        return false
    end

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

do
    local drawLine
    local attachedToElement

    function showGridlines(element)
        if element and isElement(element) then
            if not attachedToElement then
                attachedToElement = element
                addEventHandler('onClientRender', root, drawXYZLines)
            end
        else
            if attachedToElement then
                removeEventHandler('onClientRender', root, drawXYZLines)
                attachedToElement = nil
            end
        end
    end

    function drawXYZLines()
        if not isElement(attachedToElement) then
            showGridlines(nil)
            return
        end
        local camX, camY, camZ = getCameraMatrix()
        if getElementDimension(attachedToElement) ~= getElementDimension(localPlayer) then
            return
        end
        local x, y, z = getElementPosition(attachedToElement)
        local rx, ry, rz = getElementRotation(attachedToElement)
        local xx, xy, xz = getPositionFromElementAtOffset(attachedToElement, 1, 0, 0)
        local yx, yy, yz = getPositionFromElementAtOffset(attachedToElement, 0, 1, 0)
        local zx, zy, zz = getPositionFromElementAtOffset(attachedToElement, 0, 0, 1)
        local thickness = (100 / getDistanceBetweenPoints3D(camX, camY, camZ, x, y, z)) * 0.3
        drawLine({x, y, z}, {xx, xy, xz}, tocolor(200, 0, 0, 255), thickness, rx, 'x', 1)
        drawLine({x, y, z}, {yx, yy, yz}, tocolor(0, 200, 0, 255), thickness, ry, 'y', 2)
        drawLine({x, y, z}, {zx, zy, zz}, tocolor(0, 0, 200, 255), thickness, rz, 'z', 3)
    end

    function getPositionFromElementAtOffset(element, x, y, z)
        if not x or not y or not z then
            return false
        end
        local ox, oy, oz = getElementPosition(element)
        local matrix = getElementMatrix(element)
        if not matrix then
            return ox + x, oy + y, oz + z
        end
        local offX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
        local offY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
        local offZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
        return offX, offY, offZ
    end

    function drawLine(vecOrigin, vecTarget, color, thickness, rot, way, id)
        if (not vecTarget[1]) then
            return false
        end
        local startX, startY = getScreenFromWorldPosition(vecOrigin[1], vecOrigin[2], vecOrigin[3], 10)
        local endX, endY = getScreenFromWorldPosition(vecTarget[1], vecTarget[2], vecTarget[3], 10)
        if not startX or not startY or not endX or not endY then
            return false
        end
        local str = ('%s: %s°\n'):format(way, math.floor(rot))
        dxDrawLine(startX, startY, endX, endY, color, thickness, false)
        dxDrawBorderedText(str, endX + pixels(thickness * 2), endY, 0, 0, color, 1, font('franklin'))
    end
end
-- //------------------- UI THINGS -------------------\\--

-- //------------------- USERFUL FUNCTIONS -------------------\\--
function _getCursorPosition(absolute)
    if not isCursorShowing() then
        return false
    end
    local x, y, worldx, worldy, worldz = getCursorPosition()
    if absolute then
        x = x * originalW
        y = y * originalH
    end
    return x, y, worldx, worldy, worldz
end


function isHover(x, y, w, h)
    if not isCursorShowing() then
        return false
    end
    local mx, my = _getCursorPosition(true)
    return (mx >= x and mx <= x + w) and (my >= y and my <= y + h)
end

function isNetworkLagDetected()
    if getNetworkStats()['packetlossLastSecond'] > 5 then
        exports['stoneage_notifications']:CreateNotification(translate('networkstatus'), 'error')
        return true
    end
    return false
end

-- //------------------- USERFUL FUNCTIONS -------------------\\--
local sm = { --
    moving,
    startTick,
    animSpeed,
    easying,
    initialPos = {},
    endPos = {},
}

function stopMovingCamera() --
    if sm.moving then
        sm.moving = nil
    end
end

local function camRender()
    if sm.moving then
        local initialCamX, initialCamY, initialCamZ, initialLookX, initialLookY, initialLookZ = unpack(sm.initialPos)
        local endCamX, endCamY, endCamZ, endLookX, endLookY, endLookZ = unpack(sm.endPos)

        local progress = (getTickCount() - sm.startTick) / sm.animSpeed

        if progress <= 1 then
            local camX, camY, camZ = interpolateBetween(initialCamX, initialCamY, initialCamZ, endCamX, endCamY, endCamZ, progress, sm.easying)
            local lookX, lookY, lookZ = interpolateBetween(initialLookX, initialLookY, initialLookZ, endLookX, endLookY, endLookZ, progress,
                                                           sm.easying)
            setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
        else
            stopMovingCamera()
        end

    else
        removeEventHandler('onClientRender', root, camRender)
        fadeCamera(true)
    end
end

local fristMovement = true
function moveCamera(camX, camY, camZ, lookX, lookY, lookZ, speed, easying)
    if fristMovement then
        fristMovement = false
        return setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
    end
    speed = speed or 1000

    if sm.moving then
        removeEventHandler('onClientRender', root, camRender)
        fadeCamera(true)
    end

    fadeCamera(true)
    sm.moving = true

    sm.startTick = getTickCount()
    sm.animSpeed = speed
    sm.easying = easying or 'OutQuad'

    local cx, cy, cz, lx, ly, lz = getCameraMatrix()
    sm.initialPos = {cx, cy, cz, lx, ly, lz}
    sm.endPos = {camX, camY, camZ, lookX, lookY, lookZ}

    addEventHandler('onClientRender', root, camRender)
    return true
end

function translate(what, subtable, ...)
    return TRANSLATION:translate(what, subtable, ...)
end

function getItemDescription(itemName)
    local str = translate(itemName, 'desc')
    local type = getItemType(itemName)
    if type == 'weapon-primary' or type == 'weapon-secondary' then --
        local weaponConfig = getPlayerDataSetting(itemName, 'weaponSettings')
        local damage = weaponConfig.damage
        local range = weaponConfig.distance
        local ammo = getPlayerDataSetting(itemName, 'ammo').name

        str = ('%s\n%s'):format(str, translate('descrição-armas', nil, ammo, damage, range))
    end
    return str
end

local pi = math.pi
local mathatan2 = math.atan2
local mathdeg = math.deg
local mathrad = math.rad

function getCameraRotation()
    local px, py, pz, lx, ly, lz = getCameraMatrix()
    local rotz = (pi * 2) - mathatan2((lx - px), (ly - py)) % (pi * 2)
    local rotx = mathatan2(lz - pz, getDistanceBetweenPoints2D(lx, ly, px, py))
    rotx = mathdeg(rotx)
    rotz = -mathdeg(rotz)
    return rotx, 180, rotz
end

local currentFPS = 0

function updateFPS(ms)
    currentFPS = ('%.2f'):format((1 / ms) * 1000)
end
addEventHandler('onClientPreRender', root, updateFPS)

function getPlayerFPS()
    return currentFPS
end

function directionOpenDoor(ob)
    if not isElement(ob) then
        return
    end

    local x, y = getElementPosition(localPlayer)
    local x1, y1 = getElementPosition(ob)

    local relativePos = {
        x = x - x1,
        y = y - y1,
    }

    local vectors = {
        [1] = -ob.matrix.forward,
        [3] = ob.matrix.forward,
    }

    local minDistance, minIndex = 9999, 0
    for i, point in pairs(vectors) do
        local dist = getDistanceBetweenPoints2D(point.x, point.y, relativePos.x, relativePos.y)
        if dist < minDistance then
            minDistance = dist
            minIndex = i
        end
    end
    return minIndex == 1
end
