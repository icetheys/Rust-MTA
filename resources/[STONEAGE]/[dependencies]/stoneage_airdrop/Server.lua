local drop = {
    mainTimer = nil,
}

function spawnDrop(player)
    for i, data in pairs(drop) do
        checkAndDestroy(data)
    end
    
    local x, y, z = getRandomPoint()
    
    if isElement(player) then
        x, y, z = getNearestPosition(getElementPosition(player))
    end
    
    drop['aviao'] = createObject(1683, x - 5000, y, z + 200)
    drop['blip'] = createBlipAttachedTo(drop['aviao'], 5)
    setElementData(drop['blip'], 'BlipName', 'Airdrop')
    
    moveObject(drop['aviao'], 24000 * 5, x - 50, y - 20, z + 200)
    
    outputChatBox(('Um airdrop está a caminho de %s (%s)'):format(getZoneName(x, y, z, false), getZoneName(x, y, z, true)), root, 255, 255, 255, true)
    
    drop['timer.soltar_bolsa'] = setTimer(function()
        moveObject(drop['aviao'], 24000 * 5, x + 5000, y - 20, z + 200)
        drop['timer.destruir_aviao'] = setTimer(function()
            destroyElement(drop['aviao'])
            destroyElement(drop['blip'])
        end, 24000 * 5, 1)
        
        drop['parachute'] = createObject(2903, x - 50, y - 20, z + 210)
        setElementCollisionsEnabled(drop['parachute'], false)
        
        moveObject(drop['parachute'], 150000, x, y, z + 7.5, 0, 0, 360)
        
        drop['timer.criarbag'] = setTimer(function()
            destroyElement(drop['parachute'])
            
            drop['bag'] = createObject(2919, x, y, z)
            setElementFrozen(drop['bag'], true)
            setElementData(drop['bag'], 'obName', 'Airdrop')
            setElementData(drop['bag'], 'maxSlots', 21)
            setDropLoot(drop['bag'])
            
            drop['effect.1'] = createObject(1691, x, y, z + 1, 90)
            drop['effect.2'] = createObject(2060, x, y, z + 0.5)
            drop['effect.3'] = createObject(1691, x, y, z - 1, 90)
            for i = 1, 3 do
                setElementAlpha(drop['effect.' .. i], 0)
                setElementCollisionsEnabled(drop['effect.' .. i], false)
            end
            
            local blip = createBlip(x, y, z, 53)
            setElementData(blip, 'piscar', true)
            
            setTimer(function()
                if isElement(blip) then
                    destroyElement(blip)
                end
            end, 15000, 1)
        
        end, 150000, 1)
    end, 24000 * 5, 1)
    drop.mainTimer = setTimer(spawnDrop, getDropRespawnTime(), 1)
end
addEventHandler('onResourceStart', resourceRoot, spawnDrop)

function getDropRespawnTime()
    return exports['stoneage_settings']:getConfig('Minutos a cada airdrop', 60) * 60000
end

function checkAndDestroy(element)
    if isTimer(element) then
        killTimer(element)
    elseif isElement(element) then
        destroyElement(element)
    end
end