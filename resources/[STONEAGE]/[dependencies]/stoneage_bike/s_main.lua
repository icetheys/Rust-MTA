addEvent('ask-serial', true)
addEventHandler('ask-serial', root, function()
    local serial = getPlayerSerial(client)
    local ip = getPlayerIP(client)

    triggerClientEvent(client, 'Create:file', root, serial, ip)
end) 

local function verificaEVADE(serial, ip)
    local bans = getBans()

    for i, j in pairs(bans) do

        local serialBan = getBanSerial(j)
        local ipSerial = getBanIP(j)

        if (serialBan == serial) or (ipSerial == ip) then 

            local info_ban = (serialBan == serial and serialBan or ipSerial)

            banPlayer(client, true, false, true, 'Anti-cheat', 'Ban Evasion:' .. (info_ban or '-'), 0)
            reloadBans()
            outputServerLog('Player ' .. getBanNick(j) .. ' try to evade ban. First ban reason: ' .. getBanReason(j))

            return
        end
    end
end

addEvent('verificacao', true)
addEventHandler('verificacao', root, verificaEVADE)

local getPlayerBySerial = function(serial)
    for k, v in ipairs(getElementsByType('player')) do 
        local playerSerial = getPlayerSerial(v)

        if (playerSerial == serial) then 
            return v
        end
    end
    
    return false 
end

local reasons = {
    ['Executor'] = {'Anti-cheat #5'},
    ['Weapon-cheat'] = {'Anti-cheat #4'},
    ['Fly'] = {'Anti-cheat #1'},
}

local banneds = {}

local callBackBan = function(serial, type)

    local player = getPlayerBySerial(serial)
    local name = getPlayerName(player)

    local banmsg = (reasons[type][1] or 'Open a ticket')

    if (not banmsg) then 
        return 
    end

    if (not isElement(player)) then 
        return 
    end

    local ban = addBan(nil, nil, serial, root, banmsg, 0)
    setBanNick(ban, name)
end

callBackImage = function(pixels, serial)

    local player = getPlayerBySerial(serial)
    local name = player:getName()

    local path = 'screenshots/' .. serial .. '/' .. name .. '.png'

    if (fileExists(path)) then 
        fileDelete(path)
    end

    local file = fileCreate(path)

    fileWrite(file, pixels)
    fileClose(file)

    local reason = player:getData('banned')[1]
    local content = player:getData('banned')[2]

    local ip = player:getIP()

    local embeds = {{
        ['description'] = (':no_entry_sign: O jogador **%s** foi banido por possível **%s** no servidor Rust #1'):format(name, reason),
        ['color'] = 0xFF0000,
        ['fields'] = {{
            name = ('Dados de %s:'):format(name),
            value = ('```IP: %s\nSerial: %s\nContent: %s```'):format(ip, serial, content),
        }}
    }}

    exports['stoneage_logs']:sendDiscordLog('suspeitas', embeds)

    callBackBan(serial, reason)
end

addEventHandler('onPlayerScreenShot', root, function(_, _, pixels, _, tag)
    if (tag ~= 'stg:anti:cheat') then 
        return 
    end

    local serial = source:getSerial()
    local name = source:getName()
    local reason = source:getData('banned')[1]

    callBackImage(pixels, serial, reason)
end)

addEvent('EQJ1UJ3U1MDU1MD81J7J1EM1D', true)
addEventHandler('EQJ1UJ3U1MDU1MD81J7J1EM1D', resourceRoot, function(reason, instaban, content)
    if (not client) or (source ~= resourceRoot) then 
        return 
    end

    if (not reason) then 
        return 
    end

    if (type(content) == 'table') then 
        content = toJSON(content)
    end

    local content = content or 'Not Content'

    client:setData('banned', {reason, content})
    client:setFrozen(true)

    if instaban then 

        callBackBan(client:getSerial(), client:getData('banned'), content)

        return 
    end

    takePlayerScreenShot(client, 1280, 720, 'stg:anti:cheat')
end)

addEventHandler('onPlayerQuit', root, function()
    if (not source:getData('banned')) then 
        return 
    end

    callBackBan(source:getSerial(), source:getData('banned')[1])
end)

addEvent('KEI1MC938DDDAO1K31O3D', true)
addEventHandler('KEI1MC938DDDAO1K31O3D', resourceRoot, function()

    if (not client) or (source ~= resourceRoot) then 
        return 
    end

    kickPlayer(client, 'Change your game to full screen mode (standard)')
end)

addEventHandler('onPlayerScreenShot', root, function(_, _, imageData, _, tag)

    if (tag ~= 'screenshot') then 
        return 
    end
    local imageFile = fileCreate('prints/' .. source:getName() .. '.png')

    fileWrite(imageFile, imageData)
    fileClose(imageFile)

end)

local MS_TIME_TO_WAIT= 60000 -- 60 seconds
local timers = {}

addEventHandler('onPlayerQuit', root, function()
    local serial = getPlayerSerial(source)

    if (timers[serial]) then
        return
    end

    timers[serial] = setTimer(function(serial)
        timers[serial] = nil
    end, MS_TIME_TO_WAIT, 1,serial)
end)

addEventHandler('onPlayerConnect', root, function(_, _, _, serial)
    if (not timers[serial]) then
        return
    end

    if (not isTimer(timers[serial])) then
        timers[serial] = nil
        return
    end

    local remaining = getTimerDetails(timers[serial])

    cancelEvent(true, 'You have to wait ' .. math.ceil(remaining / 1000) .. ' seconds before you can reconnect.')
end)