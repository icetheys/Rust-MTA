local window

local resetableItems = {'baseItems', 'Wardrobe', 'Baú Pequeno', 'Baú Grande', 'Water Barrel', 'Fornalha', 'Fogueira',
                        'Mesa de pesquisa', 'Poço', 'Sandbags', 'Barricade', 'Placa', 'Planter', 'Cama', 'Workbench',
                        'Fixed Torch', 'Sentry'}

toggleReset = function(state)
    if isElement(window) then
        destroyElement(window)
        showCursor(state)
    end

    if state then
        if activeUI then
            return
        end
        activeUI = 'Reset'

        local w, h = pixels(550), pixels(385)
        local margin = 1

        window = UI:CreateRectangle((sW - w) / 2, (sH - h) / 2, w, h, false, nil, {
            ['bgColor'] = {210, 190, 175, 250}
        })

        local iconW = w * 0.45

        local list = UI:CreateList(margin, margin, w - iconW - margin * 2, h - margin * 2, false, window, {})

        local icon = UI:CreateImageWithBG(w - iconW, margin, iconW - margin, iconW - margin, getObjectIcon('Wardrobe'),
                         false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

        local btnConfirm = UI:CreateButton(w - iconW, iconW + margin, iconW - margin, pixels(66),
                               translate('Destruir'), false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

        local btnCancel = UI:CreateButton(w - iconW, h - pixels(66) - margin, iconW - margin, pixels(66),
                              translate('Cancelar'), false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

        local cache = {}
        for k, v in ipairs(resetableItems) do
            local display = translate(v, 'name')
            display = ('%s [%s/%s]'):format(display, getElementData(localPlayer, v) or 0, getObjectLimit(v, localPlayer) or 0)
            cache[display] = v
            UI:addListItem(list, display)
        end

        addEventHandler('ui:onSelectListItem', list, function(selected)
            local cache = cache[selected]
            guiStaticImageLoadImage(icon, getObjectIcon(cache))
        end)

        addEventHandler('onClientGUIClick', btnCancel, function()
            toggleReset(false)
        end, false)

        addEventHandler('onClientGUIClick', btnConfirm, function()
            local selected = UI:getSelectedListItem(list)
            local cache = cache[selected]
            triggerServerEvent('rust:resetItems', localPlayer, cache)
            toggleReset(false)
        end, false)
    else
        activeUI = nil
    end
    showCursor(state)
end

addCommandHandler('reset', function()
    if getElementData(localPlayer, 'account') and not getElementData(localPlayer, 'isDead') then
        toggleReset(true)        
    end
end)
