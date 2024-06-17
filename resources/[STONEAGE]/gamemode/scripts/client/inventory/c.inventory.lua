inv = {
    size = {
        x = 7,
        y = 6,
    },
    gui = {
        slots = {
            inv = {},
            pedSide = {},
            keybar = {},
            loot = {},
        },
    },
    order = {
        inv = {},
        keybar = {},
        pedSide = {},
        loot = {},
    },
    maxSlots = {
        inv = 0,
        keybar = 7,
        pedSide = 99,
        loot = 0,
    },
    boxSize = math.floor(sH * 0.06),
    margin = 1,
    loading = {},
    refreshingInv = {},
    rightClickHoverOption = false,
}

function initInvSlots()
    local w = inv.size.x * (inv.boxSize + inv.margin)
    local posX = sW * 0.5 - (w / 2)
    local posY = sH * 0.17 + sH * 0.2
    
    local refresh = UI:CreateImageWithBG(posX, posY, pixels(25), pixels(25), ':gamemode/files/images/ui/reload.png', false, inv.gui.bg, {
        bgColor = color('inv:boxColor'),
        imgColor = {210, 190, 175, 250},
    })
    
    UI:createText(posX + pixels(26), posY - inv.margin, w, pixels(25), 'INVENTORY', false, inv.gui.bg, {
        ['text-align-x'] = 'left',
        ['font'] = cfont('franklin:medium', 'gui'),
    })
    
    -- inv.gui.invSlots = UI:createText(posX + pixels(26), posY, w - pixels(26), pixels(25), 'SLOTS: 0/0', false, inv.gui.bg, {
    --     ['text-align-x'] = 'right',
    --     ['text-align-y'] = 'bottom',
    --     ['font'] = cfont('franklin', 'gui'),
    -- })
    local thisID = 0
    for yy = 1, inv.size.y do
        for xx = 1, inv.size.x do
            thisID = thisID + 1
            local x = posX + (xx - 1) * (inv.boxSize + inv.margin)
            local y = posY + (yy - 1) * (inv.boxSize + inv.margin) + pixels(25) + inv.margin
            createInvSlot('inv', x, y, inv.boxSize, inv.boxSize, thisID)
        end
    end
    
    addEventHandler('onClientGUIClick', refresh, function()
        inv.refreshingInv['inv'] = true
        startLoadingProcess(50, source, function()
            setSelectedItem(false)
            triggerServerEvent('inv:reorganize', resourceRoot, localPlayer)
            inv.refreshingInv['inv'] = nil
        end)
    end, false)
    
    inv.order['inv'] = getElementData(localPlayer, 'invOrder') or {}
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    inv.gui.bg = UI:CreateRectangle(0, 0, sW, sH, false, nil, {
        bgColor = color('inv:bg'),
    })
    
    guiSetVisible(inv.gui.bg, false)
    
    initInvSlots()
    initLootSlots()
    initInvTopBar()
    initPedSide()
    initBluePrints()
    initKeyBar()
    
    inv.maxSlots.inv = getElementData(localPlayer, 'maxSlots') or 0
    
    local add, remove = orderDifference({}, inv.order.inv)
    onOrderChange('inv', add, remove)
    updateBlockedSlots('inv')
    
    add, remove = orderDifference({}, inv.order.keybar)
    onOrderChange('keybar', add, remove)
    
    add, remove = orderDifference({}, inv.order.pedSide)
    onOrderChange('pedSide', add, remove)

-- setTimer(function() toggleInventory(true) end, 50, 1)
end)

function showInvSlots(state)
    for k, v in ipairs(inv.gui.slots.inv) do
        guiSetVisible(v.bg, state)
    end
    inv.showingInvSlots = not inv.showingInvSlots
end

addEventHandler('rust:onClientPlayerEquipItem', localPlayer, function(itemName)
    if activeUI or isMenuShowing() then
        return false
    end
    toggleControl('fire', true)
end)

