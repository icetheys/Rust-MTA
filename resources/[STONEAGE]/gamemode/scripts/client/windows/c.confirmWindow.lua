local window

function showConfirmWindow(state, options)
    if isElement(window) then
        destroyElement(window)
        showCursor(false)
        toggleControl('fire', true)
    end

    if state and options then
        if activeUI then
            return
        end
        activeUI = true

        local margin = 1

        local btnConfirm, btnCancel

        if options.reason == 'destroyObject' then
            local w, h = pixels(400), pixels(250)
            window = UI:CreateRectangle(sW * 0.5 - w / 2, sH * 0.5 - h / 2, w, h, false, nil, {
                ['bgColor'] = {210, 190, 175, 250},
            })

            local iconW = h * 0.55
            local text = translate('Certeza destruir objeto', nil, translate(options.obName, 'name'))
            UI:CreateTextWithBG(margin, margin, w - margin * 3 - iconW, h - margin * 2, tostring(text), false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255},
            })
            UI:CreateImageWithBG(w - iconW - margin, margin, iconW - margin, iconW - margin, getObjectIcon(options.obName), false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255},
            })
            btnConfirm = UI:CreateButton(w - iconW - margin, iconW + margin, iconW - margin, pixels(54), translate('Confirmar'), false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255},
            })
            btnCancel = UI:CreateButton(w - iconW - margin, h - pixels(54) - margin, iconW - margin, pixels(54), translate('Cancelar'), false, window,
                                        {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255},
            })

        end
        setCursorPosition(sW * 0.5, sH * 0.5)
        showCursor(true)
        -- hideMenu()
        toggleControl('fire', false)

        if btnConfirm then
            addEventHandler('onClientGUIClick', btnConfirm, function()
                if options.onConfirm then --
                    options.onConfirm()
                end
                if options.reason == 'destroyObject' then
                    if isElement(options.object) then
                        local acc = getElementData(localPlayer, 'account')
                        local obName = getElementData(options.object, 'obName')
                        local nick = getPlayerName(localPlayer)
                        local x, y, z = getElementPosition(options.object)
                        local logMessage = ('%s ["%s"] destruiu um próprio "%s" em %s (%s)'):format(nick, acc, obName, getZoneName(x, y, z),
                                                                                                   getZoneName(x, y, z, true))

                        triggerServerEvent('craft:destroyObject', localPlayer, options.object, 'object-destroy', logMessage)
                    end
                end
                showConfirmWindow(false)
            end, false)
        end

        if btnCancel then
            addEventHandler('onClientGUIClick', btnCancel, function()
                showConfirmWindow(false)
            end, false)
        end
    else
        activeUI = nil
    end
end
addEventHandler('rust:onClientPlayerDie', localPlayer, function()
    showConfirmWindow(false)
end)

addEventHandler('onClientResourceStart', resourceRoot, function() --
    -- showConfirmWindow(true, {
    --     reason = 'resetWardrobePass',
    --     obName = 'Wardrobe',
    --     onConfirm = function() debug('teste') end,
    -- })
end)
