x, y = 3031.9521484375, -751.5166015625
local hillRadar = createRadarArea(x, y, 200, 250, 255, 255, 255, 120)

reator = createObject(7236, 3159.2001953125, -723.400390625, 19, 0, 0, 0)
blip = createBlip(3121.2661132813, -622.0390625, 8.9078121185303, 37, 2, 255, 255, 255, 255, 0, 300)

timeToRadiationComes = 1800000

function moveReator(number)
    x, y, z = getElementPosition(reator)
    rx, ry, rz = getElementRotation(reator)

    if number == 1 then
        moveObject(reator, 2000, x, y, z - 4, rx + 20, ry - 20, 0, 'OutInQuad')
        setTimer(function()
            local x, y, z = 3143.4912109375, -734.896484375, 34.469215393066
            for i = 1, 5 do
                createExplosion(x + math.random(i) * 2, y + math.random(i) * 2, z + math.random(i) * 2, 10)
                triggerClientEvent(root, 'createExplosionEffect', root, timeToRadiationComes * 0.9)
            end
            setTimer(function()
                local x, y, z = 3143.4912109375, -734.896484375, 34.469215393066
                for i = 1, 5 do
                    createExplosion(x + math.random(i) * 2, y + math.random(i) * 2, z + math.random(i) * 2, 10)
                end
                setTimer(function()
                    local x, y, z = 3143.4912109375, -734.896484375, 34.469215393066
                    for i = 1, 5 do
                        createExplosion(x + math.random(i) * 2, y + math.random(i) * 2, z + math.random(i) * 4, 10)
                    end
                end, 500, 1)
            end, 500, 1)
        end, 2000, 1)
    else
        local x, y, z, rx, ry, rz = 3159.2001953125, -723.400390625, 19, 0, 0, 0
        setElementPosition(reator, x, y, z, true)
        setElementRotation(reator, rx, ry, rz)
    end
end

addEvent('onReatorExplode', true)

radiation = false
function changeRadiation()
    radiation = not radiation
    if radiation then
        moveReator(1)
        setRadarAreaColor(hillRadar, 255, 255, 0, 120)
        setRadarAreaFlashing(hillRadar, true)
        triggerEvent('onReatorExplode', root)
        setBlipIcon(blip, 56)
    else
        setBlipIcon(blip, 37)
        setRadarAreaFlashing(hillRadar, false)
        moveReator(2)
        setRadarAreaColor(hillRadar, 255, 255, 255, 120)
    end
    timeToRadiationComes = math.random(1500000, 1800000)
    setTimer(changeRadiation, timeToRadiationComes, 1)
end
addEventHandler('onResourceStart', resourceRoot, changeRadiation)

createBlip(216.16796875, 1886.708984375, 14.470494270325, 56, 2)
createBlip(-1385.123046875, 503.10546875, 18.234375, 56, 2)
createBlip(1146.9453125, -2037.333984375, 69.0078125, 56, 2)
createBlip(2619.9052734375, 2729.611328125, 36.538642883301, 56, 2)
