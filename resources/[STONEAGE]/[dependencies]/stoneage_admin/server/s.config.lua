Admin.Config = {
    Cache = {},
}

Admin.Config.DefaultConfigs = {{
    Name = 'Multiplicador de experiência',
    DefaultValue = 0,
    Description = 'Toda experiencia obtida no servidor será multiplicada por este valor',
    Examples = '1, 1.5, 1.7, 2, 3 (não insira o "%" no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Multiplicador de experiência', 1)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or -1
        if (number >= 0) then
            exports['stoneage_settings']:setConfig('Multiplicador de experiência', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração', 'error')
        end
        return false
    end,
}, {
    Name = 'Porcentagem extra de spawn de loot',
    DefaultValue = 0,
    Description = 'Valor adicional da porcentagem de spawn de loot do servidor.',
    Examples = '0, 5, 12, 33, 55 (não insira o "%" no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Porcentagem extra de spawn de loot', 0)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or -1
        if (number >= 0) then
            exports['stoneage_settings']:setConfig('Porcentagem extra de spawn de loot', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração', 'error')
        end
        return false
    end,
}, {
    Name = 'Limite de itens no mesmo spawn',
    DefaultValue = 3,
    Description = 'Quantidade máxima de itens diferentes que pode podem spawnar no mesmo loot',
    Examples = '1, 3, 5, 10',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Limite de itens no mesmo spawn', 3)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number > 0) then
            exports['stoneage_settings']:setConfig('Limite de itens no mesmo spawn', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração', 'error')
        end
        return false
    end,
}, {
    Name = 'Minutos a cada airdrop',
    DefaultValue = 60,
    Description = 'A quantidade de minutos que se passa até que um novo airdrop seja chamado.',
    Examples = '5, 10, 15, 20, 25, 45, 60 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Minutos a cada airdrop', 60)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 5) then
            exports['stoneage_settings']:setConfig('Minutos a cada airdrop', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 5 minutos)', 'error')
        end
        return false
    end,
}, {
    Name = 'Minutos a cada heli atirador',
    DefaultValue = 60,
    Description = 'A quantidade de minutos que se passa até que um novo helicoptero atirador seja criado após a destruição do anterior.',
    Examples = '5, 10, 15, 20, 25, 45, 60 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Minutos a cada heli atirador', 60)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 5) then
            exports['stoneage_settings']:setConfig('Minutos a cada heli atirador', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 5 minutos)', 'error')
        end
        return false
    end,
}, {
    Name = 'Minutos para respawnar loot nos navios',
    DefaultValue = 30,
    Description = 'Este é o tempo para respawnar os loots no navio.',
    Examples = '5, 10, 15, 20, 25, 45, 60 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Minutos para respawnar loot nos navios', 30)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 5) then
            exports['stoneage_settings']:setConfig('Minutos para respawnar loot nos navios', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 5 minutos)', 'error')
        end
        return false
    end,
}, {
    Name = 'Minutos para respawnar farm',
    DefaultValue = 30,
    Description = 'Este é o tempo para respawnar objetos de farm (árvores, pedras, e e minérios em geral)',
    Examples = '5, 10, 15, 20, 25, 45, 60 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Minutos para respawnar farm', 30)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 5) then
            exports['stoneage_settings']:setConfig('Minutos para respawnar farm', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 5 minutos)', 'error')
        end
        return false
    end,
}, {
    Name = 'Minutos para respawnar veiculos',
    DefaultValue = 30,
    Description = 'Este é o tempo para respawnar veiculos após sua destruição',
    Examples = '5, 10, 15, 20, 25, 45, 60 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Minutos para respawnar veiculos', 30)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 1) then
            exports['stoneage_settings']:setConfig('Minutos para respawnar veiculos', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 5 minutos)', 'error')
        end
        return false
    end,
}, {
    Name = 'Minutos para nascer na cama',
    DefaultValue = 10,
    Description = 'Este é o intervalo de minutos para respawnar na cama',
    Examples = '5, 10, 15, 20, 25, 45, 60 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Minutos para nascer na cama', 10)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 5) then
            exports['stoneage_settings']:setConfig('Minutos para nascer na cama', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 5 minutos)', 'error')
        end
        return false
    end,
}, {
    Name = 'Minutos pra dar agua nos poços',
    DefaultValue = 30,
    Description = 'Este é o intervalo de minutos no qual os poços ganharão entre 5 e 10 de água.',
    Examples = '5, 10, 15, 20, 25, 45, 60 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Minutos pra dar agua nos poços', 30)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 1) then
            exports['stoneage_settings']:setConfig('Minutos pra dar agua nos poços', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 5 minutos)', 'error')
        end
        return false
    end,
}, {
    Name = 'Horas a cada decay',
    DefaultValue = 3,
    Description = 'A quantidade de horas de intervalo a cada decay.',
    Examples = '3, 5, 7 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('horas decay', 3)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if (number >= 1) then
            exports['stoneage_settings']:setConfig('horas decay', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração. (minimo: 1 hora)', 'error')
        end
        return false
    end,
}, {
    Name = 'Dano em cada decay',
    DefaultValue = 150,
    Description = 'A quantidade de dano que cada objeto vai levar a cada decay.',
    Examples = '100, 200, 500 (insira apenas o número no texto)',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Dano Decay', 150)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue)
        if (number) then
            exports['stoneage_settings']:setConfig('Dano Decay', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            return number
        else
            NOTIFICATION:CreateNotification(player, 'Você não inseriu um número válido para esta configuração.', 'error')
        end
        return false
    end,
}, {
    Name = 'Limite de jogadores',
    DefaultValue = getMaxPlayers(),
    Description = 'A quantidade máxima de players que o servidor deve suportar',
    Examples = '80, 85, 100',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('MaxPlayers', 30)
    end,
    UpdateFunction = function(player, newValue)
        if setMaxPlayers(newValue) then
            exports['stoneage_settings']:setConfig('MaxPlayers', newValue)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
        else
            NOTIFICATION:CreateNotification(player, 'Falha ao mudar configuração.', 'error')
        end
        return newValue
    end,
}, {
    Name = 'Slots Reservados para VIP',
    DefaultValue = getMaxPlayers(),
    Description = 'A quantidade de slots que fica disponivel apenas para jogadores VIP.',
    Examples = '10, 20, 25',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Slots VIP', 10)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if number then
            exports['stoneage_settings']:setConfig('Slots VIP', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
        else
            NOTIFICATION:CreateNotification(player, 'Falha ao mudar configuração.', 'error')
        end
        return newValue
    end,
}, {
    Name = 'Avisos kick ping',
    DefaultValue = 5,
    Description = 'A quantidade de avisos que o jogador recebe até ser expulso por ping alto (1 aviso a cada segundo)',
    Examples = '5',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('AvisosPing', 5)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if number then
            exports['stoneage_settings']:setConfig('AvisosPing', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
        else
            NOTIFICATION:CreateNotification(player, 'Falha ao mudar configuração.', 'error')
        end
        return newValue
    end,
}, {
    Name = 'Minimo ping',
    DefaultValue = 500,
    Description = 'A média de ping que o jogador deve ter nos ultimos (Avisos kick ping) segundos.',
    Examples = '500, 3000',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('LimitPing', 500)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if number then
            exports['stoneage_settings']:setConfig('LimitPing', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
        else
            NOTIFICATION:CreateNotification(player, 'Falha ao mudar configuração.', 'error')
        end
        return newValue
    end,
}, {
    Name = 'Avisos Packet loss',
    DefaultValue = 5,
    Description = 'A quantidade de avisos que o jogador recebe até ser expulso por packetloss alto (1 aviso a cada segundo)',
    Examples = '5',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('AvisosLoss', 5)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if number then
            exports['stoneage_settings']:setConfig('AvisosLoss', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
        else
            NOTIFICATION:CreateNotification(player, 'Falha ao mudar configuração.', 'error')
        end
        return newValue
    end,
}, {
    Name = 'Minimo Packetloss',
    DefaultValue = 5,
    Description = 'A média de packetloss que o jogador deve ter nos ultimos (Avisos Packet loss) segundos.',
    Examples = '500, 3000',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('LimitLoss', 5)
    end,
    UpdateFunction = function(player, newValue)
        local number = tonumber(newValue) or 0
        if number then
            exports['stoneage_settings']:setConfig('LimitLoss', number)
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
        else
            NOTIFICATION:CreateNotification(player, 'Falha ao mudar configuração.', 'error')
        end
        return newValue
    end,
}, {
    Name = 'Modo de jogo',
    DefaultValue = 'Your server name',
    Description = 'O "Modo de Jogo" que aparecerá na lista de servidores do MTA.',
    Examples = 'Your server name',
    GetCurrentValue = function()
        return exports['stoneage_settings']:getConfig('Modo de jogo', 'Your server name [Rust]')
    end,
    UpdateFunction = function(player, newValue)
        if setGameType(newValue) then
            NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
            exports['stoneage_settings']:setConfig('Modo de jogo', newValue)
        else
            NOTIFICATION:CreateNotification(player, 'Falha ao mudar configuração.', 'error')
        end
        return newValue
    end,
}, {
    Name = 'Senha do servidor',
    DefaultValue = 'stg0306',
    Description = 'Senha do servidor',
    Examples = 'stg0306, 221, stg, stoneage123',
    GetCurrentValue = function()
        return getServerPassword() or ''
    end,
    UpdateFunction = function(player, newValue)
        setServerPassword(newValue)
        NOTIFICATION:CreateNotification(player, 'Configuração alterada com sucesso.', 'info')
        return newValue
    end,
}}

GenerateConfigList = function()
    local config = {}
    for k, v in ipairs(Admin.Config.DefaultConfigs) do
        v.CurrentValue = v.GetCurrentValue()
        table.insert(config, v)
    end
    return config
end

RequestConfigList = function(forced, sync)
    if forced then
        Admin.Config.Cache = GenerateConfigList()
    end
    if sync then
        for k in pairs(Admin.OnlineStaffs) do
            triggerClientEvent(k, 'receiveConfigList', k, Admin.Config.Cache)
        end
    end
end
addEvent('requestConfigList', true)
addEventHandler('requestConfigList', root, RequestConfigList)

ChangeSettingValue = function(settingName, newValue)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    for k, v in ipairs(Admin.Config.DefaultConfigs) do
        if (v.Name == settingName) then
            if (type(v.UpdateFunction) == 'function') then
                local oldValue = v.GetCurrentValue()
                local result = v.UpdateFunction(source, newValue)
                if result then
                    local embeds = {{
                        ['description'] = (':gear: O staff %s acabou de mudar a configuração ``%s (%s)`` para o valor ``%s``'):format(
                            GetAdminName(source), settingName, oldValue, result),
                        ['color'] = 0xFF0000,
                    }}
                    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
                else
                    local embeds = {{
                        ['description'] = (':no_entry_sign: Erro: O staff %s tentou trocar a configuração ``%s (%s)`` para o valor ``%s`` (valor inválido)'):format(
                            GetAdminName(source), settingName, oldValue, newValue),
                        ['color'] = 0xFF0000,
                    }}
                    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
                end
                RequestConfigList(true, true)
            else
                NOTIFICATION:CreateNotification(source, 'Falha interna (configuração sem função de update)', 'error')
            end
            return
        end
    end
    NOTIFICATION:CreateNotification(source, 'Falha interna (configuração não encontrada)', 'error')
end
addEvent('changeSettingValue', true)
addEventHandler('changeSettingValue', root, ChangeSettingValue)
