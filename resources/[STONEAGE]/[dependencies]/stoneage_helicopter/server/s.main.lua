Heli = {}

local Init = function()
    setTimer(SpawnHeli, 500, 1)
end
addEventHandler('onResourceStart', resourceRoot, Init)

local speedMult = 35
local detectionSize = 350

SpawnHeli = function()
    DestroyPreviousHeli()
    
    Heli.Route = {
        ID = math.random(#SpawnsPositions),
        Step = 1
    }

    Heli.InAlert = false
    
    local initX, initY, initZ = unpack(SpawnsPositions[Heli.Route.ID][Heli.Route.Step])
    local targetX, targetY, targetZ = unpack(SpawnsPositions[Heli.Route.ID][Heli.Route.Step + 1])
    
    local HeliSpeed = getDistanceBetweenPoints3D(initX, initY, initZ, targetX, targetY, targetZ) * speedMult
    
    Heli.Dummy = createObject(1343, initX, initY, initZ)
    setElementFrozen(Heli.Dummy, true)
    setElementAlpha(Heli.Dummy, 0)
    
    Heli.Element = createVehicle(425, initX, initY, initZ)
    setVehicleEngineState(Heli.Element, true)
    setVehicleDamageProof(Heli.Element, true)
    setElementFrozen(Heli.Element, true)
    setElementHealth(Heli.Element, 300)
    setElementData(Heli.Element, 'HeliDrop', true)
    setElementData(Heli.Element, 'InAlert', false)
    setElementData(Heli.Element, 'obName', 'HeliCrash')
    setElementData(Heli.Element, 'maxSlots', 28)
    setElementData(Heli.Element, 'Health', 5000)

    setElementData(Heli.Element, 'MaxHealth', getElementData(Heli.Element, 'Health'))
    
    Heli.Colshape = createColSphere(initX, initY, initZ, detectionSize)
    attachElements(Heli.Colshape, Heli.Dummy, 0, 0, -detectionSize)
    
    Heli.State = 'initial'
    
    GenerateHeliLoot()
    
    Heli.Blip = createBlipAttachedTo(Heli.Dummy, 6)
    setElementData(Heli.Blip, 'BlipName', 'Hunter')
    setElementParent(Heli.Blip, Heli.Element)
    
    attachElements(Heli.Element, Heli.Dummy, 0, 0, 0, 350, 0, FindRotation(initX, initY, targetX, targetY))
    
    moveObject(Heli.Dummy, HeliSpeed, targetX, targetY, targetZ)
    
    Heli.FinishTimer = setTimer(OnHeliFinishRoute, HeliSpeed, 1)
    
    Heli.TargetTimer = setTimer(CheckHeliTarget, 3000, 0)

    triggerClientEvent(root, 'ReceiveHeliInfo', root, Heli.Element, 'initial')
end

OnHeliFinishRoute = function()
    if Heli.InAlert and (Heli.Route.Step > 1) then
        Heli.Route.Step = Heli.Route.Step - 1
        Heli.InAlert = false
        setElementData(Heli.Element, 'InAlert', false)
    else
        Heli.Route.Step = Heli.Route.Step + 1
    end

    if (not SpawnsPositions[Heli.Route.ID][Heli.Route.Step]) then
        DestroyPreviousHeli()
        local time = exports['stoneage_settings']:getConfig('Minutos a cada heli atirador', 60) * 60000
        Heli.TimerRespawn = setTimer(SpawnHeli, time, 1)
        return 
    end
    
    local initX, initY, initZ = getElementPosition(Heli.Element)
    local targetX, targetY, targetZ = unpack(SpawnsPositions[Heli.Route.ID][Heli.Route.Step])
    
    local HeliSpeed = getDistanceBetweenPoints3D(initX, initY, initZ, targetX, targetY, targetZ) * speedMult
    
    detachElements(Heli.Element)
    attachElements(Heli.Element, Heli.Dummy, 0, 0, 0, 350, 0, FindRotation(initX, initY, targetX, targetY))
    
    moveObject(Heli.Dummy, HeliSpeed, targetX, targetY, targetZ)
    
    Heli.FinishTimer = setTimer(OnHeliFinishRoute, HeliSpeed, 1)
end

OnVehicleExplode = function(hitX, hitY, hitZ)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if (not isElement(Heli.Element)) then
        return false
    end
    
    if (not isVehicleBlown(Heli.Element)) then
        
        local _, _, _, rx, ry, rz = getElementAttachedOffsets(Heli.Element)
        
        if isElement(Heli.Dummy) then
            destroyElement(Heli.Dummy)
        end
        
        createExplosion(hitX, hitY, hitZ, 0)
        
        setVehicleDamageProof(Heli.Element, false)
        
        blowVehicle(Heli.Element)
        
        setElementRotation(Heli.Element, rx, ry, rz)
        
        setElementFrozen(Heli.Element, false)
        
        if isTimer(Heli.FinishTimer) then
            killTimer(Heli.FinishTimer)
        end
        
        setTimer(function(hitX, hitY, hitZ)
            if isElement(Heli.Element) then
                local x, y, z = getElementPosition(Heli.Element)
                createExplosion(x, y, z, 0)
            end
        end, 200, 5, hitX, hitY, hitZ)
        
        Heli.State = 'destroyed'
        
        triggerClientEvent(root, 'ReceiveHeliInfo', root, Heli.Element, Heli.State)
        
        exports['stoneage_logs']:saveLog('heli-destroy', ('%s acabou de destruir um helicoptero atirador em %s (%s)'):format(
            getPlayerName(source), getZoneName(hitX, hitY, hitZ), getZoneName(hitX, hitY, hitZ, true)))
        
        local time = exports['stoneage_settings']:getConfig('Minutos a cada heli atirador', 60) * 60000
        Heli.TimerRespawn = setTimer(SpawnHeli, time, 1)
    end
end
addEvent('DestroyHelicopter', true)
addEventHandler('DestroyHelicopter', root, OnVehicleExplode)

DestroyPreviousHeli = function()
    for k, v in pairs(Heli) do
        if isElement(v) then
            destroyElement(v)
        elseif isTimer(v) then
            killTimer(v)
        end
    end
    triggerClientEvent(root, 'ReceiveHeliInfo', root, Heli.Element, 'destroyed')
    Heli = {}
end

addEvent('CheckHelicopter', true)
addEventHandler('CheckHelicopter', root, function()
    if isElement(Heli.Element) then
        triggerClientEvent(client, 'ReceiveHeliInfo', client, Heli.Element, Heli.State)
    end
end)

GenerateHeliLoot = function()
    if (not isElement(Heli.Element)) then
        return
    end
    for k, v in pairs(PossibleItems) do
        if (math.random(100) <= v[2]) then
            local quantity = exports['gamemode']:getItemMaxSpawnQuantity(v[1]) or 0
            if quantity > 1 then
                quantity = math.random(quantity / 2, quantity)
            end
            setElementData(Heli.Element, v[1], (getElementData(Heli.Element, v[1]) or 0) + quantity)
            local ammo = exports['gamemode']:getPlayerDataSetting(v[1], 'ammo')
            if ammo then
                local quantity = math.random(ammo.magSize / 2, ammo.magSize)
                setElementData(Heli.Element, ammo.name, (getElementData(Heli.Element, ammo.name) or 0) + quantity)
            end
        end
    end
end

GetAvaiableHeliTargets = function()
    if isElement(Heli.Element) and isElement(Heli.Colshape) then
        local players = {}
        local playersInShape = getElementsWithinColShape(Heli.Colshape, 'player')
        for k, v in pairs(playersInShape) do
            if (not getElementData(v, 'staffRole')) then
                table.insert(players, v)    
            end
        end
        return players
    end
end

SetHeliInAlert = function()
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if (not Heli.InAlert) then
        Heli.InAlert = true
        setElementData(Heli.Element, 'InAlert', true)
    end
end
addEvent('SetHeliInAlert', true)
addEventHandler('SetHeliInAlert', root, SetHeliInAlert)

CheckHeliTarget = function()
    if isElement(Heli.Element) and isElement(Heli.Colshape) then
        local players = GetAvaiableHeliTargets()
        if (#players > 0) then
            Heli.Target = players[math.random(#players)]
        else
            Heli.Target = nil
        end
        triggerClientEvent(root, 'ChangeHeliTarget', resourceRoot, Heli.Target)
    else
        if isTimer(Heli.TargetTimer) then
            killTimer(Heli.TargetTimer)
        end
        Heli.Target = nil
        triggerClientEvent(root, 'ChangeHeliTarget', resourceRoot, Heli.Target)
    end
end
