local Widget = {
    Buttons = {'Spawnar airdrop', 'Notificação\nglobal', 'Wipar veículos', 'Wipar farms',
               'Executar decay manual', 'Reparar objetos', 'Forçar salvamento de logs', 'Abastecer Poços',
               'Limpar Chat', 'Resetar Objetos', 'Resetar Conta', 'Checar Serial', 'Setar Hora', 'Pegar Itens',
               'Adicionar dia VIP', 'Abastecer Postos Gasolina', 'Spawnar Heli', 'Destruir Heli', 'Spawnar Navio', 'Destruir Navio', 'Expulsar jogadores','(Des)Bloquear chat', '(Des)ativar animação trocar arma'},
}

Widget.Init = function()
    local w, h = 800 - 70, 600

    local Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {0, 0, 0, 0},
    })

    guiSetVisible(Container, false)

    UI:CreateTextWithBG(0, 0, w, 60, 'Home', false, Container, {
        bgColor = {25, 25, 25, 250},
    })

    createButtons('Home', Widget.Buttons, Container, 0, 60, w, h - 120, 101, 50)

    local state = exports['stoneage_settings']:getConfig('admin:Nickname Aleatorio', false)
    if state then
        triggerServerEvent('setRandomNick', localPlayer, state)
    end
    local NickAleatorio = UI:CreateCheckbox(5, h - 55, 20, false, state, Container, {
        bgColor = {20, 20, 20, 250},
    })
    UI:CreateLabel(25, h - 55, 115, 20, 'Nickname aleatório', Container)
    addEventHandler('onCheckBoxChangeState', NickAleatorio, function(state)
        exports['stoneage_settings']:setConfig('admin:Nickname Aleatorio', state)
        triggerServerEvent('setRandomNick', localPlayer, state)
    end)

    local state = exports['stoneage_settings']:getConfig('admin:Nickname Aleatorio', false)
    setElementData(localPlayer, 'distanciaExtraNametag', state, false)
    local DistanciaExtra = UI:CreateCheckbox(170, h - 55, 20, false, state, Container, {
        bgColor = {20, 20, 20, 250},
    })
    UI:CreateLabel(190, h - 55, 150, 20, 'Distância extra nametag', Container)
    addEventHandler('onCheckBoxChangeState', DistanciaExtra, function(state)
        exports['stoneage_settings']:setConfig('admin:Distância extra nametag', state)
        setElementData(localPlayer, 'distanciaExtraNametag', state, false)
    end)

    local state = exports['stoneage_settings']:getConfig('admin:Anonimato', false)
    setElementData(localPlayer, 'anonimato', state)
    local DistanciaExtra = UI:CreateCheckbox(365, h - 55, 20, false, state, Container, {
        bgColor = {20, 20, 20, 250},
    })
    UI:CreateLabel(385, h - 55, 70, 20, 'Anonimato', Container)
    addEventHandler('onCheckBoxChangeState', DistanciaExtra, function(state)
        exports['stoneage_settings']:setConfig('admin:Anonimato', state)
        setElementData(localPlayer, 'anonimato', state)
    end)

    local state = exports['stoneage_settings']:getConfig('admin:drawNearPlayers', false)
    local blipsPlayers = UI:CreateCheckbox(475, h - 55, 20, false, state, Container, {
        bgColor = {20, 20, 20, 250},
    })
    UI:CreateLabel(495, h - 55, 80, 20, 'Blips players', Container)
    addEventHandler('onCheckBoxChangeState', blipsPlayers, function(state)
        exports['stoneage_settings']:setConfig('admin:drawNearPlayers', state)
        CreateBlipToNearPlayers()
    end)

    local state = exports['stoneage_settings']:getConfig('admin:drawNearVehicles', false)
    local blipsVeiculos = UI:CreateCheckbox(600, h - 55, 20, false, state, Container, {
        bgColor = {20, 20, 20, 250},
    })
    UI:CreateLabel(625, h - 55, 80, 20, 'Blips Veiculos', Container)
    addEventHandler('onCheckBoxChangeState', blipsVeiculos, function(state)
        exports['stoneage_settings']:setConfig('admin:drawNearVehicles', state)
        CreateBlipToNearVehicles()
    end)

    local state = false
    setElementData(localPlayer, 'admin:destruirNoTiro', state)

    local NickAleatorio = UI:CreateCheckbox(5, h - 25, 20, false, state, Container, {
        bgColor = {20, 20, 20, 250},
    })
    
    UI:CreateLabel(25, h - 25, 140, 20, 'Destruir objetos no tiro', Container)
    addEventHandler('onCheckBoxChangeState', NickAleatorio, function(state)
        exports['stoneage_settings']:setConfig('admin:Destruir no tiro', state)
        setElementData(localPlayer, 'admin:destruirNoTiro', state)
    end)

    Widget.Container = Container