addEventHandler('onClientKey', root, function(key, state)
    state = state and 'down' or 'up'

    if (getBoundKeys('fire')[key] ~= state) then
        return false
    end

    local weapon = getElementData(localPlayer, 'equippedItem')
    if weapon then
        local ammo = getPlayerDataSetting(weapon, 'ammo')
        if ammo then
            for slot, item in pairs(inv.order.inv) do
                if (not waitingResponse[slot]) then
                    if (item.itemName == ammo.name) and (item.quantity > 0) then
                        return
                    end
                end
            end
            cancelEvent(true)
        end
    end
end)

function toggleInventory(state, options)
    if state then
        if activeUI then
            return false
        elseif getElementData(localPlayer, 'isDead') then
            return false
        elseif (not getElementData(localPlayer, 'account')) then
            return false
        elseif getPedAnimation(localPlayer) then
            return false
        end
    end
    
    if isMenuShowing() then
        return false
    end
    
    activeUI = true
    
    guiSetVisible(inv.gui.bg, state)
    guiBringToFront(inv.gui.bg)
    guiSetVisible(inv.gui.topBar.bg, state)
    showInvSlots(state)
    showPedSide(state)
    showCursor(state, false)
    toggleBluePrints(state, options and options.inWorkbench)
    inv.allowToUseControls(not state)
    
    triggerEvent('onPlayerToggleInv', localPlayer, state)
    inv.showing = state
    toggleKeyBar(true, state)
    
    -- guiSetText(inv.gui.invSlots, ('SLOTS: %i/%i'):format(0, getElementData(localPlayer, 'maxSlots')))
    if state then
        addEventHandler('onClientRender', root, debugSlots)
        addEventHandler('onClientClick', root, inv.onClick)
        cancelCraftingObject()
        setCursorPosition(sW * 0.5, sH * 0.5)
    else
        
        activeUI = nil
        inv.setLootSource(false)
        toggleLootSlots(false)
        inv.toggleDrag(false)
        removeEventHandler('onClientClick', root, inv.onClick)
        removeEventHandler('onClientRender', root, debugSlots)
        showRightClickOptions(false)
        if inv.hover then
            if inv.hover.id then
                local bg = inv.gui.slots[inv.hover.source][inv.hover.id].bg
                guiSetSize(bg, inv.boxSize, inv.boxSize, false)
                
                local x, y = unpack(inv.gui.slots[inv.hover.source][inv.hover.id].pos)
                guiSetPosition(bg, x, y, false)
            end
        end
    end
    inv.hover = nil
end

debugSlots = function()
    do return end
    dxDrawText(inspect(inv.order.loot), sW - 200, 200, 0, 0, tocolor(255, 255, 255), 1, 'default-bold', 'left', 'top', false, false, true)
    dxDrawText(inspect(inv.order.inv), sW - 500, 200, 0, 0, tocolor(255, 255, 255), 1, 'default-bold', 'left', 'top', false, false, true)
end

isShowingInventory = function()
    return inv.showing
end

bindKey('tab', 'down', function()
    toggleInventory(not inv.showing)
end)

addEventHandler('rust:onClientPlayerDie', localPlayer, function()
    toggleInventory(false)
end)

addEventHandler('onClientRender', root, function()
    -- dxDrawBorderedText(inspect(inv.order), sW * 0.85, sH * 0.1, 0, 0, white, 1, 'default-bold', 'left', 'top', false, false, true)
    end)

