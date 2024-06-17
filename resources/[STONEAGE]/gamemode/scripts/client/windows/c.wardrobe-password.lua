local window

function showWardrobePassword(state, options, object, pass)
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

        local w, h = pixels(400), pixels(250)
        window = UI:CreateRectangle(sW * 0.5 - w / 2, sH * 0.5 - h / 2, w, h, false, nil, {
            ['bgColor'] = {210, 190, 175, 250}
        })

        local iconW = h * 0.55
        UI:CreateTextWithBG(margin, margin, w - margin * 3 - iconW, h - math.floor(sH * 0.03) - margin * 2,
            options.header, false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

        local edit = UI:CreateEditBox(margin, h - math.floor(sH * 0.03) - margin, w - margin * 3 - iconW,
                         math.floor(sH * 0.03), 'Insira aqui a senha', false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })
        guiEditSetMaxLength(edit, 8)
        guiSetText(edit, options.password)

        UI:CreateImageWithBG(w - iconW - margin, margin, iconW - margin, iconW - margin, getObjectIcon('Wardrobe'),
            false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })
        btnConfirm = UI:CreateButton(w - iconW - margin, iconW + margin, iconW - margin, pixels(54),
                         translate('Confirmar'), false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })
        btnCancel = UI:CreateButton(w - iconW - margin, h - pixels(54) - margin, iconW - margin, pixels(54),
                        translate('Cancelar'), false, window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

        setCursorPosition(sW * 0.5, sH * 0.5)
        showCursor(true)
        -- hideMenu()
        toggleControl('fire', false)

        if btnConfirm then
            addEventHandler('onClientGUIClick', btnConfirm, function()
                local typedText = guiGetText(edit)
                
                exports['stoneage_settings']:setConfig('Senha do armário', typedText)
                
                showWardrobePassword(false)
                
                if options.TypingPass then
                    if typedText == pass then
                        toggleInventory(true)
                        inv.setLootSource(object)
                    else
                        exports['stoneage_notifications']:CreateNotification(translate('Senha incorreta'), 'error')
                    end
                elseif options.SettingNewPassword then
                    if utf8.len(typedText) > 0 then
                        setElementData(object, 'wardrobe:password', typedText)
                    else
                        setElementData(object, 'wardrobe:password', nil)
                    end
                end

            end, false)
        end
        if btnCancel then
            addEventHandler('onClientGUIClick', btnCancel, function()
                showWardrobePassword(false)
            end, false)
        end
    else
        activeUI = nil
    end
end

addEventHandler('rust:onClientPlayerDie', localPlayer, function()
    showWardrobePassword(false)
end)

addEventHandler('onClientResourceStart', resourceRoot, function()

end)