end

Widget.Toggle = function(state)
    guiSetVisible(Widget.Container, state)
end

Widget.OnClick = function(action)
    if (action == 'Expulsar jogadores') then
        local callBack = function(typedText)
            triggerServerEvent('kickAll', localPlayer, (utf8.len(typedText) > 0 and typedText))
        end
        ShowInputWindow('Expulsar jogadores',
            'Insira abaixo o motivo no qual você que deseja expulsar todos os jogadores', callBack)

    elseif (action == 'Spawnar airdrop') then
        local callBack = function()
            triggerServerEvent('spawnAirdrop', localPlayer)
        end
        ShowConfirmWindow('Chamar Airdrop',
            'Você realmente deseja enviar um novo aidrop?\nObs: isso irá cancelar o atual caso ela exista)', callBack)

    elseif (action == 'Notificação\nglobal') then
        local callBack = function(message)
            if (message:len() > 0) then
                local callBack = function(tempo)
                    local secs = tonumber(tempo) or 0
                    if (secs >= 5) then
                        triggerServerEvent('sendNotification', localPlayer, root, message, secs * 1000)
                    else
                        NOTIFICATION:CreateNotification('O tempo deve ser maior ou igual a 5 segundos', 'error')
                    end
                end
                ShowInputWindow('Notificação global',
                    ('Durante quantos segundos a mensagem\n"%s"\nficará ativa para os jogadores?.'):format(message),
                    callBack)
            else
                NOTIFICATION:CreateNotification('Você não inseriu uma mensagem válida.', 'error')
            end
        end
        ShowInputWindow('Notificação global', 'Insira abaixo a mensagem que deseja enviar para todos os jogadores.',
            callBack)

    elseif (action == 'Wipar veículos') then
        local callBack = function()
            triggerServerEvent('wipeVehicles', localPlayer)
        end
        ShowConfirmWindow('Resetar veículos',
            'Você realmente deseja resetar todos os veículos?\nObs: esta ação é irreversivel.', callBack)

    elseif (action == 'Wipar farms') then
        local callBack = function()
            triggerServerEvent('wipeFarms', localPlayer)
        end
        ShowConfirmWindow('Resetar Farms',
            'Você realmente deseja resetar todos os objetos de farm (árvores, pedras, sulphur, minerios, em geral)?',
            callBack)

    elseif (action == 'Executar decay manual') then
        local callBack = function()
            triggerServerEvent('runDecay', localPlayer)
        end
        ShowConfirmWindow('Executar decay', 'Você realmente deseja executar o decay agora?', callBack)

    elseif (action == 'Reparar objetos') then
        local callBack = function()
            triggerServerEvent('runObjectsRepair', localPlayer)
        end
        ShowConfirmWindow('Reparar objetos', 'Você realmente deseja reparar todos os objetos do servidor?', callBack)

    elseif (action == 'Forçar salvamento de logs') then
        local callBack = function()
            triggerServerEvent('saveLogsToDisk', localPlayer)
        end
        ShowConfirmWindow('Salvar Logs',
            'Você realmente deseja salvar os logs no disco forçadamente?\nObs: esse processo é executado a cada 2m, e sua execução forçada pode causar lag.',
            callBack)

    elseif (action == 'Abastecer Poços') then
        triggerServerEvent('fillPocos', localPlayer)

    elseif (action == 'Limpar Chat') then
        triggerServerEvent('clearChat', localPlayer)

    elseif (action == 'Resetar Objetos') then
        local callBack = function(message)
            if (message:len() >= 32) then
                triggerServerEvent('resetSerialObjects', localPlayer, message)
            else
                NOTIFICATION:CreateNotification('Você não inseriu um serial válido.', 'error')
            end
        end
        ShowInputWindow('Resetar Objetos',
            'Insira abaixo o serial no qual você deseja remover todos os objetos do jogo.', callBack)

    elseif (action == 'Resetar Conta') then
        local callBack = function(message)
            if (message:len() >= 32) then
                triggerServerEvent('resetAccount', localPlayer, message)
            else
                NOTIFICATION:CreateNotification('Você não inseriu um serial válido.', 'error')
            end
        end
        ShowInputWindow('Resetar Conta', 'Insira abaixo o serial da conta que você quer deletar.', callBack)

    elseif (action == 'Checar Serial') then
        local callBack = function(message)
            if (message:len() >= 32) then
                triggerServerEvent('checkAccount', localPlayer, message)
            else
                NOTIFICATION:CreateNotification('Você não inseriu um serial válido.', 'error')
            end
        end
        ShowInputWindow('Checar Serial', 'Insira abaixo o serial da conta que você quer ter informações sobre.',
            callBack)

    elseif (action == 'Setar Hora') then
        local callBack = function(message)
            local hour = tonumber(message)
            if hour and (hour >= 0) and (hour <= 23) then
                triggerServerEvent('setHour', localPlayer, hour)
            else
                NOTIFICATION:CreateNotification('A hora deve ser um número inteiro entre 0 e 23.', 'error')
            end
        end
        ShowInputWindow('Checar Serial', 'Insira abaixo o serial da conta que você quer ter informações sobre.',
            callBack)

    elseif (action == 'Pegar Itens') then
        EditInventory.Toggle(true, localPlayer)

    elseif (action == 'Adicionar dia VIP') then
        local callBack = function(message)
            local days = tonumber(message)
            if days then
                triggerServerEvent('addVIPDays', localPlayer, days)
            else
                NOTIFICATION:CreateNotification('A hora deve ser um número inteiro entre 0 e 23.', 'error')
            end
        end
        ShowInputWindow('Adicionar dias VIP', 'Insira abaixo a quantidade de dias que você quer adicionar para todos os VIPS.\n(Insira um número negativo caso queira diminuir os dias)',
            callBack)

    elseif (action == 'Abastecer Postos Gasolina') then
        local callBack = function(message)
            triggerServerEvent('refuelGasStations', localPlayer)
        end
        ShowConfirmWindow('Abastecer Postos Gasolina', 'Você realmente deseja abastecer todos os postos de gasolina?', callBack)
    
    elseif (action == 'Spawnar Heli') then
        local callBack = function(message)
            triggerServerEvent('spawnHelicopter', localPlayer)
        end
        ShowConfirmWindow('Spawnar Heli', 'Você tem certeza de que deseja spawnar o helicoptero atirador?\nIsso irá destruir o atual caso exista.', callBack)
    
    elseif (action == '(Des)Bloquear chat') then
        local callBack = function(message)
            triggerServerEvent('toggleChatState', localPlayer)
        end
        ShowConfirmWindow('Bloquear Chat', 'Você tem certeza de que deseja alterar o status de bloqueio do chat?', callBack)
    
    elseif (action == '(Des)ativar animação trocar arma') then
        local callBack = function(message)
            triggerServerEvent('weaponAnim', localPlayer)
        end
        ShowConfirmWindow('Confirmação', 'Você tem certeza de que deseja alterar o status da animação ao trocar de arma?', callBack)
    
    elseif (action == 'Destruir Heli') then
        local callBack = function(message)
            triggerServerEvent('destroyHelicopter', localPlayer)
        end
        ShowConfirmWindow('Destruir Heli', 'Você tem certeza de que deseja destruir o helicoptero atirador?', callBack)
    
    elseif (action == 'Spawnar Navio') then
        local callBack = function(message)
            triggerServerEvent('spawnShip', localPlayer)
        end
        ShowConfirmWindow('Spawnar Navio', 'Você tem certeza de que deseja spawnar o navio?\nIsso irá destruir o atual caso exista.', callBack)
    
    elseif (action == 'Destruir Navio') then
        local callBack = function(message)
            triggerServerEvent('destroyShip', localPlayer)
        end
        ShowConfirmWindow('Destruir Navio', 'Você tem certeza de que deseja destruir o navio?', callBack)
    
    end
end

Admin.Widgets['Home'] = Widget
