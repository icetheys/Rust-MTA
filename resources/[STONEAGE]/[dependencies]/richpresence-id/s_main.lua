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