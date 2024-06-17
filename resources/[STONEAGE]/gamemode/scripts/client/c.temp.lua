-- //------------------- RESIZE RESOLUTION -------------------\\--
-- bindKey('m', 'both', function(key, state)
--     if state == 'down' then
--         sW, sH = 800, 600
--         addEventHandler('onClientRender', root, drawBorders)
--     else
--         sW, sH = guiGetScreenSize()
--         removeEventHandler('onClientRender', root, drawBorders)
--     end
--     scaleValue = math.max(math.floor(sH / 1080), 0.75)
--     createFonts()

--     if inv.drawing then
--         toggleInv(false)
--         toggleInv(true)
--     end
-- end)

function drawBorders()
    dxDrawLine(0, sH, sW, sH)
    local str = ('%ipx'):format(sW)
    local textW, textH = dxGetTextSize(str, 0, 1, 1, font('franklin:big'))

    if (type(textW) == 'table') then
        textW, textH = unpack(textW)
    end

    dxDrawText(str, 0, sH, sW, sH + textH, tocolor(255, 255, 255, 200), 1, font('franklin:big'), 'center', 'center')

    dxDrawLine(sW, 0, sW, sH)
    local str = ('%ipx'):format(sH)
    
    local textW = dxGetTextSize(str, 0, 1.2, 1, font('franklin:big'))
    
    if (type(textW) == 'table') then
        textW = textW[1]
    end

    dxDrawText(str, sW + pixels(10), 0, sW + textW, sH, tocolor(255, 255, 255, 200), 1, font('franklin:big'), 'left', 'center')
end
-- //------------------- RESIZE RESOLUTION -------------------\\--

addEventHandler('onClientResourceStart', resourceRoot, function() --
    -- inv.order.inv = getElementData(localPlayer, 'invOrder') or {}
    -- setTimer(function() inv.setLootSource(getElementsByType('object', resourceRoot, true)[1]) end, 500, 1)
end)

-- //------------------- TEMP COMMANDS/BINDS -------------------\\--
addCommandHandler('cam', function()
    local arr = {getCameraMatrix()}
    table.remove(arr)
    table.remove(arr)
    local str = table.concat(arr, ', ')
    outputChatBox(('CAM POS: %s'):format(str))
    setClipboard(str)
end)

addCommandHandler('pos', function()
    local arr = {getElementPosition(localPlayer)}
    local str = table.concat(arr, ', ')
    outputChatBox(('POS: %s'):format(str))
    setClipboard(str)
end)
-- //------------------- TEMP COMMANDS/BINDS -------------------\\--

-- setTimer(function()
--     setElementData(localPlayer, 'Wood', math.random(4))
-- end, 200, 0)

-- addEventHandler('onClientRender', root, function()
--     local x, y, z = getElementPosition(localPlayer)

--     dxDrawText(inspect {
--         zone = getZoneName(x, y, z),
--         nearToTunnel = nearToTunnel(x, y, z),
--         flying = isFlying(x, y, z),
--         naAgua = isAboveWater(x, y, z),
--     }, 1200, 500)
-- end)
