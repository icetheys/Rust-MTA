Notifications = {
    List = {},
}

sW, sH = guiGetScreenSize()

Font = dxCreateFont('assets/regular.ttf', sH * 0.014)

colorTypes = {
    ['info'] = {106, 125, 65},
    ['error'] = {200, 0, 0},
    ['event'] = {150, 150, 30},
}

CreateNotification = function(string, type, showingTime)
    type = type or 'info'
    showingTime = showingTime or 10000

    table.insert(Notifications.List, {
        String = string,
        Type = (colorTypes[type] and type) or 'info',
        InitTick = getTickCount(),
        ShowingTime = showingTime,
        TimeToRemove = getTickCount() + showingTime,
    })

    if (#Notifications.List == 1) then
        addEventHandler('onClientRender', root, Render)
    end
end
addEvent('CreateNotification', true)
addEventHandler('CreateNotification', localPlayer, CreateNotification)

Render = function()
    local stackY = 0

    for k, v in ipairs(Notifications.List) do
        if (getTickCount() <= v.TimeToRemove) then
            local sizeW, sizeH = dxGetTextSize(v.String, sH * 0.315, 1, 1.5, Font, true)

            if (type(sizeW) == 'table') then
                sizeW, sizeH = unpack(sizeW) 
            end

            local r, g, b = unpack(colorTypes[v.Type])

            local offset = 10
            local w, h = sizeW, math.max(sH * 0.03, sizeH)

            local y = 23 + stackY
            local x, alpha = interpolateBetween(sW, 0, 0, sW - w - offset - 3, 200, 0, (getTickCount() - v.InitTick) / 750, 'OutBounce')

            local width = interpolateBetween(0, 0, 0, w + offset * 2, 0, 0, (getTickCount() - v.InitTick) / v.ShowingTime, 'Linear')
            dxDrawRectangle(x - offset, y, width, h, tocolor(r, g, b, math.min(alpha, 250)), true)
            dxDrawRectangle(x - offset, y, w + offset * 2, h, tocolor(r, g, b, alpha), true)
            dxDrawText(v.String, x, y, x + w, y + h, tocolor(255, 255, 200, math.min(alpha, 250)), 1, Font, 'center', 'center', true, true, true)

            stackY = stackY + h + 3
        else
            table.remove(Notifications.List, k)
            if (#Notifications.List == 0) then
                removeEventHandler('onClientRender', root, Render)
            end
        end
    end
end
--[[
 local possible = {'info', 'error', 'event'}
 addEventHandler('onClientResourceStart', resourceRoot, function()
     for i = 1, 20 do
        setTimer(function()
			local possible = {'info', 'erro', 'event'}
		    CreateNotification(RandomVariable(50), possible[math.random(#possible)])
        end, i * 500, 1)
     end
 end)

 function RandomVariable(length)
     local res = ''
     for i = 1, length do
         res = res .. string.char(math.random(97, 122))
     end
     return res
end
]]