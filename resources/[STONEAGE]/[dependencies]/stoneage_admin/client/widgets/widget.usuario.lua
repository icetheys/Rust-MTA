local Widget = {
    ButtonsUsuario = {'Teleporte', 'Puxar', '(Des)Freezar', 'Spectar', 'Inventário', 'Dar VIP', '*Mutar', '*Advertências', 'Kickar', 'Banir',
                      'Enviar notificação'},
    Cache = false,
}

local searchTimer

Widget.Init = function()
    local w, h = 800 - 70, 600

    Widget.Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {35, 35, 35, 200},
    })

    guiSetVisible(Widget.Container, false)

    Widget.Header = UI:CreateTextWithBG(0, 0, w, 60, 'Jogadores', false, Widget.Container, {
        bgColor = {25, 25, 25, 250},
    })

    Widget.UsuarioEdit = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, Widget.Container)
    addEventHandler('onClientGUIChanged', Widget.UsuarioEdit, function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(Widget.SearchUsuario, 100, 1, guiGetText(source))
    end)

    Widget.UsuarioRefresh = UI:CreateButton(315, 90, 30, 30, '⟲', false, Widget.Container)
    addEventHandler('onClientGUIClick', Widget.UsuarioRefresh, function()
        if (guiGetText(Widget.UsuarioEdit) == '') then
            Widget.SearchUsuario(false)
        else
            guiSetText(Widget.UsuarioEdit, '')
        end
        Widget.SelectUsuarioInList(false)
    end, false)

    Widget.UsuarioList = UI:CreateList(45, 120, 300, 440, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('ui:onSelectListItem', Widget.UsuarioList, Widget.SelectUsuarioInList)

    local bg = UI:CreateRectangle(385, 90, 300, 160, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    local scrollPane = UI:CreateScrollPane(5, 0, 295, 160, false, bg, {})
    Widget.UsuarioInfo = UI:CreateLabel(0, 5, 280, 600, 'teste', scrollPane, 'left', 'top')

    createButtons('Usuario', Widget.ButtonsUsuario, Widget.Container, 385, 285, 300, 275, 95, 38)
end

Widget.Toggle = function(state)
    if state then
        if (not Widget.Cache) then
            Widget.SearchUsuario(false, true)
        end
    end
    Widget.SelectUsuarioInList(false)
    guiSetVisible(Widget.Container, state)
end

Widget.SearchUsuario = function(filter, onStart)
    filter = filter and (filter:gsub('%[', ''):gsub('%]', ''))

    UI:ResetListItems(Widget.UsuarioList)
    Widget.Cache = true
    local added = 0
    for k, v in ipairs(getElementsByType('player')) do
        if filter and (getPlayerName(v):lower():find(filter:lower())) or (not filter) then
            UI:addListItem(Widget.UsuarioList, getPlayerName(v))
            added = added + 1
        end
    end
    guiSetText(Widget.Header, ('Jogadores (%i)'):format(added))

    if (not onStart) then
        guiFocus(Widget.UsuarioEdit)
    end
end

Widget.SelectUsuarioInList = function(string)
    if string then
        local player = getPlayerFromName(string)
        if player then
            local x, y, z = getElementPosition(player)

            local arr = {
                {'Nome', string}, 
                {'Grupo', getElementData(player, 'Group')},
                {'Localização', ('%s (%s)'):format(getZoneName(x, y, z), getZoneName(x, y, z, true))}, 
                {'Ping', getPlayerPing(player)},
                {'Serial', getElementData(player, 'account') or 'Sem conta'},
			}

            local str = ''
            for k, v in ipairs(arr) do
                str = str .. ('%s: %s\n\n'):format(v[1], v[2] or 'Não detectado.')
            end

            guiSetText(Widget.UsuarioInfo, str)

        else
            guiSetText(Widget.UsuarioInfo, 'Jogador não encontrado.')
        end
    else
        guiSetText(Widget.UsuarioInfo, 'Selecione um Usuario na lista pare ter informações sobre ele')
    end
end

Widget.OnClick = function(action)
    local selectedString = UI:getSelectedListItem(Widget.UsuarioList)
    local player = selectedString and getPlayerFromName(selectedString)

    if (not player) then
        NOTIFICATION:CreateNotification('Este jogador não foi encontrado.', 'error')
        return
    end

    if (action == 'Banir') then
        local callBack = function(name, serial, reason, tempo, tempoType)
            triggerServerEvent('_addBan', localPlayer, name, serial, reason, tempo, tempoType)
            NOTIFICATION:CreateNotification('Enviada solicitação para adicionar banimento.', 'info')
        end
        CreateBanWindow('Adicionar Banimento', getPlayerName(player), getElementData(player, 'account') or 'error', nil, nil, callBack)

    elseif (action == 'Dar VIP') then
		local account = getElementData(player, 'account')
		if account then
			CreateVIPWindow('Dar VIP', account, nil, nil, nil, function(serial, descricao, tempo, tempoType, tempoPausado)
				NOTIFICATION:CreateNotification('Solicitação de criação de VIP enviada.', 'info')
				triggerServerEvent('addVIP', localPlayer, serial, descricao, tempo, tempoType, tempoPausado)
			end)
		else
			NOTIFICATION:CreateNotification('Jogador ainda não está logado.', 'error')
		end
        

    elseif (action == 'Teleporte') then
        triggerServerEvent('warpTo', localPlayer, localPlayer, player)

    elseif (action == 'Puxar') then
        triggerServerEvent('warpTo', localPlayer, player, localPlayer)

    elseif (action == '(Des)Freezar') then
        triggerServerEvent('freezeUnfreeze', localPlayer, player)
    
    elseif (action == 'Inventário') then
        EditInventory.Toggle(true, player)

    elseif (action == 'Spectar') then
        ToggleSpectate(true, player)
        ToggleAdminWindow(false)

    elseif (action == 'Kickar') then
        local callBack = function(typedText)
            triggerServerEvent('_kickPlayer', localPlayer, player, (utf8.len(typedText) > 0 and typedText))
        end
        ShowInputWindow('Expulsar jogador', ('Insira abaixo o motivo no qual você deseja kickar o jogador %s'):format(getPlayerName(player)),
                        callBack)

    elseif (action == 'Enviar notificação') then
        local callBack = function(message)
            if (message:len() > 0) then
                local callBack = function(tempo)
                    local secs = tonumber(tempo) or 0
                    if (secs >= 5) then
                        triggerServerEvent('sendNotification', localPlayer, player, message, secs * 1000)
                    else
                        NOTIFICATION:CreateNotification('O tempo deve ser maior ou igual a 5 segundos', 'error')
                    end
                end
                ShowInputWindow('Enviar notificação',
                                ('Durante quantos segundos a mensagem\n"%s"\nficará ativa para %s?.'):format(message, getPlayerName(player)),
                                callBack)
            else
                NOTIFICATION:CreateNotification('Você não inseriu uma mensagem válida.', 'error')
            end
        end
        ShowInputWindow('Enviar notificação', ('Insira abaixo a mensagem que deseja enviar para o jogador %s'):format(getPlayerName(player)),
                        callBack)

    end
end

Admin.Widgets['Usuario'] = Widget
