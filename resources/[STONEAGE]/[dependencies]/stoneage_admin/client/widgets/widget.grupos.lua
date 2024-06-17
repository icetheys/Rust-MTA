local Widget = {
    ButtonsGrupos = {'Entrar', 'Setar Descrição', 'Setar Limite de Membros', 'Destruir Grupo', 'Banir Grupo'},
    Grupos = false,
    GruposCache = {},
}

local searchTimer

Widget.Init = function()
    local w, h = 800 - 70, 600

    Widget.Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {35, 35, 35, 200},
    })

    guiSetVisible(Widget.Container, false)

    Widget.Header = UI:CreateTextWithBG(0, 0, w, 60, 'Grupos', false, Widget.Container, {
        bgColor = {25, 25, 25, 250},
    })

    Widget.GroupsEdit = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, Widget.Container)
    addEventHandler('onClientGUIChanged', Widget.GroupsEdit, function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(Widget.SearchGroup, 100, 1, guiGetText(source))
    end)

    Widget.GruposRefresh = UI:CreateButton(315, 90, 30, 30, '⟲', false, Widget.Container)
    addEventHandler('onClientGUIClick', Widget.GruposRefresh, function()
        triggerServerEvent('requestGroupsList', localPlayer, true, true)
        guiSetText(Widget.GroupsEdit, '')
    end, false)

    Widget.GruposList = UI:CreateList(45, 120, 300, 440, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('ui:onSelectListItem', Widget.GruposList, Widget.SelectGroupsInList)

    local bg = UI:CreateRectangle(385, 90, 300, 160, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    local scrollPane = UI:CreateScrollPane(5, 0, 295, 160, false, bg, {})
    Widget.GruposInfo = UI:CreateLabel(0, 5, 280, 600, 'teste', scrollPane, 'left', 'top')

    createButtons('Grupos', Widget.ButtonsGrupos, Widget.Container, 385, 285, 300, 275, 95, 38)
end

Widget.Toggle = function(state)
    if state then
        if (not Widget.Grupos) then
            triggerServerEvent('requestGroupsList', localPlayer, false, true)
        end
        Widget.SelectGroupsInList(false)
    end
    guiSetVisible(Widget.Container, state)
end

Widget.SearchGroup = function(filter, onStart)
    filter = filter and (filter:gsub('%[', ''):gsub('%]', ''))

    UI:ResetListItems(Widget.GruposList)
    Widget.GruposCache = {}

    local added = 0

    for k, v in pairs(Widget.Grupos) do
        local Name = v.Name or '*unknown'

        if (Name:len() > 10) then
            Name = Name:sub(1, 10) .. '...'
        end

        local str = ('%s (%s/%s)'):format(Name, table.size(v.Members), v.MaxMembers)

        if filter and (str:lower():find(filter:lower())) or (not filter) then
            UI:addListItem(Widget.GruposList, str)
            added = added + 1
        end

        Widget.GruposCache[str] = k
    end
    guiSetText(Widget.Header, ('Grupos (%i)'):format(added))

    if (not onStart) then
        guiFocus(Widget.GroupsEdit)
    end
end

addEvent('receiveGroupList', true)
addEventHandler('receiveGroupList', localPlayer, function(list)
    Widget.Grupos = list
    if (guiGetText(Widget.GroupsEdit) == '') then
        Widget.SearchGroup(false, true)
    else
        guiSetText(Widget.GroupsEdit, '')
    end
    Widget.SelectGroupsInList(false)
end)

Widget.SelectGroupsInList = function(string)
    if string then
        local Grupo = Widget.Grupos[Widget.GruposCache[string]]
        if Grupo then

            local arr = {{'Nome', Grupo.Name}, {'Criador', Grupo.Creator}, {'Descrição', Grupo.Description},
                         {'Limite de Membros', Grupo.MaxMembers}, {'Membros', inspect(Grupo.Members)}}

            local str = '\n'
            for k, v in ipairs(arr) do
                str = str .. ('%s: %s\n\n'):format(v[1], v[2] or 'Não detectado.')
            end

            guiSetText(Widget.GruposInfo, str)

        else
            guiSetText(Widget.GruposInfo, '\nGrupo não encontrado.')
        end
    else
        guiSetText(Widget.GruposInfo, '\nSelecione um Grupo na lista pare ter informações sobre ele')
    end
end

Widget.OnClick = function(action)

    local selectedString = UI:getSelectedListItem(Widget.GruposList)
    local Grupo = selectedString and Widget.GruposCache[selectedString] and
                      Widget.Grupos[Widget.GruposCache[selectedString]]

    if (not Grupo) then
        return NOTIFICATION:CreateNotification('Selecione um Grupo válido na lista.', 'error')
    end

    if (action == 'Entrar') then
        local str = ('Você tem certeza de que deseja entrar no grupo\n%s?'):format(selectedString)
        ShowConfirmWindow('Entrar no grupo', str, function()
            triggerServerEvent('joinGroup', localPlayer, Grupo.Name)
        end)

    elseif (action == 'Setar Descrição') then
        local callBack = function(str)
            triggerServerEvent('adminSetGroupDesc', localPlayer, Grupo.Name, str)
        end

        local str = ('Insira a baixo a descrição que você quer setar para o grupo "%s"'):format(Grupo.Name)
        ShowInputWindow('Setar Descrição', str, callBack)

    elseif (action == 'Setar Limite de Membros') then
        local callBack = function(str)
            local limit = tonumber(str)
            if limit and (limit >= 0) then
                triggerServerEvent('adminSetGroupLimit', localPlayer, Grupo.Name, limit)
            else
                NOTIFICATION:CreateNotification('Você não inseriu um limite válido.', 'error')
            end
        end

        local str = ('Insira a baixo a quantidade máxima de membros que você quer setar para o grupo "%s"'):format(
                        Grupo.Name)
        ShowInputWindow('Setar Limite de Membros', str, callBack)

    elseif (action == 'Destruir Grupo') then
        local callBack = function(str)
            triggerServerEvent('adminDestroyGroup', localPlayer, Grupo.Name)
        end

        local str = ('Você realmente deseja destruir o grupo "%s"?\nEsta ação é irreversível.'):format(Grupo.Name)
        ShowConfirmWindow('Destruir Grupo', str, callBack)

    elseif (action == 'Banir Grupo') then
        local callBack = function(reason)
            if (reason:len() > 0) then
                local callBack = function(text)
                    local days = tonumber(text)
                    if days and (days >= 0) then
                        triggerServerEvent('adminBanGroup', localPlayer, Grupo.Name, reason, days)
                    else
                        NOTIFICATION:CreateNotification('Você não inseriu um tempo válido.', 'error')
                    end
                end
                local str =
                    ('Insira abaixo a quantidade de dias no qual você deseja banir todos os membros do grupo\n%s\n(Digite 0 para permanente.)'):format(
                        Grupo.Name)
                ShowInputWindow('Banir Grupo', str, callBack)
            else
                NOTIFICATION:CreateNotification('Você não inseriu um motivo válido.', 'error')
            end
        end
        local str = ('Insira abaixo o motivo no qual você deseja banir todos os membros do grupo\n%s'):format(
                        Grupo.Name)
        ShowInputWindow('Banir Grupo', str, callBack)

    end
end

Admin.Widgets['Grupos'] = Widget

table.size = function(arr)
    local q = 0
    for k in pairs(arr) do
        q = q + 1
    end
    return q
end
