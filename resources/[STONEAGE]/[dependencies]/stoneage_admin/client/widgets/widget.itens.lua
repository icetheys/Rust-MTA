local Widget = {
    ButtonsItens = {'Ir até posição'},
    Itens = false,
    ItensCache = {},
}

local searchTimer

Widget.Init = function()
    local w, h = 800 - 70, 600

    Widget.Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {35, 35, 35, 200},
    })

    guiSetVisible(Widget.Container, false)

    Widget.Header = UI:CreateTextWithBG(0, 0, w, 60, 'Itens', false, Widget.Container, {
        bgColor = {25, 25, 25, 250},
    })

    Widget.ItensEdit = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, Widget.Container)
    addEventHandler('onClientGUIChanged', Widget.ItensEdit, function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(Widget.SearchItens, 100, 1, guiGetText(source))
    end)

    Widget.ItensRefresh = UI:CreateButton(315, 90, 30, 30, '⟲', false, Widget.Container)
    addEventHandler('onClientGUIClick', Widget.ItensRefresh, function()
        triggerServerEvent('requestItensList', localPlayer, true, true)
        guiSetText(Widget.ItensEdit, '')
    end, false)

    Widget.ItensList = UI:CreateList(45, 120, 300, 440, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('ui:onSelectListItem', Widget.ItensList, Widget.SelectItensInList)

    local bg = UI:CreateRectangle(385, 90, 300, 300, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    local scrollPane = UI:CreateScrollPane(5, 0, 295, 300, false, bg, {})
    Widget.ItensInfo = UI:CreateLabel(0, 5, 280, 600, 'teste', scrollPane, 'left', 'top')

    createButtons('Itens', Widget.ButtonsItens, Widget.Container, 385, 405, 300, 155, 95, 38)
end

Widget.Toggle = function(state)
    if state then
        if (not Widget.Itens) then
            triggerServerEvent('requestItensList', localPlayer, false, true)
        end
        Widget.SelectItensInList(false)
    end
    guiSetVisible(Widget.Container, state)
end

Widget.SearchItens = function(filter, onStart)
    filter = filter and (filter:gsub('%[', ''):gsub('%]', ''))

    UI:ResetListItems(Widget.ItensList)
    Widget.ItensCache = {}

    local added = 0
    for type, table in pairs(Widget.Itens) do
        for elem, subtable in pairs(table) do
            local str = ('%s [%s] - %s'):format(subtable.ID, type, subtable.Name)
            if subtable.Owner then
                str = str .. (' (%s)'):format(subtable.Owner)
            end
            if subtable.OwnerGroup then
                str = str .. (' [%s]'):format(subtable.OwnerGroup)
            end
            if filter and (str:lower():find(filter:lower())) or (not filter) then
                UI:addListItem(Widget.ItensList, str)
                added = added + 1
                Widget.ItensCache[str] = {
                    Elem = elem,
                    Tipo = type,
                    Table = subtable,
                }
            end
        end
    end
    guiSetText(Widget.Header, ('Itens Raros (%i)'):format(added))
    if (not onStart) then
        guiFocus(Widget.ItensEdit)
    end
end

addEvent('receiveItensList', true)
addEventHandler('receiveItensList', localPlayer, function(list)
    Widget.Itens = list
    if (guiGetText(Widget.ItensEdit) == '') then
        Widget.SearchItens(false, true)
    else
        guiSetText(Widget.ItensEdit, '')
    end
    Widget.SelectItensInList(false)
end)

Widget.SelectItensInList = function(string)
    if string then
        local ItemSettings = Widget.ItensCache[string]
        if ItemSettings then
            local x, y, z = unpack(ItemSettings.Table.Position)

            if (isElement(ItemSettings.Elem)) then
                x, y, z = getElementPosition(ItemSettings.Elem)
            end

            local arr = {{'Tipo', ItemSettings.Tipo}, {'Nome', ItemSettings.Table.Name}, {'Itens', inspect(ItemSettings.Table.Items, {
                indent = '    ',
            })}, {'Dono do objeto', ItemSettings.Table.Owner}, {'Grupo do dono', ItemSettings.Table.OwnerGroup},
                         {'Localização', ('%s (%s)'):format(getZoneName(x, y, z), getZoneName(x, y, z, true))}}

            local str = '\n'
            for k, v in ipairs(arr) do
                str = str .. ('%s: %s\n\n'):format(v[1], v[2] or 'Não detectado.')
            end

            guiSetText(Widget.ItensInfo, str)

        else
            guiSetText(Widget.ItensInfo, '\nItem não encontrado.')
        end
    else
        guiSetText(Widget.ItensInfo, '\nSelecione um item na lista pare ter informações sobre ele')
    end
end

Widget.OnClick = function(action)
    local selectedString = UI:getSelectedListItem(Widget.ItensList)
    local ItemSettings = selectedString and Widget.ItensCache[selectedString]
    if (action == 'Ir até posição') then
        if ItemSettings then
            local str = ('Você tem certeza de que deseja se teletransportar até \n%s?'):format(selectedString)
            ShowConfirmWindow('Teletransporte', str, function()
                local x, y, z = unpack(ItemSettings.Table.Position)
                if (isElement(ItemSettings.Elem)) then
                    x, y, z = getElementPosition(ItemSettings.Elem)
                end
                setElementPosition(localPlayer, x, y, z)
            end)
        else
            NOTIFICATION:CreateNotification('Selecione um item válido na lista.', 'error')
        end
    end
end

Admin.Widgets['Itens'] = Widget
