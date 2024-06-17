local Widget = {
    ButtonsVeiculo = {'Teleporte', 'Puxar', 'Reparar', '(Des)Freezar', 'Destruir', 'Setar gasolina', 'Montar Veiculo'},
    VehiclesCache = false,
}

local searchTimer

Widget.Init = function()
    local w, h = 800 - 70, 600

    Widget.Container = UI:CreateRectangle(70, 0, w, h, false, GUI['Background'], {
        bgColor = {35, 35, 35, 200},
    })

    guiSetVisible(Widget.Container, false)

    Widget.Header = UI:CreateTextWithBG(0, 0, w, 60, 'Veiculo', false, Widget.Container, {
        bgColor = {25, 25, 25, 250},
    })

    Widget.VeiculoEdit = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, Widget.Container)
    addEventHandler('onClientGUIChanged', Widget.VeiculoEdit, function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(Widget.SearchVeiculo, 100, 1, guiGetText(source))
    end)

    Widget.VeiculoRefresh = UI:CreateButton(315, 90, 30, 30, '⟲', false, Widget.Container)
    addEventHandler('onClientGUIClick', Widget.VeiculoRefresh, function()
        if (guiGetText(Widget.VeiculoEdit) == '') then
            Widget.SearchVeiculo(false)
        else
            guiSetText(Widget.VeiculoEdit, '')
        end
        Widget.SelectVeiculoInList(false)
    end, false)

    Widget.VeiculoList = UI:CreateList(45, 120, 300, 440, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('ui:onSelectListItem', Widget.VeiculoList, Widget.SelectVeiculoInList)

    local bg = UI:CreateRectangle(385, 90, 300, 160, false, Widget.Container, {
        bgColor = {20, 20, 20, 250},
    })
    local scrollPane = UI:CreateScrollPane(5, 0, 295, 160, false, bg, {})
    Widget.VeiculoInfo = UI:CreateLabel(0, 5, 280, 600, 'teste', scrollPane, 'left', 'top')

    createButtons('Veiculo', Widget.ButtonsVeiculo, Widget.Container, 385, 285, 300, 275, 95, 38)
end

Widget.Toggle = function(state)
    if state then
        if (not Widget.VehiclesCache) then
            Widget.SearchVeiculo(false, true)
        end
    end
    Widget.SelectVeiculoInList(false)
    guiSetVisible(Widget.Container, state)
end

Widget.SearchVeiculo = function(filter, onStart)
    filter = filter and (filter:gsub('%[', ''):gsub('%]', ''))

    UI:ResetListItems(Widget.VeiculoList)
    local added = 0
    Widget.VehiclesCache = {}
    for k, v in ipairs(getElementsByType('vehicle')) do
        local str = ('%i - %s'):format(k, getVehicleName(v))
        if filter and (str:lower():find(filter:lower())) or (not filter) then
            UI:addListItem(Widget.VeiculoList, str)
            Widget.VehiclesCache[str] = v
            added = added + 1
        end
    end
    guiSetText(Widget.Header, ('Veículos (%i)'):format(added))
    if (not onStart) then
        guiFocus(Widget.VeiculoEdit)
    end
end

Widget.SelectVeiculoInList = function(string)
    if string then
        local veh = isElement(Widget.VehiclesCache[string]) and Widget.VehiclesCache[string]
        if veh then
            local x, y, z = getElementPosition(veh)
            local arr = {{'Nome', getVehicleName(veh)}, {'Vida', ('%i%%'):format(getElementHealth(veh) / 10)},
                         {'Localização', ('%s (%s)'):format(getZoneName(x, y, z), getZoneName(x, y, z, true))},
                         {'Jogadores dentro', inspect(getVehicleOccupants(veh))}}

            local str = ''
            for k, v in ipairs(arr) do
                str = str .. ('%s: %s\n\n'):format(v[1], v[2] or 'Não detectado.')
            end

            guiSetText(Widget.VeiculoInfo, str)

        else
            guiSetText(Widget.VeiculoInfo, 'Veículo não encontrado.')
        end
    else
        guiSetText(Widget.VeiculoInfo, 'Selecione um Veiculo na lista pare ter informações sobre ele')
    end
end

Widget.OnClick = function(action)
    local selectedString = UI:getSelectedListItem(Widget.VeiculoList)
    local veh = selectedString and isElement(Widget.VehiclesCache[selectedString]) and Widget.VehiclesCache[selectedString]

    if (not veh) then
        NOTIFICATION:CreateNotification('Este veículo não foi encontrado.', 'error')
        return
    end

    if (action == 'Teleporte') then
        local callBack = function()
            triggerServerEvent('warpTo', localPlayer, localPlayer, veh)
        end
        ShowConfirmWindow('Teletransporte', 'Você tem certeza de que deseja se teletransportar até este veículo?', callBack)

    elseif (action == 'Puxar') then
        local callBack = function()
            triggerServerEvent('warpTo', localPlayer, veh, localPlayer)
        end
        ShowConfirmWindow('Teletransporte', 'Você tem certeza de que deseja se puxar este veículo até você?', callBack)

    elseif (action == '(Des)Freezar') then
        triggerServerEvent('freezeUnfreeze', localPlayer, veh)

    elseif (action == 'Destruir') then
        local callBack = function()
            triggerServerEvent('_destroyElement', localPlayer, veh)
            setTimer(function()
                if (guiGetText(Widget.VeiculoEdit) == '') then
                    Widget.SearchVeiculo(false)
                else
                    guiSetText(Widget.VeiculoEdit, '')
                end
                Widget.SelectVeiculoInList(false)
            end, 500, 1)
        end
        local str = 'Você tem certeza de que deseja se destruir este veículo?\nObs: esta açao é irreversível.'
        ShowConfirmWindow('Destruir Veículo', str, callBack)

    elseif (action == 'Reparar') then
        triggerServerEvent('repairVehicle', localPlayer, veh)

    elseif (action == 'Setar gasolina') then
        local callBack = function(quantity)
            quantity = tonumber(quantity) or -1
            if (quantity >= 0) then
                triggerServerEvent('setVehicleGasoline', localPlayer, veh, quantity)
            else
                NOTIFICATION:CreateNotification('Insira um número válido (0~100)%')
            end
        end
        local str = ('Insira abaixo a porcentagem de gasolina que você deseja setar para\n"%s"'):format(selectedString)
        ShowInputWindow('Setar gasolina', str, callBack)

    elseif (action == 'Montar Veiculo') then
        triggerServerEvent('montarVeiculo', localPlayer, veh)
        
    end
end

Admin.Widgets['Veiculo'] = Widget
