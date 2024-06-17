local Widget = {
    ButtonsVIP = {'Editar', 'Remover', 'Adicionar'},
    Vips = false,
    VipCache = {},
}

local searchTimer

Widget.Init = function()
    local w, h = 800 - 70, 600

    Widget.Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {35, 35, 35, 200},
    })
    guiSetVisible(Widget.Container, false)

    Widget.Header = UI:CreateTextWithBG(0, 0, w, 60, 'VIPS', false, Widget.Container, {
        bgColor = {25, 25, 25, 250},
    })

    Widget.VIPEdit = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, Widget.Container)
    addEventHandler('onClientGUIChanged', Widget.VIPEdit, function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(Widget.SearchVIP, 100, 1, guiGetText(source))
    end)
    Widget.VIPRefresh = UI:CreateButton(315, 90, 30, 30, '⟲', false, Widget.Container)
    addEventHandler('onClientGUIClick', Widget.VIPRefresh, function()
        triggerServerEvent('requestVIPList', localPlayer, true, true)
    end, false)

    Widget.VIPList = UI:CreateList(45, 120, 300, 440, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('ui:onSelectListItem', Widget.VIPList, Widget.SelectVIPInList)

    local bg = UI:CreateRectangle(385, 90, 300, 160, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    local scrollPane = UI:CreateScrollPane(5, 0, 295, 160, false, bg, {})
    Widget.VIPInfo = UI:CreateLabel(0, 5, 280, 600, 'teste', scrollPane, 'left', 'top')

    createButtons('VIP', Widget.ButtonsVIP, Widget.Container, 385, 285, 300, 275, 95, 38)
end

Widget.Toggle = function(state)
    if state then
        if (not Widget.Vips) then
            triggerServerEvent('requestVIPList', localPlayer, false, true)
        end
        Widget.SelectVIPInList(false)
    end
    guiSetVisible(Widget.Container, state)
    CloseVIPWindow()
end

Widget.SearchVIP = function(filter, onStart)
    filter = filter and (filter:gsub('%[', ''):gsub('%]', ''))
    Widget.SelectVIPInList(false)
    Widget.VipCache = {}
    UI:ResetListItems(Widget.VIPList)

    local added = 0
    for k, v in ipairs(Widget.Vips) do
        local Name = v['Name']
        if (utf8.len(Name) > 10) then
            Name = utf8.sub(Name, 1, 10) .. '...'
        end
        local Serial = utf8.sub(v.Serial, 1, 5) .. '...'

        local str = ('%s [%s]'):format(Name, Serial)

        if (v['RemainingTime'] >= 0) then
            str = str .. (' (%s dias)'):format(v['RemainingTime'])
            if (v['PausedTime'] > 0) then
                str = str .. (' - PAUSADO %i dias'):format(v.PausedTime)
            end
        else
            str = str .. ' (∞)'
        end

        if filter and (str:lower():find(filter:lower())) or (not filter) then
            UI:addListItem(Widget.VIPList, str)
            Widget.VipCache[str] = k
            added = added + 1
        end
    end

    guiSetText(Widget.Header, ('VIPS (%s)'):format(added))

    if (not onStart) then
        guiFocus(Widget.VIPEdit)
    end
end

addEvent('receiveVIPList', true)
addEventHandler('receiveVIPList', localPlayer, function(list)
    Widget.Vips = list
    if (guiGetText(Widget.VIPEdit) == '') then
        Widget.SearchVIP(false, true)
    else
        guiSetText(Widget.VIPEdit, '')
    end
    Widget.SelectVIPInList(false)
end)

Widget.SelectVIPInList = function(string)
    local VIP = Widget.VipCache[string] and Widget.Vips[Widget.VipCache[string]]
    if VIP then
        local remainingTime = 'Permanente'
        if (VIP['RemainingTime'] >= 0) then
            remainingTime = ('%s dias'):format(VIP['RemainingTime'])
        end

        local activation = getRealTime(VIP['ActivationTick'])

        local arr = {{'Description', VIP['Description']}, {'Nome', VIP['Name']}, {'Serial', VIP['Serial']}, {'Admin', VIP['Admin']},
                     {'Tempo restante', remainingTime}, {'Tempo de pausa', VIP['PausedTime']},
                     {'Data de ativação', ('%02d/%02d/%04d'):format(activation.monthday, activation.month + 1, activation.year + 1900)}}

        local str = '\n'
        for k, v in ipairs(arr) do
            str = str .. ('%s: %s\n\n'):format(v[1], v[2] or 'Não detectado')
        end

        guiSetText(Widget.VIPInfo, str)
    else
        guiSetText(Widget.VIPInfo, '\nSelecione um VIP na lista pare ter informações sobre ele')
    end
end

CreateVIPWindow = function(header, serial, time, descricao, tempoPausado, callback, canEditSerial)
    local w, h = 400, 350
    GUI['VIPWindow'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, header, false, false, true, {
        bgColor = {25, 25, 25, 250},
    })
    guiSetProperty(GUI['VIPWindow'], 'AlwaysOnTop', 'True')
    addEventHandler('onCustomWindowClose', GUI['VIPWindow'], function()
        CloseVIPWindow()
    end)

    UI:CreateLabel((w - 300) / 2, 50, 300, 20, 'Serial', GUI['VIPWindow'], 'left')
    local Serial = UI:CreateEditBox((w - 300) / 2, 70, 300, 20, 'Serial', false, GUI['VIPWindow'], {})
    if serial then
        guiSetText(Serial, serial)
        -- if not canEditSerial then
        guiEditSetReadOnly(Serial, true)
        -- end
    end

    UI:CreateLabel((w - 300) / 2, 100, 300, 20, 'Descrição', GUI['VIPWindow'], 'left')
    local Description = UI:CreateEditBox((w - 300) / 2, 120, 300, 20, 'Insira a descrição aqui', false, GUI['VIPWindow'], {})
    if descricao then
        guiSetText(Description, descricao)
    end

    UI:CreateLabel((w - 300) / 2, 150, 300, 20, 'Tempo', GUI['VIPWindow'], 'left')
    local TempoQuantity = UI:CreateEditBox((w - 300) / 2, 170, 149, 20, 'Tempo', false, GUI['VIPWindow'], {})
    guiSetText(TempoQuantity, '0')

    local TempoType = UI:CreateComboBox((w - 300) / 2 + 150, 170, 149, 100, 'Selecione', false, GUI['VIPWindow'], {
        headerColor = {30, 30, 30, 250},
    })

    UI:addComboBoxItem(TempoType, 'Dias')
    UI:addComboBoxItem(TempoType, 'Meses')
    UI:addComboBoxItem(TempoType, 'Permanente')

    UI:CreateLabel((w - 300) / 2, 200, 300, 20, 'Dias Pausado', GUI['VIPWindow'], 'left')
    local PausedQuantity = UI:CreateEditBox((w - 300) / 2, 220, 149, 20, 'Tempo', false, GUI['VIPWindow'], {})
    if tempoPausado then
        guiSetText(PausedQuantity, tempoPausado)
    else
        guiSetText(PausedQuantity, '0')
    end

    local confirm = UI:CreateButton((w - 300) / 2, h - 70, 300, 40, 'Confirmar', false, GUI['VIPWindow'])
    addEventHandler('onClientGUIClick', confirm, function()
        if type(callback) == 'function' then
            local _, tempoType = UI:getComboBoxSelectedItem(TempoType)
            local descricao = guiGetText(Description)
            local serial = guiGetText(Serial)
            local tempo = tonumber(guiGetText(TempoQuantity))
            local tempoPausado = tonumber(guiGetText(PausedQuantity))

            if tempoType then
                if (tempo and tempo > 0) then
                    if tempoPausado then
                        if (utf8.len(descricao) > 3) then
                            if (utf8.len(serial) >= 32) then
                                callback(serial, descricao, tempo, tempoType, tempoPausado)
                                CloseVIPWindow()
                            else
                                NOTIFICATION:CreateNotification('O serial deve possuir no minimo 32 caracteres.', 'error')
                            end
                        else
                            NOTIFICATION:CreateNotification('A descrição deve possuir no minimo 3 caracteres.', 'error')
                        end

                    else
                        NOTIFICATION:CreateNotification('Você não inseriu um tempo pausado válido.', 'error')
                    end
                else
                    NOTIFICATION:CreateNotification('Você não inseriu um tempo válido.', 'error')
                end
            else
                NOTIFICATION:CreateNotification('Você não inseriu um tipo de tempo válido.', 'error')
            end
        else
            NOTIFICATION:CreateNotification('Callback não definida.', 'error')
        end
    end, false)
end

CloseVIPWindow = function()
    if isElement(GUI['VIPWindow']) then
        destroyElement(GUI['VIPWindow'])
    end
end

Widget.OnClick = function(button)
    local selectedString = UI:getSelectedListItem(Widget.VIPList)
    local VIP = selectedString and Widget.VipCache[selectedString] and Widget.Vips[Widget.VipCache[selectedString]]
    if (button == 'Remover') then
        if VIP then
            ShowConfirmWindow('Remover VIP', 'Você realmente deseja remover o VIP\n' .. selectedString .. '\n?', function()
                triggerServerEvent('removeVIP', localPlayer, VIP.Serial)
                NOTIFICATION:CreateNotification('Solicitação enviada com sucesso.', 'info')
            end)
        else
            NOTIFICATION:CreateNotification('Selecione um VIP na lista.', 'error')
        end

    elseif (button == 'Editar') then
        if VIP then
            CreateVIPWindow('Editar VIP\n' .. selectedString, VIP.Serial, VIP.RemainingTime, VIP.Description, VIP.PausedTime,
                            function(serial, descricao, tempo, tempoType, tempoPausado)
                NOTIFICATION:CreateNotification('Solicitação de edição de VIP enviada.', 'info')
                triggerServerEvent('editVIP', localPlayer, serial, descricao, tempo, tempoType, tempoPausado)
            end, true)
        else
            NOTIFICATION:CreateNotification('Selecione um VIP na lista.', 'error')
        end

    elseif (button == 'Adicionar') then
        CreateVIPWindow('Adicionar VIP', nil, nil, nil, nil, function(serial, descricao, tempo, tempoType, tempoPausado)
            NOTIFICATION:CreateNotification('Solicitação de criação de VIP enviada.', 'info')
            triggerServerEvent('addVIP', localPlayer, serial, descricao, tempo, tempoType, tempoPausado)
        end)

    end
end

Admin.Widgets['VIP'] = Widget