function showRightClickOptions(state)
    if inv.gui.rightClickOptions then
        for k, v in ipairs(inv.gui.rightClickOptions) do
            local parent = getElementParent(v)
            if isElement(parent) then
                destroyElement(parent)
            end
        end
        inv.gui.rightClickOptions = nil
    end
    
    if state then
        if not inv.hover then
            return
        end
        local hoverSource = inv.hover.source
        local hoverPos = inv.hover.id
        local order = inv.order[hoverSource]
        local itemName = order and order[hoverPos] and order[hoverPos].itemName
        
        if itemName then
            local quantity = order and order[hoverPos] and order[hoverPos].quantity
            local options = getOptionsToUseItem(itemName, quantity)
            
            inv.gui.rightClickOptions = {}
            
            local cx, cy = _getCursorPosition(true)
            local w, h = pixels(75), pixels(25)
            
            for k, v in ipairs(options) do
                local y = cy + (k - 1) * (h + inv.margin)
                
                local btn = UI:CreateButton(cx, y, w, h, translate(v), false, inv.gui.bg, {
                    bgColor = color('inv:boxColor:selected2'),
                    hoverBgColor = color('inv:boxColor:selected'),
                })
                
                guiSetProperty(getElementParent(btn), 'AlwaysOnTop', 'True')
                guiBringToFront(btn)
                
                inv.gui.rightClickOptions[k] = btn
                
                addEventHandler('onClientMouseEnter', btn, function()
                    inv.rightClickHoverOption = k
                end)
                
                addEventHandler('onClientMouseLeave', btn, function()
                    inv.rightClickHoverOption = nil
                end)
                
                addEventHandler('onClientElementDestroy', btn, function()
                    if inv.rightClickHoverOption == k then
                        inv.rightClickHoverOption = nil
                    end
                end)
            -- addEventHandler('onClientGUIClick', btn, onClickRightOptions, false)
            end
            
            setSelectedItem(true, {
                itemName = itemName,
                quantity = quantity,
                source = hoverSource,
                id = hoverPos,
            })
        end
    end
end

function onClickRightOptions(optionID)
    local selectedID = inv.selected.id
    
    local order = selectedID and inv.order.inv[selectedID]
    if not order then
        return
    end
    
    local options = getOptionsToUseItem(order.itemName, order.quantity)
    local selectedOption = options[optionID]
    
    if selectedOption == 'Dividir' then
        triggerServerEvent('inv:splitItem', localPlayer, localPlayer, inv.selected.id)
    
    elseif selectedOption == 'Comer' or selectedOption == 'Beber' then
        playerConsumeItem(order.itemName, inv.selected.id)
    
    elseif selectedOption == 'Aprender' then
        triggerServerEvent('rust:learnBlueprintFromInv', localPlayer, order.itemName, inv.selected.id)
    
    elseif selectedOption == 'Dropar' then
        if isElement(inv.lootOb) then
            local obName = getElementData(inv.lootOb, 'obName')
            if obName == 'Fornalha' then
                if getElementData(inv.lootOb, 'furnance:firingSlot') then
                    if table.size(inv.order.loot) >= inv.maxSlots.loot - 1 then
                        setInvMessage(translate('Sem espaço suficiente'))
                        setSelectedItem(false)
                        showRightClickOptions(false)
                        return
                    end
                end
                
                if not getItemFurnanceSettings(order.itemName) then
                    setInvMessage(translate('Este item não pode ser colocado aqui'))
                    setSelectedItem(false)
                    showRightClickOptions(false)
                    return
                end
            
            elseif obName == 'Mesa de pesquisa' then
                setInvMessage(translate('Nao Pode dropar com botao direito mesa de pesquisa'))
                setSelectedItem(false)
                showRightClickOptions(false)
                return
            end
            
            if (table.size(inv.order.loot) >= inv.maxSlots.loot) then
                setInvMessage(translate('Sem espaço suficiente'))
                setSelectedItem(false)
                showRightClickOptions(false)
                return
            end
        end
        
        blockInventoryID('inv', inv.selected.id)
        triggerServerEvent('inv:dropItem', localPlayer, inv.selected.id, nil, inv.lootOb, 'inv')
    
    elseif selectedOption == 'Encher Garrafa' then
        triggerServerEvent('inv:fillBottle', localPlayer, inv.selected.id)
    
    end
    setSelectedItem(false)
    showRightClickOptions(false)
end

