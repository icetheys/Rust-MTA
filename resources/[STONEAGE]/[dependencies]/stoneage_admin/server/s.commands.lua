addCommandHandler('checar', function(player, cmd, serial)
    if isAdmin(player) then
        local Query = SQL:Query('SELECT * FROM `Accounts` WHERE `Owner`=?', serial)
        if (Query[1]) then
            local GAMEMODE = exports['gamemode']
            local infos = {
                nick = GAMEMODE:GetAccountData(serial, 'lastNick'),
                grupo = GAMEMODE:GetAccountData(serial, 'Group'),
                level = GAMEMODE:GetAccountData(serial, 'Level'),
                baseObjects = GAMEMODE:GetAccountData(serial, 'baseItems')
            }
            outputChatBox(('Informações da conta: %s'):format(serial), player, 255, 255, 0)
            for k, v in pairs(infos) do
                outputChatBox(('%s: %s'):format(k, inspect(v)), player, 255, 255, 255)
            end
        else
            exports['stoneage_notifications']:CreateNotification(player, 'Serial não encontrado.', 'error')
        end
    end
end)

addCommandHandler('pass', function()
    print('server password: ', getServerPassword())
end)
