local sW, sH = guiGetScreenSize()

local drawDetails = {{
    display = 'Engine',
    has = 'engine',
    max = 'maxEngine',
}, {
    display = 'Tire',
    has = 'tires',
    max = 'maxTire',
}, {
    display = 'Battery',
    has = 'battery',
    max = 'maxBattery',
}}

local colorEmpty = tocolor(255, 0, 0)
local colorFull = tocolor(255, 255, 255)
local colorFuel = tocolor(92, 141, 71)

local baseX = 40
local baseY = sH / 2

local baseWidth, baseHeight = 15, 115
local betweenBars = 1
local smallBarsWidth = 1
local barBaseX = baseX - baseWidth - 5 - smallBarsWidth - betweenBars
local topBotBarsWidthAddit = 2
local topBotBarsWidth, topBotBarsHeight = baseWidth + smallBarsWidth * 2 + betweenBars * 2 + topBotBarsWidthAddit * 2, 2
local additBarsQuant = 5
local additBarsPosition = (baseHeight + topBotBarsWidthAddit) / additBarsQuant
local oneTextHeight = baseHeight / (#drawDetails + 2.5)
local textPos = barBaseX + betweenBars + baseWidth + smallBarsWidth + 5

Render = function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        local vehName = getVehicleName(veh)
        local vehicleSettings = exports['stoneage_vehicles']:getVehicleSettingInfo(getElementModel(veh))

        local Fuel = getElementData(veh, 'fuel') or 0

        dxDrawImage(barBaseX + 2, baseY - 5 - sW, baseWidth, baseWidth, 'assets/fuel.png', 0, 0, 0, colorFuel)

        local state = getVehicleEngineState(veh)
        dxDrawImage(barBaseX - 3, baseY + 5 + baseHeight, baseWidth + 5, baseWidth + 5, state and 'assets/ligado.png' or 'assets/desligado.png', 0, 0,
                    0, state and colorFull or colorEmpty)

        dxDrawRectangle(barBaseX, baseY, baseWidth, baseHeight, tocolor(0, 0, 0, 255), true)
        dxDrawRectangle(barBaseX - smallBarsWidth - betweenBars, baseY, smallBarsWidth, baseHeight, tocolor(255, 255, 255, 255), true)

        dxDrawRectangle(barBaseX + betweenBars + baseWidth, baseY, smallBarsWidth, baseHeight, tocolor(255, 255, 255, 255), true)
        dxDrawRectangle(barBaseX - smallBarsWidth - betweenBars - topBotBarsWidthAddit, baseY - topBotBarsHeight, topBotBarsWidth, topBotBarsHeight,
                        tocolor(255, 255, 255, 255), true)
        dxDrawRectangle(barBaseX - smallBarsWidth - betweenBars - topBotBarsWidthAddit, baseY + baseHeight, topBotBarsWidth, topBotBarsHeight,
                        tocolor(255, 255, 255, 255), true)

        for i = 1, additBarsQuant do
            dxDrawRectangle(barBaseX - smallBarsWidth - betweenBars - topBotBarsWidthAddit, baseY - topBotBarsHeight + additBarsPosition * i,
                            topBotBarsWidthAddit, topBotBarsWidthAddit, tocolor(255, 255, 255, 255), true)
            dxDrawRectangle(barBaseX + betweenBars + baseWidth + smallBarsWidth, baseY - topBotBarsHeight + additBarsPosition * i,
                            topBotBarsWidthAddit, topBotBarsWidthAddit, tocolor(255, 255, 255, 255), true)
        end

        for i, v in ipairs(drawDetails) do
            local has = (getElementData(veh, v.has) or 0)
            local needed = vehicleSettings[v.max]
            if has and needed then
                local str = ('%s (%i/%i)'):format(exports['stoneage_translations']:translate(v.display, 'name'), has, needed)
                dxDrawText(str, textPos, baseY + (i - 1.5) * oneTextHeight, baseX + sW, baseY + i * oneTextHeight,
                           has >= needed and colorFull or colorEmpty, 1, 'default-bold', 'left', 'center')
            end
        end

        dxDrawText(('%i%%'):format(getElementHealth(veh) * 0.1), textPos, baseY + #drawDetails * oneTextHeight, baseX + sW,
                   baseY + (#drawDetails + 0.5) * oneTextHeight, colorFull, 1, 'default-bold', 'left', 'center')

        dxDrawText(('%i km/h'):format(getElementSpeed(veh, 'km/h')), textPos, baseY + (#drawDetails + 1) * oneTextHeight, baseX + sW,
                   baseY + (#drawDetails + 1.5) * oneTextHeight, colorFull, 1, 'default-bold', 'left', 'center')

        dxDrawText(vehName, textPos, baseY + (#drawDetails + 2) * oneTextHeight, baseX + sW, baseY + (#drawDetails + 2.5) * oneTextHeight, colorFull,
                   1, 'default-bold', 'left', 'center')

        if Fuel > 0 then
            local _, _, size = interpolateBetween(0, 0, 0, 0, 0, baseHeight, Fuel / vehicleSettings.maxFuel, 'Linear')
            if size > 0 then
                dxDrawRectangle(barBaseX, baseY + baseHeight - size, baseWidth, size, colorFuel, true)
            end
        end
    end
end
addEventHandler('onClientRender', root, Render)

function getElementSpeed(theElement, unit)
    if (isElement(theElement) and (getElementType(theElement) == 'vehicle')) then
        unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
        local mult = (unit == 0 or unit == 'm/s') and 50 or ((unit == 1 or unit == 'km/h') and 180 or 111.84681456)
        return (Vector3(getElementVelocity(theElement)) * mult).length
    end
    return false
end
