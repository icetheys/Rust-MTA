local sx, sy = guiGetScreenSize()
local top = 5

local cords = {{0, 'N'}, {15}, {30}, {45, 'NE'}, {60}, {75}, {90, 'E'}, {105}, {120}, {135, 'SE'}, {150}, {165}, {170, 'S'}, {195}, {210},
               {225, 'SW'}, {240}, {255}, {270, 'W'}, {285}, {300}, {315, 'NW'}, {330}, {345}}

function draw()
    if (not getElementData(localPlayer, 'logedin')) then
        return false
    end
    local show = 15
    local center = math.ceil(show / 2) - 1
    local _, _, r = getElementRotation(getCamera())
    r = ( 360 - r )
    local pos = math.floor(r / 15)
    local slotwidth = 40
    local smooth = ((r - (pos * 15)) / 15) * slotwidth
    local left = sx / 2 - ((show + 2) * slotwidth) / 2

    for i = 1, show do
        local id = i + pos - center
        if (id > #cords) then
            id = id - #cords
        end
        if (id <= 0) then
            id = #cords - math.abs(id)
        end
        if (cords[id]) then
            local alpha = (tonumber(cords[id][2]) or 0 > 0) and 175 or 255
            if (i < center) then
                alpha = alpha * (i / center)
            end
            if (i > center) then
                alpha = alpha * ((show - i) / center)
            end

            local str = cords[id][2] or cords[id][1]

            dxDrawRectangle(left + slotwidth * i - smooth + (slotwidth / 2 - 1), top + 20, 2, 10, tocolor(255, 255, 255, alpha))
            dxDrawText(str, left + slotwidth * i - smooth, top + 35, left + slotwidth * (i + 1) - smooth, top + 40, tocolor(255, 255, 255, alpha), 1,
                       'default-bold', 'center', 'center')
        end
    end
    dxDrawText('↓', 0, top, sx, top + sy, tocolor(255, 255, 255, 255), 1, 'default-bold', 'center', 'top', false, false, false, false, false)
end

local drawing = false

toggleCompass = function(state)
    if (state and drawing) or (not state and not drawing) then
        return
    end
    drawing = state
    if state then
        addEventHandler('onClientRender', root, draw)
    else
        removeEventHandler('onClientRender', root, draw)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    if exports['stoneage_settings']:getConfig('Compasso', true) then
        toggleCompass(true)
    end
end)