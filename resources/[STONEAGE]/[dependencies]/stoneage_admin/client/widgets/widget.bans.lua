local Widget = {
    ButtonsBans = {'Remover', 'Editar', 'Adicionar'},
    Bans = false,
    BansCache = {},
}

local searchTimer

Widget.Init = function()
    local w, h = 800 - 70, 600

    Widget.Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {35, 35, 35, 200},
    })

    guiSetVisible(Widget.Container, false)

    Widget.Header = UI:CreateTextWithBG(0, 0, w, 60, 'Bans', false, Widget.Container, {
        bgColor = {25, 25, 25, 250},
    })

    Widget.BansEdit = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, Widget.Container)
    addEventHandler('onClientGUIChanged', Widget.BansEdit, function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(Widget.SearchBans, 100, 1, guiGetText(source))
    end)

    Widget.BansRefresh = UI:CreateButton(315, 90, 30, 30, '⟲', false, Widget.Container)
    addEventHandler('onClientGUIClick', Widget.BansRefresh, function()
        triggerServerEvent('requestBanList', localPlayer, true, true)
        guiSetText(Widget.BansEdit, '')
    end, false)

    Widget.BansList = UI:CreateList(45, 120, 300, 440, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('ui:onSelectListItem', Widget.BansList, Widget.SelectBansInList)

    local bg = UI:CreateRectangle(385, 90, 300, 160, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    local scrollPane = UI:CreateScrollPane(5, 0, 295, 160, false, bg, {})
    Widget.BansInfo = UI:CreateLabel(0, 5, 280, 600, 'teste', scrollPane, 'left', 'top')

    createButtons('Bans', Widget.ButtonsBans, Widget.Container, 385, 285, 300, 275, 95, 38)
end

Widget.Toggle = function(state)
    if state then
        if (not Widget.Bans) then
            triggerServerEvent('requestBanList', localPlayer, false, true)
        end
        Widget.SelectBansInList(false)
    end
    guiSetVisible(Widget.Container, state)
    CloseBanWindow()
end

Widget.SearchBans = function(filter, onStart)
    filter = filter and (filter:gsub('%[', ''):gsub('%]', ''))

    UI:ResetListItems(Widget.BansList)
    Widget.BansCache = {}

    local added = 0

    for i = #Widget.Bans, 1, -1 do
        local ban = Widget.Bans[i]
        local Name = ban.Name or '*unknown'
        local Serial = ban.Serial or '*unknown'
        local Reason = ban.Reason or '*unknown'

        if Name:len() > 10 then
            Name = Name:sub(1, 10) .. '...'
        end
        if Reason:len() > 10 then
            Reason = Reason:sub(1, 10) .. '...'
        end

        local str = ('%s [%s...] - (%s)'):format(Name, Serial:sub(1, 10), Reason)
        if filter and (str:lower():find(filter:lower())) or (not filter) then
            UI:addListItem(Widget.BansList, str)
            added = added + 1
        end
        Widget.BansCache[str] = i
    end
    guiSetText(Widget.Header, ('Bans (%i)'):format(added))

    if (not onStart) then
        guiFocus(Widget.BansEdit)
    end
end

addEvent('receiveBanList', true)
addEventHandler('receiveBanList', localPlayer, function(list)
    Widget.Bans = list
    if (guiGetText(Widget.BansEdit) == '') then
        Widget.SearchBans(false, true)
    else
        guiSetText(Widget.BansEdit, '')
    end
    Widget.SelectBansInList(false)
end)

Widget.SelectBansInList = function(string)
    if string then
        local Ban = Widget.Bans[Widget.BansCache[string]]
        if Ban then
            local creation = getRealTime(Ban.Time)
            local unban = getRealTime(Ban.Unban)
            local banTime = ('(%02d/%02d/%04d)'):format(creation.monthday, creation.month + 1, creation.year + 1900)

            local unbanTime
            if (Ban.Unban == 0) then
                unbanTime = 'Permanente'
            else
                unbanTime = ('(%02d/%02d/%04d)'):format(unban.monthday, unban.month + 1, unban.year + 1900)
            end

            local arr = {{'Nome', Ban.Name}, {'Serial', Ban.Serial}, {'Motivo', Ban.Reason}, {'Data do banimento', banTime},
                         {'Data de desbanimento', unbanTime}, {'IP', Ban.IP}, {'Admin', Ban.Admin}}

            local str = '\n'
            for k, v in ipairs(arr) do
                str = str .. ('%s: %s\n\n'):format(v[1], v[2] or 'Não detectado.')
            end

            guiSetText(Widget.BansInfo, str)

        else
            guiSetText(Widget.BansInfo, '\nBanimento não encontrado.')
        end
    else
        guiSetText(Widget.BansInfo, '\nSelecione um banimento na lista pare ter informações sobre ele')
    end
end

CreateBanWindow = function(header, nome, serial, time, reason, callback)
    local w, h = 400, 400
    GUI['BanWindow'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, header, false, false, true, {
        bgColor = {25, 25, 25, 250},
    })
    guiSetProperty(GUI['BanWindow'], 'AlwaysOnTop', 'True')
    addEventHandler('onCustomWindowClose', GUI['BanWindow'], function()
        CloseBanWindow()
    end)

    UI:CreateLabel((w - 300) / 2, 50, 300, 20, 'Nome do banimento', GUI['BanWindow'], 'left')
    local Nome = UI:CreateEditBox((w - 300) / 2, 70, 300, 20, 'Nome', false, GUI['BanWindow'], {})
    if nome then
        guiSetText(Nome, nome)
    end

    UI:CreateLabel((w - 300) / 2, 100, 300, 20, 'Serial', GUI['BanWindow'], 'left')
    local Serial = UI:CreateEditBox((w - 300) / 2, 120, 300, 20, 'Serial', false, GUI['BanWindow'], {})
    if serial then
        guiSetText(Serial, serial)
        guiEditSetReadOnly(Serial, true)
    end

    UI:CreateLabel((w - 300) / 2, 150, 300, 20, 'Motivo', GUI['BanWindow'], 'left')
    local Reason = UI:CreateEditBox((w - 300) / 2, 170, 300, 20, 'Motivo', false, GUI['BanWindow'], {})
    if reason then
        guiSetText(Reason, reason)
    end

    UI:CreateLabel((w - 300) / 2, 200, 300, 20, 'Tempo', GUI['BanWindow'], 'left')
    local TempoQuantity = UI:CreateEditBox((w - 300) / 2, 220, 149, 20, 'Tempo', false, GUI['BanWindow'], {})
    guiSetText(TempoQuantity, '9999')

    local TempoType = UI:CreateComboBox((w - 300) / 2 + 150, 220, 149, 150, 'Selecione', false, GUI['BanWindow'], {
        headerColor = {30, 30, 30, 250},
    })
    
    UI:addComboBoxItem(TempoType, 'Minutos')
    UI:addComboBoxItem(TempoType, 'Horas')
    UI:addComboBoxItem(TempoType, 'Dias')
    UI:addComboBoxItem(TempoType, 'Meses')
    UI:addComboBoxItem(TempoType, 'Permanente')

    local confirm = UI:CreateButton((w - 300) / 2, h - 70, 300, 40, 'Confirmar', false, GUI['BanWindow'])
    addEventHandler('onClientGUIClick', confirm, function()
        if type(callback) == 'function' then
            local _, tempoType = UI:getComboBoxSelectedItem(TempoType)
            local name = guiGetText(Nome)
            local reason = guiGetText(Reason)
            local serial = guiGetText(Serial)
            local tempo = tonumber(guiGetText(TempoQuantity))
            if tempoType then
                if tempo then
                    if (utf8.len(name) > 3) then
                        if (utf8.len(reason) > 3) then
                            if (utf8.len(serial) == 32) then
                                callback(name, serial, reason, tempo, tempoType)
                                CloseBanWindow()
                            else
                                NOTIFICATION:CreateNotification('O serial deve possuir 32 caracteres.', 'error')
                            end
                        else
                            NOTIFICATION:CreateNotification('O motivo deve possuir no minimo 3 caracteres.', 'error')
                        end
                    else
                        NOTIFICATION:CreateNotification('O nome deve possuir no minimo 3 caracteres.', 'error')
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

CloseBanWindow = function()
    if isElement(GUI['BanWindow']) then
        destroyElement(GUI['BanWindow'])
    end
end

Widget.OnClick = function(action)

    local selectedString = UI:getSelectedListItem(Widget.BansList)
    local Ban = selectedString and Widget.BansCache[selectedString] and Widget.Bans[Widget.BansCache[selectedString]]

    if (action == 'Remover') then
        if Ban then
            local str = ('Você tem certeza de que deseja remover o banimento de \n%s?'):format(selectedString)
            ShowConfirmWindow('Remover Banimento', str, function()
                triggerServerEvent('_unbanSerial', localPlayer, Ban.Serial)
                NOTIFICATION:CreateNotification('Enviada solicitação para remover banimento.', 'info')
            end)
        else
            NOTIFICATION:CreateNotification('Selecione um banimento válido na lista.', 'error')
        end

    elseif (action == 'Editar') then
        if Ban then
            local callBack = function(name, serial, reason, tempo, tempoType)
                triggerServerEvent('_editBan', localPlayer, name, serial, reason, tempo, tempoType)
                NOTIFICATION:CreateNotification('Enviada solicitação para editar banimento.', 'info')
            end

            CreateBanWindow(('Editar Banimento\n%s'):format(selectedString), Ban.Name, Ban.Serial, Ban.Unban, Ban.Reason, callBack)
        else
            NOTIFICATION:CreateNotification('Selecione um banimento válido na lista.', 'error')
        end

    elseif (action == 'Adicionar') then
        local callBack = function(name, serial, reason, tempo, tempoType)
            triggerServerEvent('_addBan', localPlayer, name, serial, reason, tempo, tempoType)
            NOTIFICATION:CreateNotification('Enviada solicitação para adicionar banimento.', 'info')
        end

        CreateBanWindow('Adicionar Banimento', nil, nil, nil, nil, callBack)
    end
end

Admin.Widgets['Bans'] = Widget
