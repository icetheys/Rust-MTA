Timings = {}

Commands = {
    ['logout'] = true,
    ['me'] = true,
    ['msg'] = true,
    ['register'] = true,
    ['debugscript'] = true,
    ['refresh'] = true,
    ['login'] = true,
}

addEvent("notifyHzGod", true)
addEventHandler("notifyHzGod", root, function()
    if isElement(source) and getElementType(client) == "player" then
        local name = getPlayerName(client)
        local serial = getPlayerSerial(client)
        local ban = addBan(nil, nil, serial, root, 'Cheating (04/03/23)', 0)
        setBanNick(ban, name)
    end
end)

WhitelistSerialToCommands = {
    ['CF93682723AFBD1658E8B000E9CB7594'] = true,
    ['2E4B0B5CA3F9467A9C35DF468ACF9212'] = true,
    ['2BE2249E891E52A1EB2A5E1446A99F41'] = true,
}

addEventHandler('onPlayerCommand', getRootElement(), function(command)
    if getElementData(source, 'staffRole') or WhitelistSerialToCommands[getPlayerSerial(source)] then
        return false
    end
    if Commands[command] or (#command > 20) then
        cancelEvent(true)
    else
        if (not Timings[source]) then
            Timings[source] = {}
        end
        if (not Timings[source][command]) then
            Timings[source][command] = getTickCount()
        elseif (getTickCount() - Timings[source][command]) >= 500 then
            Timings[source][command] = getTickCount()
        else
            cancelEvent(true)
        end
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if Timings[source] then
        Timings[source] = nil
    end
end)

addEventHandler('onPlayerChangeNick', root, function(_, _, byUser)
    if byUser then
        cancelEvent(true)
    end
end)

addEventHandler('onVehicleStartExit', root, function()
    local speed = getElementSpeed(source, 1) or 0
    if (speed >= 10) then
        cancelEvent()
    end
end)

function getElementSpeed(theElement, unit)
    if (isElement(theElement) and (getElementType(theElement) == 'player')) then
        unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
        local mult = (unit == 0 or unit == 'm/s') and 50 or ((unit == 1 or unit == 'km/h') and 180 or 111.84681456)
        return (Vector3(getElementVelocity(theElement)) * mult).length
    end
    return false
end

addCommandHandler('transferir_dados', function(player, cmd, oldSerial, newSerial)
    if (getPlayerSerial(player) ~= '1A37A6CB366ABBEDE08F6FE646A6FDB2') then
        return false
    end

    local q = 0

    for k, v in ipairs(getElementsByType('object')) do
        if (getElementData(v, 'owner') == oldSerial) then
            setElementData(v, 'owner', newSerial)
            q = q + 1
        end
    end

    outputChatBox(('%s objetos foram transferidos.'):format(q), player, 255, 255, 0)
end)

-- createBlip(-191.72166442871, 6.7303495407104, 10.28872013092, 23)

-- local q = 0

-- for k,v in ipairs(getElementsByType('object')) do
--     if (getElementData(v, 'owner') == "E5F18C1323C2745A90C44BCAAC2D3124 (STAFF)") then
--         setElementData(v, 'owner', 'E5F18C1323C2745A90C44BCAAC2D3124')
--         q = q + 1
--     end
-- end

-- print(('%s objetos foram transferidos.'):format(q))

setTimer(function()
    for k, v in pairs(getElementsByType('player')) do
        if isPedWearingJetpack(v) then
            local name = getPlayerName(v)
            local serial = getPlayerSerial(v)
            local ban = addBan(nil, nil, serial, root, 'Anti-cheat (#2)', 0)
            setBanNick(ban, name)
        end
    end
end, 500, 0)

local getPlayerBySerial = function(serial)
    for k, v in ipairs(getElementsByType('player')) do 
        local playerSerial = getPlayerSerial(v)

        if (playerSerial == serial) then 
            return v
        end
    end
    
    return false 
end

local callBackBan = function(serial, name, type)
    local ban = addBan(nil, nil, serial, root, type, 0)
    setBanNick(ban, name)
end

addEventHandler('onPlayerScreenShot', root, function(theResource, status, pixels, timestamp, tag)
    local caracter = tag:sub(#tag, #tag)

    if (caracter ~= ';') then 
        return 
    end

    local index = tag:find(';')
    local serial = tag:sub(1, index - 1)
    local reason = 'Anti-cheat #5'

    if (not serial) or (not reason) then 
        return 
    end

    local localFile = 'images/' .. serial .. '/' .. reason .. '.png'

    local pathFile = fileCreate(localFile)

    if (file) then
        fileWrite(pathFile, pixels)
        fileClose(pathFile)
    end

    callBackBan(serial, getPlayerName(getPlayerBySerial(serial)), reason)
end)

addEvent('addSelfBan', true)
addEventHandler('addSelfBan', root, function(reason)
    local name = getPlayerName(client)
    local serial = getPlayerSerial(client)

    local embeds = {{
        ['description'] = (':point_left: O jogador **%s** foi banido por possivelmente estar voando no servidor Rust #1 (%s)'):format(getPlayerName(client), reason),
        ['color'] = 0xFF0000,
        ['fields'] = {{
            name = ('Dados de %s:'):format(name),
            value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(client), serial),
        }},
    }}

    exports['stoneage_logs']:sendDiscordLog('suspeitas', embeds)

    local tag = serial .. ';'
    takePlayerScreenShot(client, 1280, 720, tag)
end)

KickForCallingUnauthorizedEvent = function(player, eventName)
    if (not isElement(player)) then
        return
    end
    
    if (getElementType(player) ~= 'player') then
        return
    end
    
    local name = getPlayerName(player)
    local serial = getPlayerSerial(player)
    
    local embeds = {{
        ['description'] = (':point_left: O jogador **%s** foi banido por chamar um evento não autorizado - Rust #1 (%s)'):format(name, serial),
        ['color'] = 0xFF0000,
        ['fields'] = {{
            name = ('Dados de %s:'):format(name),
            value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(player), serial),
        }},
    }}

    local tag = serial .. ';'
    takePlayerScreenShot(player, 1280, 720, tag)

    exports['stoneage_logs']:sendDiscordLog('suspeitas', embeds)

    assert(false, 'aq')
end