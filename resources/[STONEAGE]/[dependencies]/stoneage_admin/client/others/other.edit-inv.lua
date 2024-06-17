EditInventory = {
    AllItemsCache = {},
    PlayerItemsCache = {},
}

local searchTimer

EditInventory.Init = function()
    local w, h = 800, 600
    local BG = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, 'Editar Inventário', false, false, true, {
        bgColor = {35, 35, 35, 250},
    })

    addEventHandler('onCustomWindowClose', BG, function()
        EditInventory.Toggle(false)
    end)

    EditInventory['PlayerItemLabel'] = UI:CreateLabel(45, 70, 300, 20, 'Itens de blabla', BG)
    EditInventory['PlayerItemSearch'] = UI:CreateEditBox(45, 90, 270, 30, 'Pesquisar', false, BG)
    addEventHandler('onClientGUIChanged', EditInventory['PlayerItemSearch'], function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(EditInventory.SearchPlayerItems, 100, 1, guiGetText(source))
    end)

    EditInventory['PlayerItemRefresh'] = UI:CreateButton(315, 90, 30, 30, '⟲', false, BG)
    addEventHandler('onClientGUIClick', EditInventory['PlayerItemRefresh'], function()
        if (guiGetText(EditInventory['PlayerItemSearch']) == '') then
            EditInventory.SearchPlayerItems(false)
        else
            guiSetText(EditInventory['PlayerItemSearch'], '')
        end
    end, false)

    EditInventory['PlayerItemList'] = UI:CreateList(45, 120, 300, 440, false, BG, {
        bgColor = {20, 20, 20, 250},
    })
    EditInventory['PlayerItemTake'] = UI:CreateButton(345, 90, 30, 470, ('>\n\n'):rep(10), false, BG, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('onClientGUIClick', EditInventory['PlayerItemTake'], EditInventory.OnClick, false)

    EditInventory['AllItemLabel'] = UI:CreateLabel(460, 70, 300, 20, 'Todos os Itens', BG)

    EditInventory['AllItemSearch'] = UI:CreateEditBox(460, 90, 270, 30, 'Pesquisar', false, BG)

    addEventHandler('onClientGUIChanged', EditInventory['AllItemSearch'], function()
        if isTimer(searchTimer) then
            killTimer(searchTimer)
        end
        searchTimer = setTimer(EditInventory.SearchAllItems, 100, 1, guiGetText(source))
    end)

    EditInventory['AllItemRefresh'] = UI:CreateButton(730, 90, 30, 30, '⟲', false, BG)
    addEventHandler('onClientGUIClick', EditInventory['AllItemRefresh'], function()
        if (guiGetText(EditInventory['AllItemSearch']) == '') then
            EditInventory.SearchAllItems(false)
        else
            guiSetText(EditInventory['AllItemSearch'], '')
        end
    end, false)

    EditInventory['AllItemList'] = UI:CreateList(460, 120, 300, 440, false, BG, {
        bgColor = {20, 20, 20, 250},
    })

    EditInventory['AllItemGive'] = UI:CreateButton(430, 90, 30, 470, ('<\n\n'):rep(10), false, BG, {
        bgColor = {20, 20, 20, 250},
    })
    addEventHandler('onClientGUIClick', EditInventory['AllItemGive'], EditInventory.OnClick, false)

    EditInventory['Background'] = BG

    addEventHandler('onClientPlayerQuit', root, EditInventory.onQuit)

end

EditInventory.SearchPlayerItems = function(filter, onStart)
    UI:ResetListItems(EditInventory['PlayerItemList'])
    local added = 0

    local playerItems = {}

    for k, v in pairs(getElementData(EditInventory.Target, 'invOrder') or {}) do
        playerItems[v.itemName] = (playerItems[v.itemName] or 0) + v.quantity
    end

    local orderedPlayerItems = {}
    for k, v in pairs(playerItems) do
        table.insert(orderedPlayerItems, {k, v})
    end

    table.sort(orderedPlayerItems, function(a, b)
        return a[1] < b[1]
    end)

    EditInventory.PlayerItemsCache = {}

    for _, item in ipairs(orderedPlayerItems) do
        local str = exports['stoneage_translations']:translate(item[1], 'name')
        str = str .. (' [%i]'):format(item[2])

        if filter and (item[1]:lower():find(filter:lower()) or str:lower():find(filter:lower())) or (not filter) then
            UI:addListItem(EditInventory['PlayerItemList'], str)
            EditInventory.PlayerItemsCache[str] = item[1]
            added = added + 1
        end
    end

    if (not onStart) then
        guiFocus(EditInventory['PlayerItemSearch'])
    end
    guiSetText(EditInventory['PlayerItemLabel'], ('Itens de %s (%i)'):format(getPlayerName(EditInventory.Target), added))

end

EditInventory.SearchAllItems = function(filter, onStart)
    UI:ResetListItems(EditInventory['AllItemList'])
    local added = 0
    local allItems = exports['gamemode']:getPlayerDataTable()
    EditInventory.AllItemsCache = {}
    for itemName, arr in pairs(allItems) do
        if (arr.invSettings) then
            local str = exports['stoneage_translations']:translate(itemName, 'name')
            if (not str:find('translate error')) then
                if filter and (itemName:lower():find(filter:lower()) or str:lower():find(filter:lower())) or
                    (not filter) then
                    UI:addListItem(EditInventory['AllItemList'], str)
                    EditInventory.AllItemsCache[str] = itemName
                    added = added + 1
                end
            end
        end
    end
    if (not onStart) then
        guiFocus(EditInventory['AllItemSearch'])
    end
    guiSetText(EditInventory['AllItemLabel'], ('Todos os Itens (%i)'):format(added))
end

EditInventory.onQuit = function()
    if (source == EditInventory.Target) then
        local str = ('O jogador %s no qual você está editando o inventário acabou de se desconectar.'):format(
                        getPlayerName(source))

        NOTIFICATION:CreateNotification(str, 'error')
        EditInventory.Toggle(false)
    end
end

EditInventory.Toggle = function(state, target)
    if state then
        if (not isElement(target)) then
            return
        end
        EditInventory.Target = target
        EditInventory.SearchAllItems(false, true)
        EditInventory.SearchPlayerItems(false, true)

        guiMoveToBack(GUI['Background'])
    else
        CloseConfirmWindow()
        CloseInputWindow()
    end
    guiSetVisible(EditInventory['Background'], state)
end

EditInventory.SyncWhenEditPlayerInv = function()
    if (not guiGetVisible(EditInventory['Background'])) then
        return
    end
    if (guiGetText(EditInventory['PlayerItemSearch']) == '') then
        EditInventory.SearchPlayerItems(false)
    else
        guiSetText(EditInventory['PlayerItemSearch'], '')
    end
end
addEvent('SyncWhenEditPlayerInv', true)
addEventHandler('SyncWhenEditPlayerInv', localPlayer, EditInventory.SyncWhenEditPlayerInv)

addEventHandler('onClientElementDataChange', root, function(key)
    if (source == 'EditInventory.Target') then
        if exports['gamemode']:isItemOfInventory(key) then
            EditInventory.SyncWhenEditPlayerInv()
        end
    end
end)

EditInventory.OnClick = function()
    if (not isElement(EditInventory.Target)) then
        return NOTIFICATION:CreateNotification('Jogador não encontrado!', 'error')
    end

    if (source == EditInventory['PlayerItemTake']) then
        local selectedItem = UI:getSelectedListItem(EditInventory['PlayerItemList'])
        local realItem = selectedItem and EditInventory.PlayerItemsCache[selectedItem]
        if realItem then
            local callBack = function(text)
                local quantity = tonumber(text) or 0
                if (quantity > 0) then
                    triggerServerEvent('removePlayerItem', localPlayer, EditInventory.Target, realItem, quantity)
                else
                    NOTIFICATION:CreateNotification('Insira uma quantidade válida.', 'error')
                end
            end
            local str = ('Insira abaixo a quantidade de "%s" que você quer remover de %s.'):format(selectedItem,
                            getPlayerName(EditInventory.Target))

            ShowInputWindow('Remover item', str, callBack)

        else
            NOTIFICATION:CreateNotification('Selecione um item válido na lista.', 'error')
        end

    elseif (source == EditInventory['AllItemGive']) then
        local selectedItem = UI:getSelectedListItem(EditInventory['AllItemList'])
        local realItem = selectedItem and EditInventory.AllItemsCache[selectedItem]
        if realItem then
            local callBack = function(text)
                local quantity = tonumber(text) or 0
                if (quantity > 0) then
                    triggerServerEvent('_givePlayerItem', localPlayer, EditInventory.Target, realItem, quantity)
                else
                    NOTIFICATION:CreateNotification('Insira uma quantidade válida.', 'error')
                end
            end
            local str = ('Insira abaixo a quantidade de "%s" que você quer dar para %s.'):format(selectedItem,
                            getPlayerName(EditInventory.Target))

            ShowInputWindow('Dar item', str, callBack)

        end
    end
end
