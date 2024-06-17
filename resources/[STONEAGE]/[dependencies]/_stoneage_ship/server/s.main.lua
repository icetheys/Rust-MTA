Ship = {
    LootBoxes = {}
}

SpeedMultiplier = 400

local Init = function()
    SpawnShip()
end
addEventHandler('onResourceStart', resourceRoot, Init)

SpawnShip = function()
    ForgetPreviousShip()
    
    Ship.Route = {}
    Ship.Route.ID = math.random(#SpawnsPositions)
    Ship.Route.Step = math.random(#SpawnsPositions[Ship.Route.ID])
    
    Ship.Element = createObject(4552, unpack(SpawnsPositions[Ship.Route.ID][Ship.Route.Step].Pos))
    
    Ship.LOD = AssignLOD(Ship.Element)
    
    OnShipFinishRoute()
    
    Ship.Blip = createBlipAttachedTo(Ship.Element, 19)
    setElementData(Ship.Blip, 'BlipName', 'Ship')
    
    Ship.TimerHorn = setTimer(Horn, 5000, 1)

    GenerateLootBoxes()

    local time = exports['stoneage_settings']:getConfig('Minutos para respawnar loot nos navios', 30) * 60000
    Ship.TimerGenerateNewLoots = setTimer(GenerateLootBoxes, time, 0)

    Ship.TimerSync = setTimer(function()
        triggerClientEvent(root, 'ReceiveShip', root, Ship.Element)
    end, 500, 1)

end

OnShipFinishRoute = function()
    Ship.Route.Step = Ship.Route.Step + 1
    
    if (Ship.Route.Step > #SpawnsPositions[Ship.Route.ID]) then
        Ship.Route.Step = 1
    end
    
    local initX, initY, initZ = getElementPosition(Ship.Element)
    local targetX, targetY, targetZ = unpack(SpawnsPositions[Ship.Route.ID][Ship.Route.Step].Pos)
    
    local ShipSpeed = getDistanceBetweenPoints3D(initX, initY, initZ, targetX, targetY, targetZ) * SpeedMultiplier
    
    setElementRotation(Ship.Element, 0, 0, FindRotation(initX, initY, targetX, targetY) + 90)
    
    moveObject(Ship.Element, ShipSpeed, targetX, targetY, targetZ)
    
    if SpawnsPositions[Ship.Route.ID][Ship.Route.Step].Stop then
        Ship.FinishTimer = setTimer(OnShipFinishRoute, ShipSpeed * 2, 1)
    else
        Ship.FinishTimer = setTimer(OnShipFinishRoute, ShipSpeed, 1)
    end
end

RequestShip = function()
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if isElement(Ship.Element) then
        triggerClientEvent(client, 'ReceiveShip', client, Ship.Element)
    end
end
addEvent('RequestShip', true)
addEventHandler('RequestShip', root, RequestShip)

ForgetPreviousShip = function()
    for k, v in pairs(Ship) do
        if isElement(v) then
            destroyElement(v)
        elseif isTimer(v) then
            killTimer(v)
        end
    end
    DestroyLootBoxes()
end

Horn = function()
    if isElement(Ship.Element) then
        triggerClientEvent(root, 'PlayShipHorn', root)
    end
    Ship.TimerHorn = setTimer(Horn, math.random(30000, 1 * 60000), 1)
end
