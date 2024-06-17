local Widget = {
    Config = false,
    ConfigCache = {},
}

local searchTimer

Widget.Init = function()
    local w, h = 800 - 70, 600

    Widget.Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {35, 35, 35, 200},
    })

    guiSetVisible(Widget.Container, false)

    Widget.Header = UI:CreateTextWithBG(0, 0, w, 60, 'Config', false, Widget.Container, {
        bgColor = {25, 25, 25, 250},
    })

    Widget.ConfigEdit = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, Widget.Container)
    addEventHandler('onClientGUIChanged', Widget.ConfigEdit, function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(Widget.SearchConfig, 100, 1, guiGetText(source))
    end)

    Widget.ConfigRefresh = UI:CreateButton(315, 90, 30, 30, '⟲', false, Widget.Container)
    addEventHandler('onClientGUIClick', Widget.ConfigRefresh, function()
        triggerServerEvent('requestConfigList', localPlayer, true, true)
        guiSetText(Widget.ConfigEdit, '')
    end, false)

    Widget.ConfigList = UI:CreateList(45, 120, 300, 440, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('ui:onSelectListItem', Widget.ConfigList, Widget.SelectConfigInList)

    local bg = UI:CreateRectangle(385, 90, 300, 160, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    local scrollPane = UI:CreateScrollPane(5, 0, 295, 160, false, bg, {})
    Widget.ConfigInfo = UI:CreateLabel(0, 5, 280, 600, 'teste', scrollPane, 'left', 'top')

    Widget.NewValue = UI:CreateEditBox(385, 285, 179, 30, 'Insira aqui o novo valor', false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })

    local btn = UI:CreateButton(565, 285, 120, 30, 'Salvar', false, Widget.Container)
    addEventHandler('onClientGUIClick', btn, function(key, state)
        if (key == 'left') then
            if hasEnoughPermission('Config:Salvar') then
                Widget.OnClick('Salvar')
            end
        end
    end, false)
end

Widget.Toggle = function(state)
    if state then
        if (not Widget.Config) then
            triggerServerEvent('requestConfigList', localPlayer, false, true)
        end
        Widget.SelectConfigInList(false)
    end
    guiSetVisible(Widget.Container, state)
end

Widget.SearchConfig = function(filter, onStart)
    filter = filter and (filter:gsub('%[', ''):gsub('%]', ''))

    UI:ResetListItems(Widget.ConfigList)
    Widget.ConfigCache = {}

    local added = 0

    for k, v in ipairs(Widget.Config) do
        local str = ('%s [%s]'):format(v.Name, v.CurrentValue)
        if filter and (str:lower():find(filter:lower())) or (not filter) then
            UI:addListItem(Widget.ConfigList, str)
            added = added + 1
        end
        Widget.ConfigCache[str] = k
    end
    guiSetText(Widget.Header, ('Config (%i)'):format(added))

    if (not onStart) then
        guiFocus(Widget.ConfigEdit)
    end
end

addEvent('receiveConfigList', true)
addEventHandler('receiveConfigList', localPlayer, function(list)
    Widget.Config = list
    if (guiGetText(Widget.ConfigEdit) == '') then
        Widget.SearchConfig(false, true)
    else
        guiSetText(Widget.ConfigEdit, '')
    end
    Widget.SelectConfigInList(false)
end)

Widget.SelectConfigInList = function(string)
    if isElement(Widget.ConfigInfo) then
        if string then
            local Config = Widget.Config[Widget.ConfigCache[string]]
            if Config then
                local arr = {{'Nome', Config.Name}, {'Descrição', Config.Description}, {'Valor Padrão', Config.DefaultValue},
                             {'Valor Atual', Config.CurrentValue}, {'Exemplos', Config.Examples}}

                local str = '\n'
                for k, v in ipairs(arr) do
                    str = str .. ('%s: %s\n\n'):format(v[1], v[2] or 'Não detectado.')
                end

                guiSetText(Widget.ConfigInfo, str)
                guiSetText(Widget.NewValue, Config.CurrentValue)
            else
                guiSetText(Widget.ConfigInfo, '\nConfigimento não encontrado.')
            end
        else
            guiSetText(Widget.ConfigInfo, '\nSelecione um configimento na lista pare ter informações sobre ele')
        end
    end
end

Widget.OnClick = function(action)
    local selectedString = UI:getSelectedListItem(Widget.ConfigList)
    local Config = selectedString and Widget.ConfigCache[selectedString] and Widget.Config[Widget.ConfigCache[selectedString]]

    if (action == 'Salvar') then
        if Config then
            local str = ('Você tem certeaza que deseja alterar\n"%s"\npara o valor "%s"?'):format(Config.Name, guiGetText(Widget.NewValue))
            ShowConfirmWindow('Alterar configuração', str, function()
                triggerServerEvent('changeSettingValue', localPlayer, Config.Name, guiGetText(Widget.NewValue))
                NOTIFICATION:CreateNotification('Enviada solicitação para alterar configuração.', 'info')
            end)
        else
            NOTIFICATION:CreateNotification('Selecione uma configuração válida na lista.', 'error')
        end
    end
end

Admin.Widgets['Config'] = Widget
