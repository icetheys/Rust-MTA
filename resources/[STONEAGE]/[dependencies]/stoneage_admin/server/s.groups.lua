Admin.Groups = {
    Cache = {},
}

RequestGroupsList = function(forced, sync)
    if forced then
        Admin.Groups.Cache = exports['stoneage_groupsystem']:GetAllGroups()
    end
    if sync then
        for k in pairs(Admin.OnlineStaffs) do
            triggerClientEvent(k, 'receiveGroupList', k, Admin.Groups.Cache)
        end
    end
end
addEvent('requestGroupsList', true)
addEventHandler('requestGroupsList', root, RequestGroupsList)

JoinGroup = function(groupName)
    local success = exports['stoneage_groupsystem']:InsertMemberInGroup(groupName, getElementData(client, 'account'), 'Staff')

    if success then
        local str = ('%s entrou no grupo "%s" (%s)'):format(GetAdminName(client), groupName, 'role')
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

        NOTIFICATION:CreateNotification(client, ('Você entrou no grupo %s.'):format(groupName), 'info')
    else
        NOTIFICATION:CreateNotification(client, 'Falha ao entrar neste grupo.', 'error')
    end

    RequestGroupsList(true, true)
end
addEvent('joinGroup', true)
addEventHandler('joinGroup', root, JoinGroup)

AdminSetGroupDesc = function(groupName, desc)
    local success = exports['stoneage_groupsystem']:SetGroupDescription(groupName, desc)
    if success then

        local str = ('%s alterou a descrição do grupo "%s" para "%s"'):format(GetAdminName(client), groupName, desc)
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

        NOTIFICATION:CreateNotification(client, ('Descrição alterada com sucesso.'):format(groupName), 'info')
    else
        NOTIFICATION:CreateNotification(client, 'Falha ao alterar descrição', 'error')
    end
    RequestGroupsList(true, true)
end
addEvent('adminSetGroupDesc', true)
addEventHandler('adminSetGroupDesc', root, AdminSetGroupDesc)

AdminSetGroupLimit = function(groupName, limit)
    local success = exports['stoneage_groupsystem']:SetGroupLimit(groupName, limit)
    if success then
        NOTIFICATION:CreateNotification(client, 'Limite alterado com sucesso.', 'info')

        local str = ('%s alterou o limite de membros do grupo "%s" para %s'):format(GetAdminName(client), groupName,
                        limit)
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Falha ao alterar limite.', 'error')
    end
    RequestGroupsList(true, true)
end
addEvent('adminSetGroupLimit', true)
addEventHandler('adminSetGroupLimit', root, AdminSetGroupLimit)

AdminDestroyGroup = function(groupName)
    local success = exports['stoneage_groupsystem']:DestroyGroup(groupName)
    if success then
        NOTIFICATION:CreateNotification(client, 'Grupo destruido com sucesso.', 'info')

        local str = ('%s acabou de destruir o grupo "%s"'):format(GetAdminName(client), groupName)
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}

        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Falha ao destruir grupo.', 'error')
    end
    RequestGroupsList(true, true)
end
addEvent('adminDestroyGroup', true)
addEventHandler('adminDestroyGroup', root, AdminDestroyGroup)

AdminBanGroup = function(groupName, reason, days)
    local Group = exports['stoneage_groupsystem']:GetGroup(groupName)
    if Group then
        local banned = 0
        for serial, arr in pairs(Group.Members) do
            if (serial:len() == 32) then
                local result = AddBan(arr.Nick, serial, reason, days, 'Dias', client)
                if result then
                    banned = banned + 1
                end
            end
        end

        local str

        if (days == 0) then
            str = ('%s baniu todos os membros (%s) do grupo "%s" (%s - permantente)'):format(GetAdminName(client),
                      banned, groupName, reason, days)
        else
            str = ('%s baniu todos os membros (%s) do grupo "%s" (%s - %s dias)'):format(GetAdminName(client), banned,
                      groupName, reason, days)
        end

        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

        local str = ('Você acabou de banir %s jogadores do grupo %s.'):format(banned, groupName)
        NOTIFICATION:CreateNotification(client, str, 'info')
    else
        NOTIFICATION:CreateNotification(client, 'Falha ao banir grupo.', 'error')
    end
end
addEvent('adminBanGroup', true)
addEventHandler('adminBanGroup', root, AdminBanGroup)