function inv.onClick(btn, state)
    local isLeftClick = btn == 'left'
    local isRightClick = btn == 'right'
    local isMiddleClick = btn == 'middle'
    local pressed = state == 'down'
    local released = state == 'up'
    
    local hover = inv.hover
    local hoverSource = hover and hover.source
    local hoverButton = hover and hover.button
    
    local hoverItem = hoverSource and inv.order[hoverSource] and hover.id and inv.order[hoverSource][hover.id]
    
    if pressed then
        if inv.gui.rightClickOptions then
            if inv.rightClickHoverOption then
                onClickRightOptions(inv.rightClickHoverOption)
            else
                showRightClickOptions(false)
            end
        end
        
        if hover then
            if hoverItem then
                
                if hover and hover.id and waitingResponse[hover.id] then
                    return
                end
                
                if (not inv.drag) then
                    if inv.refreshingInv[hoverSource] then
                        return false
                    end
                    -- CLIQUE COM BOTÃO ESQUERDO NO ITEM
                    if isLeftClick then
                        if hoverSource == 'inv' then
                            if inv.selected then
                                if (inv.selected.id == hover.id) then
                                    setSelectedItem(false)
                                end
                            end
                            
                            if (not getLoadingProcess(hoverButton)) and (state == 'down') then
                                onPlayerClickOnItem()
                            end
                        
                        elseif hoverSource == 'loot' or hoverSource == 'keybar' or hoverSource == 'pedSide' then
                            if hoverSource == 'loot' and isElement(inv.lootOb) then
                                local obName = getElementData(inv.lootOb, 'obName')
                                if obName == 'Fornalha' then
                                    local firingSlot = getElementData(inv.lootOb, 'furnance:firingSlot')
                                    if firingSlot and firingSlot == hover.id then
                                        setInvMessage(translate('slot está sendo usado'))
                                        return
                                    end
                                end
                            end
                            
                            local arr = inv.order[hoverSource][hover.id]
                            if arr then
                                inv.toggleDrag(true, {
                                    itemName = arr.itemName,
                                    quantity = arr.quantity,
                                    source = hoverSource,
                                    id = hover.id,
                                })
                            end
                        end
                    
                    -- CLIQUE COM BOTÃO DIREITO NO ITEM
                    elseif isRightClick then
                        if not getLoadingProcess(hoverButton) then
                            if hoverSource == 'inv' then
                                showRightClickOptions(true)
                            
                            elseif hoverSource == 'loot' then
                                if (table.size(inv.order.inv) >= inv.maxSlots.inv) then
                                    setInvMessage(translate('Sem espaço suficiente'))
                                    return
                                end
                                
                                if isElement(inv.lootOb) then
                                    local obName = getElementData(inv.lootOb, 'obName')
                                    if obName == 'Fornalha' then
                                        local firingSlot = getElementData(inv.lootOb, 'furnance:firingSlot')
                                        if firingSlot and firingSlot == hover.id then
                                            setInvMessage(translate('slot está sendo usado'))
                                            return
                                        end
                                    end
                                end
                                
                                startLoadingProcess(20, hoverButton, function()
                                    if inv.lootOb and isElement(inv.lootOb) then
                                        -- local arr = inv.order.loot[hover.id]
                                        -- local itemName = arr and arr.itemName
                                        -- local quantity = arr and arr.quantity
                                        
                                        blockInventoryID('loot', hover.id)
                                        triggerServerEvent('inv:takeItem', localPlayer, inv.lootOb, nil, hover.id, 'loot')
                                    end
                                end)
                            
                            end
                        end
                    
                    -- CLIQUE COM BOTÃO DO MEIO NO ITEM
                    elseif isMiddleClick then
                        if hoverItem.quantity > 1 then
                            local element
                            if hoverSource == 'inv' then
                                element = localPlayer
                            else
                                element = inv.lootOb
                                
                                if isElement(inv.lootOb) then
                                    local obName = getElementData(inv.lootOb, 'obName')
                                    if obName == 'Fornalha' then
                                        local firingSlot = getElementData(inv.lootOb, 'furnance:firingSlot')
                                        if firingSlot and firingSlot == hover.id then
                                            setInvMessage(translate('slot está sendo usado'))
                                            return
                                        end
                                    end
                                end
                            
                            end
                            if element and isElement(element) then
                                local maxSlots = getElementData(element, 'maxSlots') or 0
                                if table.size(inv.order[hoverSource]) < maxSlots then
                                    startLoadingProcess(50, hoverButton, function()
                                        if hoverSource == 'inv' then
                                            if inv.selected and inv.selected.id == hover.id then
                                                setSelectedItem(false)
                                            end
                                            triggerServerEvent('inv:splitItem', localPlayer, localPlayer, hover.id)
                                        else
                                            triggerServerEvent('inv:splitItem', localPlayer, inv.lootOb, hover.id)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif released then
        local drag = inv.drag
        local dragSource = drag and drag.source
        if dragSource then
            
            if (not hover) then
                setSelectedItem(false)
                return inv.toggleDrag(false)
            end
            
            if inv.selected then
                if (inv.selected.id ~= drag.id) or (inv.selected.id ~= hover.id) then
                    setSelectedItem(false)
                end
            end
            
            if hover and hover.id and waitingResponse[hover.id] then
                return inv.toggleDrag(false)
            end
            
            if inv.refreshingInv[hoverSource] then
                return inv.toggleDrag(false)
            end
            
            if hover or dragSource == 'keybar' then
                -- SOLTOU ITEM DO INVENTARIO
                if dragSource == 'inv' then
                    -- NO PROPRIO INVENTARIO
                    if hoverSource == 'inv' then
                        if hover.id ~= drag.id then
                            blockInventoryID('inv', drag.id)
                            triggerServerEvent('inv:moveItem', localPlayer, localPlayer, drag.id, hover.id, 'inv')
                        end
                    
                    -- NO LOOT
                    elseif hoverSource == 'loot' then
                        if isElement(inv.lootOb) then
                            local obName = getElementData(inv.lootOb, 'obName')
                            if obName == 'Fornalha' then
                                local firingSlot = getElementData(inv.lootOb, 'furnance:firingSlot')
                                if firingSlot and firingSlot == hover.id then
                                    setInvMessage(translate('slot está sendo usado'))
                                    return inv.toggleDrag(false)
                                end
                                if not getItemFurnanceSettings(drag.itemName) then
                                    setInvMessage(translate('Este item não pode ser colocado aqui'))
                                    return inv.toggleDrag(false)
                                end
                            elseif obName == 'Mesa de pesquisa' then
                                if hover.id == 1 then
                                    if not getPlayerDataSetting(drag.itemName, 'researchTableNeeds') then
                                        setInvMessage(translate('item nao pode ser aprendido'))
                                        return inv.toggleDrag(false)
                                    end
                                elseif hover.id == 2 then
                                    if drag.itemName ~= 'Scrap Metal' then
                                        setInvMessage(translate('Este item não pode ser colocado aqui'))
                                        return inv.toggleDrag(false)
                                    end
                                else
                                    return inv.toggleDrag(false)
                                end
                            end
                        end
                        
                        blockInventoryID('loot', hover.id, false, true)
                        blockInventoryID('inv', drag.id)
                        triggerServerEvent('inv:dropItem', localPlayer, drag.id, hover.id, inv.lootOb, 'inv', 'loot')
                    
                    -- NA KEYBAR
                    elseif hoverSource == 'keybar' then
                        blockInventoryID('keybar', hover.id, false, true)
                        blockInventoryID('inv', drag.id)
                        triggerServerEvent('inv:putItemOnKeybar', localPlayer, drag.itemName, drag.quantity, drag.id, hover.id, 'inv', 'keybar')
                    
                    -- NOS ITENS EQUIPADOS
                    elseif hoverSource == 'pedSide' then
                        if wearables[getItemType(drag.itemName)] then
                            blockInventoryID('pedSide', hover.id, false, true)
                            blockInventoryID('inv', drag.id)
                            triggerServerEvent('inv:putItemOnEquippedItems', localPlayer, drag.id, hover.id, 'inv', 'pedSide')
                        end
                    end
                
                -- SOLTOU ITEM DO LOOT
                elseif dragSource == 'loot' then
                    -- NO PROPRIO LOOT
                    if hoverSource == 'loot' then
                        if (drag.id ~= hover.id) then
                            if isElement(inv.lootOb) then
                                local obName = getElementData(inv.lootOb, 'obName')
                                if obName == 'Fornalha' then
                                    local firingSlot = getElementData(inv.lootOb, 'furnance:firingSlot')
                                    if firingSlot and firingSlot == hover.id then
                                        setInvMessage(translate('slot está sendo usado'))
                                        return inv.toggleDrag(false)
                                    end
                                    if not getItemFurnanceSettings(drag.itemName) then
                                        setInvMessage(translate('Este item não pode ser colocado aqui'))
                                        return inv.toggleDrag(false)
                                    end
                                elseif obName == 'Mesa de pesquisa' then
                                    return inv.toggleDrag(false)
                                end
                            end
                            
                            blockInventoryID('loot', drag.id)
                            triggerServerEvent('inv:moveItem', localPlayer, inv.lootOb, drag.id, hover.id, 'loot')
                        end
                    
                    -- NO INVENTARIO
                    elseif hoverSource == 'inv' then
                        blockInventoryID('inv', hover.id, false, true)
                        blockInventoryID('loot', drag.id)
                        triggerServerEvent('inv:takeItem', localPlayer, inv.lootOb, hover.id, drag.id, 'loot', 'inv')
                    
                    -- NA KEYBAR
                    elseif hoverSource == 'keybar' then
                        blockInventoryID('keybar', hover.id, false, true)
                        blockInventoryID('loot', drag.id)
                        triggerServerEvent('inv:takeItemToKeybar', localPlayer, inv.lootOb, drag.id, hover.id, 'loot', 'keybar')
                    -- NOS ITENS EQUIPADOS
                    elseif hoverSource == 'pedSide' then
                        if wearables[getItemType(drag.itemName)] then
                            blockInventoryID('pedSide', hover.id, false, true)
                            blockInventoryID('loot', drag.id)
                            triggerServerEvent('inv:takeItemToEquippedItems', localPlayer, inv.lootOb, drag.id, hover.id, 'loot', 'pedSide')
                        end
                    end
                
                -- SOLTOU ITEM DA KEYBAR
                elseif dragSource == 'keybar' then
                    -- NA PROPRIA KEYBAR
                    if hoverSource == 'keybar' then
                        if drag.id ~= hover.id then
                            blockInventoryID('keybar', drag.id)
                            triggerServerEvent('inv:moveItemOnKeyBar', localPlayer, drag.id, hover.id)
                        end
                    
                    -- NO INVENTARIO
                    elseif hoverSource == 'inv' then
                        if table.size(inv.order[hoverSource]) < inv.maxSlots[hoverSource] then
                            blockInventoryID('inv', hover.id, false, true)
                            blockInventoryID('keybar', drag.id)
                            triggerServerEvent('inv:removeItemFromKeyBar', localPlayer, drag.id, hover.id, localPlayer, 'keybar', 'inv')
                        end
                    
                    -- NO LOOT
                    elseif hoverSource == 'loot' then
                        if table.size(inv.order[hoverSource]) < inv.maxSlots[hoverSource] then
                            if isElement(inv.lootOb) then
                                local obName = getElementData(inv.lootOb, 'obName')
                                if obName == 'Fornalha' then
                                    local firingSlot = getElementData(inv.lootOb, 'furnance:firingSlot')
                                    if firingSlot and firingSlot == hover.id then
                                        setInvMessage(translate('slot está sendo usado'))
                                        return inv.toggleDrag(false)
                                    end
                                    if not getItemFurnanceSettings(drag.itemName) then
                                        setInvMessage(translate('Este item não pode ser colocado aqui'))
                                        return inv.toggleDrag(false)
                                    end
                                end
                            end
                            
                            blockInventoryID('loot', hover.id, false, true)
                            blockInventoryID('keybar', drag.id)
                            triggerServerEvent('inv:removeItemFromKeyBar', localPlayer, drag.id, hover.id, inv.lootOb, 'keybar', 'loot')
                        end
                    
                    -- NOS ITENS EQUIPADOS
                    elseif hoverSource == 'pedSide' then
                        if wearables[getItemType(drag.itemName)] then
                            blockInventoryID('pedSide', hover.id, false, true)
                            blockInventoryID('keybar', drag.id)
                            triggerServerEvent('inv:removeItemFromKeyBarAndPutOnEquipped', localPlayer, drag.itemName, drag.id, hover.id, 'keybar', 'pedSide')
                        end
                    
                    end
                
                -- SOLTOU ITEM DOS ITENS EQUIPADOS
                elseif dragSource == 'pedSide' then
                    -- NOS PROPRIOS ITENS EQUIPADOS
                    if hoverSource == 'pedSide' then
                        if drag.id ~= hover.id then
                            blockInventoryID('pedSide', drag.id)
                            triggerServerEvent('inv:moveItemOnEquippedItems', localPlayer, drag.id, hover.id)
                        end
                    
                    -- NO INVENTARIO
                    elseif hoverSource == 'inv' then
                        blockInventoryID('inv', hover.id, false, true)
                        blockInventoryID('pedSide', drag.id)
                        triggerServerEvent('inv:putEquippedItemOnInventory', localPlayer, drag.id, hover.id, 'pedSide', 'inv')
                    
                    -- NO LOOT
                    elseif hoverSource == 'loot' then
                        if isElement(inv.lootOb) then
                            local obName = getElementData(inv.lootOb, 'obName')
                            if obName == 'Fornalha' then
                                local firingSlot = getElementData(inv.lootOb, 'furnance:firingSlot')
                                if firingSlot and firingSlot == hover.id then
                                    setInvMessage(translate('slot está sendo usado'))
                                    return inv.toggleDrag(false)
                                end
                                if not getItemFurnanceSettings(drag.itemName) then
                                    setInvMessage(translate('Este item não pode ser colocado aqui'))
                                    return inv.toggleDrag(false)
                                end
                            end
                        end
                        blockInventoryID('loot', hover.id, false, true)
                        blockInventoryID('pedSide', drag.id)
                        triggerServerEvent('inv:putEquippedItemOnLootOb', localPlayer, inv.lootOb, drag.id, hover.id, 'pedSide', 'loot')
                    
                    -- NA KEYBAR
                    elseif hoverSource == 'keybar' then
                        blockInventoryID('keybar', hover.id, false, true)
                        blockInventoryID('pedSide', drag.id)
                        triggerServerEvent('inv:putEquippedItemOnKeybar', localPlayer, drag.id, hover.id, 'pedSide', 'keybar')
                    
                    end
                end
            end
            
            inv.toggleDrag(false)
        end
    end
end

local projectileNameFromID = {
    [39] = 'C4',
    [18] = 'Beans Can Grenade',
    [16] = 'Grenade',
    [17] = 'Tear Gas',
}

function projectileCreation(creator)
    if (creator == localPlayer) then
        local type = getProjectileType(source)
        local weaponName = projectileNameFromID[type]
        if weaponName then
            local equippedItem = getElementData(localPlayer, 'equippedItem')
            if (weaponName == equippedItem) then
                local equippedID = getElementData(localPlayer, 'equippedSlotID')
                local order = getElementData(localPlayer, 'keybarOrder')
                if order and order[equippedID] and order[equippedID].itemName == equippedItem then
                    
                    order[equippedID].quantity = order[equippedID].quantity - 1
                    if order[equippedID].quantity <= 0 then
                        order[equippedID] = nil
                    end
                    
                    setElementData(localPlayer, 'keybarOrder', order)
                    disequipKeySlot(inv.selectedKeyBarSlot)
                    
                    triggerServerEvent('detachItemFromBone', localPlayer, weaponName, localPlayer)
                    setElementData(localPlayer, 'equippedItem', nil)
                    setElementData(localPlayer, 'equippedSlotID', nil)
                end
            end
        end
    end
end
addEventHandler('onClientProjectileCreation', root, projectileCreation)

addEventHandler('onClientElementDataChange', localPlayer, function(key, old, new)
    local equippedItem = getElementData(localPlayer, 'equippedItem')
    if equippedItem then
        local ammo = getPlayerDataSetting(equippedItem, 'ammo')
        if ammo then
            if (key == ammo.name) then
                local weaponID, slotID
                local weaponConfig = getPlayerDataSetting(equippedItem, 'weaponSettings')
                if weaponConfig then
                    weaponID = weaponConfig.weapID
                    slotID = weaponConfig.slotID
                end
                if weaponID and slotID then
                    if (not new) or (new < 1) then
                        playerUseItem(equippedItem, inv.selectedKeyBarSlot)
                    else
                        triggerServerEvent('rust:onAmmoChange', localPlayer, weaponID, new, slotID)
                    end
                end
            end
        end
    end
end)
