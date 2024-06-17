local showingLootSlots = false

local requires = {'Wood', 'Stone', 'Iron', 'Metal de Alta'}
local requiresCache = {}

function initLootSlots()
    local w = inv.size.x * (inv.boxSize + inv.margin)
    local posX = sW * 0.5 + (w * 0.5) + pixels(10)
    local posY = sH * 0.17 + sH * 0.2

    inv.gui.refreshLoot = UI:CreateImageWithBG(posX, posY, pixels(25), pixels(25),
                              ':gamemode/files/images/ui/reload.png', false, inv.gui.bg, {
            bgColor = color('inv:boxColor'),
            imgColor = {210, 190, 175, 250}
        })

    inv.gui.lootName = UI:createText(posX + pixels(26), posY - inv.margin, w, pixels(25), 'LOOT', false, inv.gui.bg, {
        ['text-align-x'] = 'left',
        ['font'] = cfont('franklin:medium', 'gui')
    })

    local thisID = 0
    for yy = 1, inv.size.y do
        for xx = 1, inv.size.x do
            thisID = thisID + 1
            local x = posX + (xx - 1) * (inv.boxSize + inv.margin)
            local y = posY + (yy - 1) * (inv.boxSize + inv.margin) + pixels(25) + inv.margin
            createInvSlot('loot', x, y, inv.boxSize, inv.boxSize, thisID)
        end
    end

    addEventHandler('onClientGUIClick', inv.gui.refreshLoot, function()
        inv.refreshingInv['loot'] = true
        startLoadingProcess(20, source, function()
            setSelectedItem(false)
            triggerServerEvent('inv:reorganize', resourceRoot, inv.lootOb)
            inv.refreshingInv['loot'] = nil
        end)
    end, false)

    guiSetVisible(getElementParent(inv.gui.refreshLoot), false)
    guiSetVisible(inv.gui.lootName, false)

    do
        local h = sH * 0.2 - inv.margin
        inv.gui['Wardrobe'] = {}
        inv.gui['Wardrobe'].background = UI:CreateRectangle(posX, sH * 0.17, w, h, false, inv.gui.bg, {
            ['bgColor'] = color('inv:boxColor')
        })
        UI:createText(5, 0, w - 10, h - inv.boxSize - inv.margin, translate('armario texto'), false,
            inv.gui['Wardrobe'].background, {
                ['font'] = cfont('franklin', 'gui')
            })
        inv.gui['Wardrobe'].Buttons = {}
        local slotsWidth = #requires * (inv.boxSize + inv.margin)
        local centerX = (w / 2) - slotsWidth / 2
        for k, v in ipairs(requires) do
            local x = centerX + (inv.boxSize + inv.margin) * (k - 1)
            inv.gui['Wardrobe'].Buttons[v] = {}
            inv.gui['Wardrobe'].Buttons[v].bg = UI:CreateRectangle(x, h - inv.boxSize - inv.margin, inv.boxSize,
                                                    inv.boxSize, false, inv.gui['Wardrobe'].background, {
                    ['bgColor'] = color('inv:boxColor')
                })
            local icon = guiCreateStaticImage(x, h - inv.boxSize - inv.margin, inv.boxSize, inv.boxSize, getItemIcon(v),
                             false, inv.gui['Wardrobe'].background, {
                    ['bgColor'] = color('inv:boxColor')
                })
            inv.gui['Wardrobe'].Buttons[v].quantity = UI:createText(0, 0, 1, 1, '0/0', true, icon, {
                ['font'] = cfont('franklin', 'gui'),
                ['text-align-x'] = 'right',
                ['text-align-y'] = 'bottom'
            })
        end
    end

    do
        local h = inv.size.y * (inv.boxSize + inv.margin)
        inv.gui['Fornalha'] = {}

        inv.gui['Fornalha'].background = UI:CreateRectangle(posX, sH * 0.45 + inv.margin, w - inv.margin, h, false,
                                             inv.gui.bg, {
                ['bgColor'] = color('inv:boxColor')
            })
        guiCreateStaticImage(0, 0, h, h, 'files/images/objects/fornalha.png', false, inv.gui['Fornalha'].background)

        inv.gui['Fornalha'].bgTarget = UI:CreateRectangle(h, h * 0.1, inv.boxSize, inv.boxSize, false,
                                           inv.gui['Fornalha'].background, {
                ['bgColor'] = color('inv:boxColor')
            })
        inv.gui['Fornalha'].imgTarget = guiCreateStaticImage(0, 0, inv.boxSize, inv.boxSize, 'files/images/ui/fire.png',
                                            false, inv.gui['Fornalha'].bgTarget)
        inv.gui['Fornalha'].lblTarget = UI:createText(1, 0, inv.boxSize, inv.boxSize, '0', false,
                                            inv.gui['Fornalha'].imgTarget, {
                ['text-align-x'] = 'right',
                ['text-align-y'] = 'top'
            })
        inv.gui['Fornalha'].bgFiring = UI:CreateRectangle(h, h * 0.4, inv.boxSize, inv.boxSize, false,
                                           inv.gui['Fornalha'].background, {
                ['bgColor'] = color('inv:boxColor')
            })
        inv.gui['Fornalha'].imgFiring = guiCreateStaticImage(0, 0, inv.boxSize, inv.boxSize, 'files/images/ui/fire.png',
                                            false, inv.gui['Fornalha'].bgFiring)
        inv.gui['Fornalha'].lblFiring = UI:createText(1, 0, inv.boxSize, inv.boxSize, '0', false,
                                            inv.gui['Fornalha'].imgFiring, {
                ['text-align-x'] = 'right',
                ['text-align-y'] = 'top'
            })

        local bg = UI:CreateRectangle(h, h * 0.7, inv.boxSize, inv.boxSize, false, inv.gui['Fornalha'].background, {
            ['bgColor'] = color('inv:boxColor')
        })

        guiCreateStaticImage(0, 0, inv.boxSize, inv.boxSize, 'files/images/ui/fire.png', false, bg)

        local percentbg = UI:CreateRectangle(0, h - 10, w - inv.margin, 10, false, inv.gui['Fornalha'].background, {
            ['bgColor'] = color('inv:boxColor')
        })

        inv.gui['Fornalha'].percent = UI:CreateRectangle(0, 0, (w - inv.margin) / 2, 10, false, percentbg, {
            ['bgColor'] = {255, 255, 0, 100}
        })
    end

    do
        local posY = posY + pixels(25) + inv.margin

        local margin = 4

        local h = (inv.size.y - 1) * (inv.boxSize + inv.margin)

        inv.gui['MesaPesquisa'] = {}

        inv.gui['MesaPesquisa'].background = UI:CreateRectangle(posX, posY, w - inv.margin,
                                                 h + inv.boxSize + inv.margin, false, inv.gui.bg, {
                ['bgColor'] = {0, 0, 0, 0}
            })

        local bgItemToResearch = UI:CreateRectangle(inv.boxSize * 2 + margin, 0, w - inv.boxSize * 2 + margin,
                                     inv.boxSize * 2, false, inv.gui['MesaPesquisa'].background, {
                bgColor = color('inv:boxColor')
            })

            inv.gui['MesaPesquisa'].itemToLearn = UI:createText(0.025, 0.025, 1, 1, translate('item a aprender'), true, bgItemToResearch, {
            ['text-align-x'] = 'left',
            ['text-align-y'] = 'top',
            ['font'] = cfont('franklin:medium')
        })

        do -- run button
            local wButton = 0.3
            local hButton = 0.3
            local bgButton = UI:CreateRectangle(1 - wButton, 1 - hButton, wButton, hButton, true, bgItemToResearch, {
                bgColor = color('inv:boxColor:selected')
            })

            local label = UI:createText(0, 0, 1, 1, translate('Confirmar'), true, bgButton, {
                ['text-align-x'] = 'center',
                ['text-align-y'] = 'center',
                ['font'] = cfont('franklin')
            })

            addEventHandler('onClientGUIClick', label, function()
                if inv.lootOb and isElement(inv.lootOb) then
                    if getElementData(localPlayer, 'WaitingResponse') then
                        return
                    end
                    setElementData(localPlayer, 'WaitingResponse', true)
                    triggerServerEvent('runResearchTable', localPlayer, inv.lootOb)
                end
            end, false)

            addEventHandler('onClientMouseEnter', label, function()
                UI:SetRectangleColor(bgButton, color('inv:boxColor:selected2'))
            end, false)

            addEventHandler('onClientMouseLeave', label, function()
                UI:SetRectangleColor(bgButton, color('inv:boxColor:selected'))
            end)
        end

        local bgCustoText = UI:CreateRectangle(0, inv.boxSize * 2 + margin, w - inv.boxSize * 2 + margin,
                                inv.boxSize * 1.97, false, inv.gui['MesaPesquisa'].background, {
                bgColor = color('inv:boxColor')
            })

        inv.gui['MesaPesquisa'].custoString = UI:createText(0.025, 0.025, 1, 0.3, translate('research cost'), true, bgCustoText, {
            ['text-align-x'] = 'left',
            ['text-align-y'] = 'top',
            ['font'] = cfont('franklin:medium')
        })

        inv.gui['MesaPesquisa'].custoString2 = UI:createText(0.025, 0.3, 1, 0.7, translate('research cost 2', nil, translate('Scrap Metal', 'name')), true,
            bgCustoText, {
                ['text-align-x'] = 'left',
                ['text-align-y'] = 'top',
                ['font'] = cfont('franklin')
            })

        local x = w - inv.boxSize * 2 + margin * 2
        local bgCusto = UI:CreateRectangle(x, inv.boxSize * 2 + margin, w - x, inv.boxSize * 1.97, false,
                            inv.gui['MesaPesquisa'].background, {
                bgColor = color('inv:boxColor')
            })

        inv.gui['MesaPesquisa'].Custo = UI:createText(0, 0, 1, 1, '0', true, bgCusto, {
            ['text-align-x'] = 'center',
            ['text-align-y'] = 'center',
            ['font'] = cfont('franklin:medium2')
        })

        local bgItemToResearch = UI:CreateRectangle(inv.boxSize * 2 + margin,
                                     inv.boxSize * 2 + margin * 2 + inv.boxSize * 1.97, w - inv.boxSize * 2 + margin,
                                     inv.boxSize * 2, false, inv.gui['MesaPesquisa'].background, {
                bgColor = color('inv:boxColor')
            })

        UI:createText(0.025, 0.025, 1, 0.3, translate('scrap to use', nil, translate('Scrap Metal', 'name')), true,
            bgItemToResearch, {
                ['text-align-x'] = 'left',
                ['text-align-y'] = 'top',
                ['font'] = cfont('franklin:medium')
            })

        UI:createText(0.025, 0.3, 0.975, 0.7, translate('scrap to use2', nil, translate('Scrap Metal', 'name')), true,
            bgItemToResearch, {
                ['text-align-x'] = 'left',
                ['text-align-y'] = 'top',
                ['font'] = cfont('franklin')
            })

    end

    do
        local posY = posY + pixels(25) + inv.margin


        local h = (inv.size.y - 1) * (inv.boxSize + inv.margin)

        inv.gui['Recycler'] = {}

        inv.gui['Recycler'].background = UI:CreateRectangle(posX, posY, w - inv.margin, h + inv.boxSize + inv.margin,
                                             false, inv.gui.bg, {
                ['bgColor'] = {0, 0, 0, 0}
            })

        local bgItemToResearch = UI:CreateRectangle(0, 0, w, inv.boxSize / 2, false, inv.gui['Recycler'].background, {
            bgColor = color('inv:boxColor')
        })

        UI:createText(0.025, 0.025, 1, 1, translate('input'), true, bgItemToResearch, {
            ['text-align-x'] = 'left',
            ['text-align-y'] = 'top',
            ['font'] = cfont('franklin:medium')
        })

        local bgItemToReceive = UI:CreateRectangle(0, inv.boxSize + inv.boxSize / 2 + 2, w, inv.boxSize / 2, false,
                                    inv.gui['Recycler'].background, {
                bgColor = color('inv:boxColor')
            })

        UI:createText(0.025, 0.025, 1, 1, translate('output'), true, bgItemToReceive, {
            ['text-align-x'] = 'left',
            ['text-align-y'] = 'top',
            ['font'] = cfont('franklin:medium')
        })

        local bgConfirm = UI:CreateRectangle(0, inv.boxSize * 3 + 5, w, inv.boxSize, false,
                              inv.gui['Recycler'].background, {
                bgColor = color('inv:boxColor')
            })

        local wButton = inv.boxSize * 2
        local hButton = inv.boxSize - 10
        local bgButton = UI:CreateRectangle(5, 5, wButton, hButton, false, bgConfirm, {
            bgColor = color('inv:boxColor:selected')
        })

        local label = UI:createText(0, 0, 1, 1, translate('Confirmar'), true, bgButton, {
            ['text-align-x'] = 'center',
            ['text-align-y'] = 'center',
            ['font'] = cfont('franklin:medium')
        })

        addEventHandler('onClientGUIClick', label, function()
            if inv.lootOb and isElement(inv.lootOb) then
                if getElementData(localPlayer, 'WaitingResponse') then
                    return
                end
                setElementData(localPlayer, 'WaitingResponse', true)
                triggerServerEvent('runRecycler', localPlayer, inv.lootOb)
            end
        end, false)

        addEventHandler('onClientMouseEnter', label, function()
            UI:SetRectangleColor(bgButton, color('inv:boxColor:selected2'))
        end, false)

        addEventHandler('onClientMouseLeave', label, function()
            UI:SetRectangleColor(bgButton, color('inv:boxColor:selected'))
        end)

        UI:createText(wButton + 10, 5, w - wButton - 15, hButton, translate('recycler info'), false, bgConfirm, {
            ['text-align-x'] = 'center',
            ['text-align-y'] = 'center',
            ['font'] = cfont('franklin')
        })

    end

    guiSetVisible(inv.gui['Recycler'].background, false)
    guiSetVisible(inv.gui['Wardrobe'].background, false)
    guiSetVisible(inv.gui['Fornalha'].background, false)
    guiSetVisible(inv.gui['MesaPesquisa'].background, false)
