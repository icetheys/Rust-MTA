Admin.Bans = {
    Cache = {},
}

GenerateBanList = function(reloadList)
    if reloadList then
        reloadBans()
    end
    local bans = {}
    for k, v in ipairs(getBans()) do
        table.insert(bans, {
            IP = getBanIP(v),
            Name = getBanNick(v),
            Admin = getBanAdmin(v),
            Serial = getBanSerial(v),
            Reason = getBanReason(v),
            Time = getBanTime(v),
            Unban = getUnbanTime(v),
        })
    end
    return bans
end

RequestBanList = function(forced, sync, reloadList)
    if forced then
        Admin.Bans.Cache = GenerateBanList(reloadList)
    end
    if sync then
        for k in pairs(Admin.OnlineStaffs) do
            triggerClientEvent(k, 'receiveBanList', k, Admin.Bans.Cache)
        end
    end
end
addEvent('requestBanList', true)
addEventHandler('requestBanList', root, RequestBanList)

UnbanSerial = function(serial)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    for k, v in ipairs(getBans()) do
        if (getBanSerial(v) == serial) then
            NOTIFICATION:CreateNotification(client, 'Banimento removido com sucesso.', 'info')
            RequestBanList(true, true)

            local str = ('%s removeu o banimento: %s (%s - %s)'):format(GetAdminName(client), getBanNick(v), getBanReason(v), serial)
            local embeds = {{
                ['description'] = str,
                ['color'] = 0xFFFFFF,
            }}

            exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
            exports['stoneage_logs']:saveLog('staff-actions', str)

            removeBan(v, client)
            return
        end
    end
    NOTIFICATION:CreateNotification(client, 'Banimento não encontrado.', 'error')
end
addEvent('_unbanSerial', true)
addEventHandler('_unbanSerial', root, UnbanSerial)

local ConversionTimes = {
    ['Minutos'] = 60,
    ['Horas'] = 3600,
    ['Dias'] = 86400,
    ['Meses'] = 2592000,
}

ConvertBanTime = function(tempo, type, editing)
    if (not ConversionTimes[type]) then
        return 0
    end
    return (editing and getRealTime().timestamp or 0) + math.floor(math.abs(tempo)) * ConversionTimes[type]
end

EditBan = function(name, serial, reason, tempo, tempoType)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    for k, v in ipairs(getBans()) do
        if (getBanSerial(v) == serial) then
            setUnbanTime(v, ConvertBanTime(tempo, tempoType, true))
            setBanNick(v, name)
            setBanReason(v, reason)
            NOTIFICATION:CreateNotification(client, 'Banimento editado com sucesso.', 'info')

            local embeds = {{
                ['description'] = ('%s editou o banimento:'):format(GetAdminName(client)),
                ['fields'] = {{
                    name = 'Nome do banimento',
                    value = name,
                }, {
                    name = 'Serial',
                    value = serial,
                }, {
                    name = 'Motivo',
                    value = reason,
                }, {
                    name = 'Tempo',
                    value = ('%s %s'):format(tempo, tempoType),
                }},
                ['color'] = 0xFFFFFF,
            }}

            exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
            exports['stoneage_logs']:saveLog('staff-actions', inspect(embeds))
            
            RequestBanList(true, true)
            return
        end
    end
    NOTIFICATION:CreateNotification(client, 'Banimento não encontrado.', 'error')
end
addEvent('_editBan', true)
addEventHandler('_editBan', root, EditBan)

AddBan = function(name, serial, reason, tempo, tempoType, player)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end

    player = player or client

    for k, v in ipairs(getBans()) do
        if (getBanSerial(v) == serial) then
            NOTIFICATION:CreateNotification(player, ('Este serial já está banido. (%s)'):format((getBanNick(v) or '*Desconhecido')), 'error')
            return false
        end
    end

    local addedTime = ConvertBanTime(tempo, tempoType)

    local ban = addBan(nil, nil, serial, player, reason, addedTime)
    setBanNick(ban, name)

    exports['stoneage_notifications']:CreateNotification(root, ('%s acabou de ser banido (%s).'):format(name, (addedTime == 0) and 'Perm.' or ('%s %s'):format(tempo, tempoType)), 'error', 30000)

    local embeds = {{
        ['description'] = ('%s adiciou o banimento:'):format(GetAdminName(player)),
        ['fields'] = {{
            name = 'Nome do banimento',
            value = name,
        }, {
            name = 'Serial',
            value = serial,
        }, {
            name = 'Motivo',
            value = reason,
        }, {
            name = 'Tempo',
            value = ('%s %s'):format(tempo, tempoType),
        }},
        ['color'] = 0xFFFF00,
    }}

    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', inspect(embeds))

    if (not player) then
        RequestBanList(true, true)
    end

    NOTIFICATION:CreateNotification(player, 'Banimento adicionado com sucesso.', 'info')
    
    return true
end
addEvent('_addBan', true)
addEventHandler('_addBan', root, AddBan)
