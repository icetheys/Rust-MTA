addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if getElementType(source) == 'object' then
        setObjectBreakable(source, false)

        if getElementData(source, 'gearPickup') then
            setElementCollidableWith(localPlayer, source, false)
            setElementCollidableWith(localPlayer, getCamera(), false)
            for k, v in ipairs(getElementsByType('vehicle', root, true)) do
                setElementCollidableWith(v, source, false)
            end
            -- if not getElementData(source, 'syncedPos') then
                -- setTimer(function(ob)
                --     if isElement(ob) then
                --         local x, y, z = getElementPosition(ob)
                --         z = getGroundPosition(x, y, z)
                --         triggerServerEvent('pickups:syncSackPos', localPlayer, ob, x, y, z - 0.7)
                --     end
                -- end, 300, 1, source)
            -- end
        end
    end
end)

local damaged = {}
function damagePickup(ob, damage, fromMenu)
    if isElement(ob) and not damaged[ob] then
        damaged[ob] = true

        local health = getElementData(ob, 'health') or 0

        setElementData(ob, 'health', health - damage)

        local x, y, z = getElementPosition(ob)
        triggerServerEvent('rust:play3DSound', localPlayer, (':stoneage_pickups/files/barrel-hit(%i).mp3'):format(math.random(4)), {x, y, z}, 0.5, 50)

        if getElementData(ob, 'health') <= 0 then
            setElementCollisionsEnabled(ob, false)
            triggerServerEvent('pickups:onOpenBarrel', localPlayer, ob)
        end

        setTimer(function(ob)
            damaged[ob] = nil
        end, 500, 1, ob)

        if fromMenu then
            setPedControlState(localPlayer, 'fire', true)
        end
    end
end

addEventHandler('onClientObjectDamage', resourceRoot, function(loss, attacker)
    if attacker == localPlayer and getElementData(source, 'lootPickup') then
        local originalHealth = getElementHealth(source)
        setTimer(function(ob, originalHealth)
            if isElement(ob) then
                local loss = originalHealth - getElementHealth(ob)
                damagePickup(ob, loss * 10)
            end
        end, 100, 1, source, originalHealth)
    end
end)

addEventHandler('onClientElementDestroy', resourceRoot, function()
    if getElementType(source) == 'object' and isElementStreamedIn(source) then
        if getElementData(source, 'lootPickup') then
            local x, y, z = getElementPosition(source)
            for i = 1, math.random(3, 5) do
                createEffect('explosion_crate', x, y, z + math.random(0.5, 0), math.random(180), math.random(180), math.random(180), 0, true)
            end
        end
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    for k, v in pairs(configs.lootSettings) do
        engineSetModelLODDistance(v.modelID, 400)
    end

    for k, v in pairs(decorations) do

        engineSetModelLODDistance(v.model, 400)

    end
end)