end

function toggleLootSlots(state)
    if state and showingLootSlots then
        return
    end

    if state then
        local maxSlots = getElementData(inv.lootOb, 'maxSlots') or 0
        for k, v in ipairs(inv.gui.slots.loot) do
            guiSetVisible(v.bg, k <= maxSlots)
        end

        inv.maxSlots.loot = maxSlots

        local obName = getElementData(inv.lootOb, 'obName')
        local mainObName = obName

        if string.find(translate(obName, 'name'), 'translate error:') then
            obName = translate(obName)
        else
            obName = translate(obName, 'name')
        end
        if obName:find('translate error:') then
            obName = mainObName
        end

        guiSetText(inv.gui.lootName, obName)

    else
        for k, v in ipairs(inv.gui.slots.loot) do
            guiSetVisible(v.bg, false)
        end
    end

    guiSetVisible(getElementParent(inv.gui.refreshLoot), state)
    guiSetVisible(inv.gui.lootName, state)

    showingLootSlots = state
end

function inv.setLootSource(ob)
    if ob and isElement(ob) then
        inv.lootOb = ob
        addEventHandler('onClientElementDataChange', ob, onLootDataChange)
        addEventHandler('onClientElementDestroy', ob, removeLootSourceWhenDestroy)
        toggleBluePrints(false)
        toggleLootSlots(true)

        triggerServerEvent('saveOpenInventoryLogs', localPlayer, ob)

        local order = getElementData(ob, 'invOrder') or {}
        local add, remove = orderDifference(inv.order.loot or {}, order)
        inv.order.loot = order
        onOrderChange('loot', add, remove)

        local obName = getElementData(ob, 'obName')
        guiSetVisible(inv.gui['Wardrobe'].background, obName == 'Wardrobe')
        guiSetVisible(inv.gui['Fornalha'].background, obName == 'Fornalha')
        guiSetVisible(inv.gui['MesaPesquisa'].background, obName == 'Mesa de pesquisa')
        guiSetVisible(inv.gui['Recycler'].background, obName == 'Recycler')

        local possibleSounds = obName and getObjectPossibleSounds(obName)
        if possibleSounds and (not getElementData(localPlayer, 'Flying')) then
            local x, y, z = getElementPosition(ob)
            triggerServerEvent('rust:play3DSound', localPlayer,
                (':gamemode/files/sounds/%s'):format(table.random(possibleSounds)), {x, y, z})
        end

        if obName == 'Wardrobe' then
            local neededQuant = getRequiresByOwner(getElementData(ob, 'owner'))
            requiresCache = neededQuant

            for k, v in ipairs(requires) do
                guiSetText(inv.gui['Wardrobe'].Buttons[v].quantity,
                    ('%s/%s'):format(getElementData(ob, v) or 0, neededQuant[v]))
            end

            addEventHandler('onClientElementDataChange', ob, onWardrobeDataChange)

        elseif obName == 'Fornalha' then
            addEventHandler('onClientElementDataChange', ob, onFornalhaDataChange)

            local firing = getElementData(ob, 'furnance:firing')
            if firing then
                local settings = getItemFurnanceSettings(firing)

                local percent = getElementData(ob, 'furnance:progress') or 0
                local w = inv.size.x * (inv.boxSize + inv.margin)
                guiSetSize(inv.gui['Fornalha'].percent, w * percent / 100, 20, false)

                guiStaticImageLoadImage(inv.gui['Fornalha'].imgFiring, getItemIcon(firing))
                guiSetText(inv.gui['Fornalha'].lblFiring, ('%s'):format(settings.needed))

                guiStaticImageLoadImage(inv.gui['Fornalha'].imgTarget, getItemIcon(settings.receive[1]))
                guiSetText(inv.gui['Fornalha'].lblTarget, ('%s'):format(settings.receive[2]))
            end

            guiSetVisible(inv.gui['Fornalha'].percent, firing and true or false)
            guiSetVisible(inv.gui['Fornalha'].imgTarget, firing and true or false)
            guiSetVisible(inv.gui['Fornalha'].imgFiring, firing and true or false)

        elseif obName == 'Mesa de pesquisa' then
            addEventHandler('onClientElementDataChange', ob, onMesadePesquisaDataChange)

            local w = inv.boxSize * 2
            for i = 1, 2 do
                guiSetSize(inv.gui.slots['loot'][i].bg, w, w, false)
                inv.gui.slots['loot'][i].size = w
            end

            local x = guiGetPosition(inv.gui.slots['loot'][1].bg, false)

            local margin = 4

            local posY = sH * 0.17 + sH * 0.2 + pixels(25) + inv.margin
            posY = posY + inv.boxSize * 2 + margin * 2 + inv.boxSize * 1.97

            guiSetPosition(inv.gui.slots['loot'][2].bg, x, posY, false)

            local order = inv.order['loot']
            if order then
                local itemName = order[1] and order[1].itemName
                local quantity = order[1] and order[1].quantity
                if itemName and quantity then
                    local custo = getPlayerDataSetting(itemName, 'researchTableNeeds')
                    guiSetText(inv.gui['MesaPesquisa'].Custo, (custo and custo * quantity) or '0')
                else
                    guiSetText(inv.gui['MesaPesquisa'].Custo, '0')
                end
            else
                guiSetText(inv.gui['MesaPesquisa'].Custo, '0')
            end
            guiSetText(inv.gui['MesaPesquisa'].custoString, translate('research cost'))
            guiSetText(inv.gui['MesaPesquisa'].custoString2, translate('research cost 2', nil, translate('Scrap Metal', 'name')))
            guiSetText(inv.gui['MesaPesquisa'].itemToLearn, translate('item a aprender'))

        elseif obName == 'Recycler' then
            for i = 1, 14 do
                local x, y = guiGetPosition(inv.gui.slots['loot'][i].bg, false)

                local posY

                if i <= 7 then
                    posY = y + inv.boxSize / 2 + 1
                else
                    posY = y + inv.boxSize + 3
                end

                guiSetPosition(inv.gui.slots['loot'][i].bg, x, posY, false)
            end
            guiSetVisible(getElementParent(inv.gui.refreshLoot), false)
            guiSetVisible(inv.gui.lootName, false)
        end
    else
        for i = 1, 14 do
            local w = inv.boxSize
            guiSetSize(inv.gui.slots['loot'][i].bg, w, w, false)
            inv.gui.slots['loot'][i].size = w
            
            local x, y = unpack(inv.gui.slots['loot'][i].pos)
            guiSetPosition(inv.gui.slots['loot'][i].bg, x, y, false)
        end

        guiSetText(inv.gui['MesaPesquisa'].Custo, '0')

        if inv.lootOb and isElement(inv.lootOb) then
            removeEventHandler('onClientElementDataChange', inv.lootOb, onLootDataChange)
            removeEventHandler('onClientElementDataChange', inv.lootOb, onWardrobeDataChange)
            removeEventHandler('onClientElementDataChange', inv.lootOb, onFornalhaDataChange)
            removeEventHandler('onClientElementDataChange', inv.lootOb, onMesadePesquisaDataChange)
            removeEventHandler('onClientElementDestroy', inv.lootOb, removeLootSourceWhenDestroy)
        end
        inv.lootOb = nil
        toggleLootSlots(false)
        toggleBluePrints(true)

        guiSetVisible(inv.gui['Wardrobe'].background, false)
        guiSetVisible(inv.gui['Fornalha'].background, false)
        guiSetVisible(inv.gui['MesaPesquisa'].background, false)
        guiSetVisible(inv.gui['Recycler'].background, false)
    end
