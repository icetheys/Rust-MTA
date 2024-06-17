UTILS = exports['stoneage_utils']

Sentry = {}
PlayerSentry = {}

local Init = function()
    local dummy = getElementByID('Sentry')
    if dummy then
        Async:foreach(getElementChildren(dummy), function(ob, k)
            InitSentry(ob)
        end)
    end
end
addEventHandler('onResourceStart', resourceRoot, Init)

function InitSentry(ob)
    if not isElement(ob) then
        return
    end

    local this = {}

    this.ob = ob
    this.colshape = createColSphere(0, 0, 0, 10)
    setElementParent(this.colshape, ob)
    attachElements(this.colshape, ob, 10, 0)

    local x, y, z = UTILS:getPositionFromElementOffset(ob, 10, 0, 0)
    setElementPosition(this.colshape, x, y, z)

    addEventHandler('onColShapeHit', this.colshape, function(player, sameDim)
        if getElementType(player) == 'player' and sameDim then
            onPlayerEnterSentry(ob, player)
        end
    end)

    addEventHandler('onColShapeLeave', this.colshape, function(player, sameDim)
        if getElementType(player) == 'player' and sameDim then
            onPlayerLeaveSentry(ob, player)
        end
    end)

    addEventHandler('onElementDestroy', ob, function()
        Sentry[source] = nil
    end)

    this.target = false
    Sentry[ob] = this
end

onPlayerEnterSentry = function(ob, player)
    if ob and Sentry[ob] and not isFriendlySentry(ob, player) then
        if (not Sentry[ob].target) then
            Sentry[ob].target = player
            PlayerSentry[player] = ob
            syncSentryToClients(ob, true)

            if isTimer(Sentry[ob].timer) then
                killTimer(Sentry[ob].timer)
            end

            Sentry[ob].timer = setTimer(CheckOtherTarget, 3000, 0, ob)
        end
    end
end

onPlayerLeaveSentry = function(ob, player)
    if ob and Sentry[ob] then
        if (Sentry[ob].target == player) then
            Sentry[ob].target = nil
            PlayerSentry[player] = nil

            if not CheckOtherTarget(ob) then
                if isTimer(Sentry[ob].timer) then
                    killTimer(Sentry[ob].timer)
                end
                Sentry[ob].timer = nil
            end

            syncSentryToClients(ob, true)
        end
    end
end

MakeSentryForgetPlayer = function(player)
    if PlayerSentry[player] then
        onPlayerLeaveSentry(PlayerSentry[player], player)
    end
end

addEventHandler('onPlayerQuit', root, function()
    MakeSentryForgetPlayer(source)
end)

addEvent('sentry:addAmmoToSentry', true)
addEventHandler('sentry:addAmmoToSentry', root, function(ob)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if ob and Sentry[ob] then
        if (getElementData(source, 'Sentry Ammo') or 0) <= 0 then
            return
        end

        local toAdd = math.min(30, (getElementData(source, 'Sentry Ammo') or 0))

        local maxAmmo = exports['gamemode']:getObjectDataSetting('Sentry', 'maxAmmo')

        if (getElementData(ob, 'sentry:ammo') or 0) + toAdd > maxAmmo then
            toAdd = maxAmmo - (getElementData(ob, 'sentry:ammo') or 0)
        end

        setElementData(ob, 'sentry:ammo', (getElementData(ob, 'sentry:ammo') or 0) + toAdd)
        setElementData(source, 'Sentry Ammo', (getElementData(source, 'Sentry Ammo') or 0) - toAdd)

        setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false)
    end
end)

addEvent('sentry:removeAmmoFromSentry', true)
addEventHandler('sentry:removeAmmoFromSentry', root, function(ob)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if ob and Sentry[ob] then
        local toRemove = getElementData(ob, 'sentry:ammo') or 0
        if toRemove > 30 then
            toRemove = 30
        end

        setElementData(ob, 'sentry:ammo', (getElementData(ob, 'sentry:ammo') or 0) - toRemove)
        setElementData(source, 'Sentry Ammo', (getElementData(source, 'Sentry Ammo') or 0) + toRemove)

        setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false)
    end
end)

CheckOtherTarget = function(ob)
    if ob and Sentry[ob] and isElement(ob) then
        local insidePlayers = getElementsWithinColShape(Sentry[ob].colshape, 'player') or {}
        if #insidePlayers > 0 then
            
            local players = {}
            for k, v in pairs(insidePlayers) do
                if (not isFriendlySentry(ob, v)) then
                    table.insert( players,v )
                end
            end
            
            Sentry[ob].target = UTILS:randomValueInTable(players) or nil
            return true
        end
    end
    return false
end

-- //------------------- UTILS -------------------\\--

function getAccountPlayer(accName)
    for k, player in ipairs(getElementsByType('player')) do
        if getElementData(player, 'account') == accName then
            return player
        end
    end
    return false
end

function isFriendlySentry(ob, player)
    if isElement(ob) and isElement(player) then
        local creator = getElementData(ob, 'owner')
        local owner = getAccountPlayer(creator)
        if getElementData(player, 'staffRole') then
            return true
        end
        if (owner == player) then
            return true
        end
        local group = owner and getElementData(owner, 'Group') or exports['gamemode']:GetAccountData(creator, 'Group')
        return group and group == getElementData(player, 'Group')
    end
    return true
end

function syncSentryToClients(ob, toEverybody)
    if Sentry[ob] and isElement(ob) then
        triggerClientEvent(toEverybody and root or source, 'sentry:receiveInfo', resourceRoot, ob, {
            target = Sentry[ob].target,
        })
    end
end
addEvent('sentry:requestInfo', true)
addEventHandler('sentry:requestInfo', root, syncSentryToClients)
-- //------------------- UTILS -------------------\\--
