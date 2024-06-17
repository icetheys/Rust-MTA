Admin.Vips = {
    Cache = {},
    OnlineVipPlayers = 0,
}

local Init = function()
    SQL:Exec([[
        CREATE TABLE IF NOT EXISTS `VIPS` (
            `Description` Text, 
            `Serial` TEXT, 
            `RemainingTime` INT, 
            `PausedTime` INT, 
            `ActivationTimestamp` INT, 
            `Admin` TEXT
        )]])
    RequestVIPList(true, false)
end
addEventHandler('onResourceStart', resourceRoot, Init)

GenerateVIPList = function()
    local vips = {}
    local Query = SQL:Query('SELECT * FROM `VIPS`')
    if (#Query > 0) then
        for k, v in ipairs(Query) do
            local playerNick
            local player = GAMEMODE:getAccountPlayer(v.Serial)
            if player then
                playerNick = getPlayerName(player)
            else
                playerNick = GAMEMODE:GetAccountData(v.Serial, 'lastNick') or '*Sem conta'
            end
            table.insert(vips, {
                Description = v.Description,
                Serial = v.Serial,
                RemainingTime = v.RemainingTime,
                PausedTime = v.PausedTime,
                ActivationTick = v.ActivationTick,
                Admin = v.Admin,
                Name = playerNick,
            })
        end
    end
    return vips
end

RequestVIPList = function(forced, sync)
    if forced then
        Admin.Vips.Cache = GenerateVIPList()
    end
    if sync then
        for k in pairs(Admin.OnlineStaffs) do
            triggerClientEvent(k, 'receiveVIPList', k, Admin.Vips.Cache)
        end
    end
end
addEvent('requestVIPList', true)
addEventHandler('requestVIPList', root, RequestVIPList)

RemoveVIP = function(serial)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    local Query = SQL:Query('SELECT * FROM `VIPS` WHERE `Serial`=?', serial)
    if (#Query > 0) then
        SQL:Exec('DELETE FROM `VIPS` WHERE `Serial`=?', serial)

        local Name
        local player = GAMEMODE:getAccountPlayer(serial)
        if player then
            Name = getPlayerName(player)
            removeElementData(player, 'VIP')
            local str = exports['stoneage_translations']:translate(player, 'VIP foi removido')
            NOTIFICATION:CreateNotification(player, str, 'error')
            Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers - 1
        else
            Name = GAMEMODE:GetAccountData(serial, 'lastNick') or '*Sem conta'
        end

        local str = (':no_entry_sign: O VIP de %s (%s) acabou ser removido por %s.'):format(Name, serial,
                        GetAdminName(source))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('vips', embeds)
        exports['stoneage_logs']:saveLog('vips', str)

        RequestVIPList(true, true)
        NOTIFICATION:CreateNotification(source, 'Operação concluida.', 'info')
    else
        NOTIFICATION:CreateNotification(source, 'VIP Não encontrado.', 'error')
    end
end
addEvent('removeVIP', true)
addEventHandler('removeVIP', root, RemoveVIP)

ConvertVIPTime = function(tempo, type, editing)
    if type == 'Permanente' then
        return -1
    elseif type == 'Meses' then
        return math.abs((tempo * 30) + (editing and 0 or 1))
    end
    return math.abs(tempo + (editing and 0 or 1))
end

AddVIP = function(serial, descricao, tempo, tempoType, tempoPausado)
    local Query = SQL:Query('SELECT * FROM `VIPS` WHERE `Serial`=?', serial)
    if (#Query == 0) then
        local Time = ConvertVIPTime(tempo, tempoType)

        SQL:Exec('INSERT INTO `VIPS` VALUES (?,?,?,?,?,?)', descricao, serial, Time, math.abs(tempoPausado),            getRealTime().timestamp, GetAdminName(source))

        local Name
        local player = GAMEMODE:getAccountPlayer(serial)
        if player then
            local str = exports['stoneage_translations']:translate(player, 'Você recebeu VIP')
            NOTIFICATION:CreateNotification(player, str, 'info')
            setElementData(player, 'VIP', true)
            setElementData(player, 'maxSlots', 42)
            Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers + 1
            Name = getPlayerName(player)
        else
            Name = GAMEMODE:GetAccountData(serial, 'lastNick') or '*Sem conta'
        end

        RequestVIPList(true, true)
        NOTIFICATION:CreateNotification(source, 'VIP setado com sucesso.', 'info')

        NOTIFICATION:CreateNotification(root, ('%s se tornou VIP.'):format(Name), 'event', 30000)

        local embeds = {{
            ['fields'] = {{
                name = 'Tempo',
                value = ('```%s dias (pausa: %s)```'):format(Time, tempoPausado),
            }, {
                name = 'Descrição',
                value = ('```%s```'):format(descricao),
            }},
            ['description'] = (':gem: O VIP de %s [%s] foi ativado por %s'):format(Name, serial, GetAdminName(source)),
            ['color'] = 0xFFFF00,
        }}
        exports['stoneage_logs']:sendDiscordLog('vips', embeds)
        exports['stoneage_logs']:saveLog('vips', inspect(embeds))

    else
        local playerNick
        local player = GAMEMODE:getAccountPlayer(serial)
        if player then
            playerNick = getPlayerName(player)
        else
            playerNick = GAMEMODE:GetAccountData(serial, 'lastNick') or '*Sem conta'
        end
        NOTIFICATION:CreateNotification(source, ('Este serial já possui VIP. (%s)'):format(playerNick))
    end
end
addEvent('addVIP', true)
addEventHandler('addVIP', root, AddVIP)

AutoAddVIP = function(player, serial)
    local descricao = 'free vip'
    local tempo = 0
    local tempoType = 'Permanente'
    local tempoPausado = 0

    local Query = SQL:Query('SELECT * FROM `VIPS` WHERE `Serial`=?', serial)
    if (#Query == 0) then
        local Time = ConvertVIPTime(tempo, tempoType)

        SQL:Exec('INSERT INTO `VIPS` VALUES (?,?,?,?,?,?)', descricao, serial, Time, math.abs(tempoPausado), getRealTime().timestamp, 'Your server name')

        local Name = getPlayerName(player)

        local str = exports['stoneage_translations']:translate(player, 'Você recebeu VIP')
        NOTIFICATION:CreateNotification(player, str, 'info')
        setElementData(player, 'VIP', true)
        setElementData(player, 'maxSlots', 42)
        Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers + 1

        RequestVIPList(true, true)

        NOTIFICATION:CreateNotification(root, ('%s se tornou VIP.'):format(Name), 'event', 30000)
    end
end

addEvent('player:onLogin', true)
addEventHandler('player:onLogin', root, function(serial)
    -- AutoAddVIP(source, serial)
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for k, v in ipairs(getElementsByType('player')) do
        -- local serial = getPlayerSerial(v)
        -- AutoAddVIP(v, serial)
    end
end)

EditVIP = function(serial, descricao, tempo, tempoType, tempoPausado)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    local Query = SQL:Query('SELECT * FROM `VIPS` WHERE `Serial`=?', serial)
    if (#Query >= 0) then
        local VIP = Query[1]
        local Time = ConvertVIPTime(tempo, tempoType, true)
        SQL:Exec('UPDATE `VIPS` SET `Description`=?, `RemainingTime`=?, `PausedTime`=? WHERE `Serial`=?', descricao,
            Time, tempoPausado, serial)
        local player = GAMEMODE:getAccountPlayer(serial)

        local Name
        if player then
            if (tempoPausado > 0) then
                local str = exports['stoneage_translations']:translate(player, 'VIP foi pausado')
                NOTIFICATION:CreateNotification(player, str, 'info')
                removeElementData(player, 'VIP')
            else
                if (VIP.PausedTime > 0) then
                    local str = exports['stoneage_translations']:translate(player, 'VIP foi despausado')
                    NOTIFICATION:CreateNotification(player, str, 'info')
                    setElementData(player, 'VIP', true)
                    setElementData(player, 'maxSlots', 42)
                    Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers + 1
                end
            end
            Name = getPlayerName(player)
        else
            Name = GAMEMODE:GetAccountData(serial, 'lastNick') or '*Sem conta'
        end
        local embeds = {{
            ['fields'] = {{
                name = 'Tempo',
                value = ('```%s dias (pausa: %s) -> %s dias (pausa: %s)```'):format(VIP.RemainingTime, VIP.PausedTime,
                    Time, tempoPausado),
            }, {
                name = 'Descrição',
                value = ('```%s -> %s```'):format(VIP.Description, descricao),
            }},
            ['description'] = (':memo: O VIP de %s [%s] foi editado por %s'):format(Name, serial, GetAdminName(source)),
            ['color'] = 0x666600,
        }}
        exports['stoneage_logs']:sendDiscordLog('vips', embeds)
        exports['stoneage_logs']:saveLog('vips', inspect(embeds))

        NOTIFICATION:CreateNotification(source, 'VIP editado com sucesso.', 'info')

        RequestVIPList(true, true)
    else
        NOTIFICATION:CreateNotification(source, 'Este VIP não foi encontrado.', 'error')
    end
end
addEvent('editVIP', true)
addEventHandler('editVIP', root, EditVIP)

setTimer(function()
    RequestVIPList(true, false)
    for k, v in ipairs(Admin.Vips.Cache) do
        if (v.RemainingTime > 0) then
            if (v.PausedTime == 0) then
                if ((v.RemainingTime - 1) > 0) then
                    SQL:Exec('UPDATE `VIPS` SET `RemainingTime`=? WHERE `Serial`=?', v.RemainingTime - 1, v.Serial)
                else
                    SQL:Exec('DELETE FROM `VIPS` WHERE `Serial`=?', v.Serial)
                    local player = GAMEMODE:getAccountPlayer(v.Serial)
                    if player then
                        local str = exports['stoneage_translations']:translate(player, 'VIP foi removido')
                        NOTIFICATION:CreateNotification(player, str, 'error')
                        removeElementData(player, 'VIP')
                        Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers - 1
                    end
                    local embeds = {{
                        ['description'] = (':no_entry_sign: O VIP de %s (%s) acabou de expirar.'):format(v.Name,
                            v.Serial),
                        ['color'] = 0xFF0000,
                    }}
                    exports['stoneage_logs']:sendDiscordLog('vips', embeds)
                    exports['stoneage_logs']:saveLog('vips', inspect(embeds))
                end
            else
                SQL:Exec('UPDATE `VIPS` SET `PausedTime`=? WHERE `Serial`=?', v.PausedTime - 1, v.Serial)
                if ((v.PausedTime - 1) == 0) then
                    local player = GAMEMODE:getAccountPlayer(v.Serial)
                    if player then
                        local str = exports['stoneage_translations']:translate(player, 'VIP foi despausado')
                        NOTIFICATION:CreateNotification(player, str, 'info')
                        setElementData(player, 'VIP', true)
                        setElementData(player, 'maxSlots', 42)
                        Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers + 1
                    end
                    local embeds = {{
                        ['description'] = (':gem: O VIP de %s (%s) acabou ser despausado.'):format(v.Name, v.Serial),
                        ['color'] = 0xFFFFFF,
                    }}
                    exports['stoneage_logs']:sendDiscordLog('vips', embeds)
                    exports['stoneage_logs']:saveLog('vips', inspect(embeds))
                end
            end
        end
    end
    RequestVIPList(true, true)
end, 86400000, 0) -- > 24 horas

addEvent('addVIPDays', true)
addEventHandler('addVIPDays', root, function(quantity)
    RequestVIPList(true, false)
    for k, v in ipairs(Admin.Vips.Cache) do
        if (v.RemainingTime > 0) then
            if ((v.RemainingTime + quantity) > 0) then
                SQL:Exec('UPDATE `VIPS` SET `RemainingTime`=? WHERE `Serial`=?', v.RemainingTime + quantity, v.Serial)
            else
                SQL:Exec('DELETE FROM `VIPS` WHERE `Serial`=?', v.Serial)
                local player = GAMEMODE:getAccountPlayer(v.Serial)
                if player then
                    local str = exports['stoneage_translations']:translate(player, 'VIP foi removido')
                    NOTIFICATION:CreateNotification(player, str, 'error')
                    removeElementData(player, 'VIP')
                    Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers - 1
                end
                local embeds = {{
                    ['description'] = (':no_entry_sign: O VIP de %s (%s) acabou de expirar.'):format(v.Name, v.Serial),
                    ['color'] = 0xFF0000,
                }}
                exports['stoneage_logs']:sendDiscordLog('vips', embeds)
                exports['stoneage_logs']:saveLog('vips', inspect(embeds))
            end
        end
    end

    local str = ('%s adicionou %i dias para todos os VIPS.'):format(GetAdminName(client), quantity)
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFFFF00,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

    RequestVIPList(true, true)
end)

addEvent('player:onLogin', true)
addEventHandler('player:onLogin', root, function(account)
    for k, v in pairs(Admin.Vips.Cache) do
        if (v.Serial == account) then
            if (v.PausedTime == 0) then
                setElementData(source, 'VIP', true)
                setElementData(source, 'maxSlots', 42)
                Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers + 1
                local str = exports['stoneage_translations']:translate(source, 'Você recebeu VIP')
                exports['stoneage_notifications']:CreateNotification(source, str, 'info')
                if (v.RemainingTime <= 5) and (v.RemainingTime >= 0) then
                    local str = exports['stoneage_translations']:translate(source, 'vip perto expirar', nil, v.RemainingTime)
                    exports['stoneage_notifications']:CreateNotification(source, str, 'info')
                end
            end
            break
        end
    end
end)

addCommandHandler('vip', function(player)
    if getElementData(player, 'VIP') then
        for k, v in pairs(Admin.Vips.Cache) do
            if (v.Serial == getElementData(player, 'account')) then
                local str = exports['stoneage_translations']:translate(player, 'vip perto expirar', nil, v.RemainingTime)
                exports['stoneage_notifications']:CreateNotification(player, str, 'info')
                break    
            end
        end
    end
end, false, true)

addEventHandler('onPlayerQuit', root, function()
    if getElementData(source, 'VIP') then
        Admin.Vips.OnlineVipPlayers = Admin.Vips.OnlineVipPlayers - 1
    end
end)

addEventHandler('onPlayerConnect', root, function(_, _, _, serial)
    local slotsVIP = exports['stoneage_settings']:getConfig('Slots VIP', 10)
    if (#getElementsByType('player') + 1) >= (getMaxPlayers() - slotsVIP) and (not ADMINS[serial]) then
        for k, v in pairs(Admin.Vips.Cache) do
            if (v.Serial == serial) then
                return
            end
        end
        return cancelEvent(true, 'Server Full (Extra Slots to VIP)')
    end
end)