end

setTimer(function()
    if (not isElement(inv.lootOb)) then
        return false
    end

    local x,y,z = getElementPosition(localPlayer)
    local xx,yy,zz = getElementPosition(inv.lootOb)

    if (getDistanceBetweenPoints3D(x, y, z, xx, yy, zz) <= 5) then
        return false
    end

    inv.setLootSource(false)
end, 500, 0)

setLootSource = function(ob)
    return inv.setLootSource(ob)
end

function removeLootSourceWhenDestroy()
    inv.setLootSource(false)
    toggleBluePrints(true)
end

onWardrobeDataChange = function(key, old, new)
    if (key == 'Wood') then
        guiSetText(inv.gui['Wardrobe'].Buttons[key].quantity, ('%s/%s'):format(new or 0, requiresCache[key]))
    elseif (key == 'Stone') then
        guiSetText(inv.gui['Wardrobe'].Buttons[key].quantity, ('%s/%s'):format(new or 0, requiresCache[key]))
    elseif (key == 'Iron') then
        guiSetText(inv.gui['Wardrobe'].Buttons[key].quantity, ('%s/%s'):format(new or 0, requiresCache[key]))
    end
end

onFornalhaDataChange = function(key, old, new)
    if (key == 'furnance:firing') then
        local firing = new
        if firing then
            local settings = getItemFurnanceSettings(firing)

            guiSetSize(inv.gui['Fornalha'].percent, 0, 20, false)

            guiStaticImageLoadImage(inv.gui['Fornalha'].imgFiring, getItemIcon(firing))
            guiSetText(inv.gui['Fornalha'].lblFiring, ('%s'):format(settings.needed))

            guiStaticImageLoadImage(inv.gui['Fornalha'].imgTarget, getItemIcon(settings.receive[1]))
            guiSetText(inv.gui['Fornalha'].lblTarget, ('%s'):format(settings.receive[2]))
        end

        guiSetVisible(inv.gui['Fornalha'].percent, firing and true or false)
        guiSetVisible(inv.gui['Fornalha'].imgTarget, firing and true or false)
        guiSetVisible(inv.gui['Fornalha'].imgFiring, firing and true or false)

    elseif (key == 'furnance:progress') and new then
        local w = inv.size.x * (inv.boxSize + inv.margin)
        guiSetSize(inv.gui['Fornalha'].percent, w * new / 100, 20, false)
        
    end
end

onMesadePesquisaDataChange = function(key, old, new)
    local needs = isItemOfInventory(key) and getPlayerDataSetting(key, 'researchTableNeeds')
    if needs then
        guiSetText(inv.gui['MesaPesquisa'].Custo, needs)
    end
end
