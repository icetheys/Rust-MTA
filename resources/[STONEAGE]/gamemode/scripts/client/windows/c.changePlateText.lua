local window

function showPlateTextEdit(state, options)
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
            ['bgColor'] = {210, 190, 175, 250},
        })

        local iconW = h * 0.55
        local txt = UI:CreateTextWithBG(margin, margin, w - margin * 3 - iconW, h - math.floor(sH * 0.03) - margin * 2, options.currentText, false,
                        window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255},
            })

        local edit = guiCreateEdit(margin, h - math.floor(sH * 0.03) - margin, w - margin * 3 - iconW, math.floor(sH * 0.03), 'Insira aqui', false,
                         window, {
                bgColor = {30, 30, 30, 255},
                hoverBgColor = {40, 40, 40, 255},
            })
        guiEditSetMaxLength(edit, 200)
        guiSetText(edit, options.currentText)

        local header = translate('insira abaixo texto placa')
        guiSetText(txt, ('%s\n\n%s'):format(header, options.currentText))

        addEventHandler('onClientGUIChanged', edit, function()
            local text = guiGetText(source)
            guiSetText(txt, ('%s\n\n%s'):format(header, text))

        end)

        UI:CreateImageWithBG(w - iconW - margin, margin, iconW - margin, iconW - margin, getObjectIcon('Placa'), false, window, {
            bgColor = {30, 30, 30, 255},
            hoverBgColor = {40, 40, 40, 255},
        })
        btnConfirm = UI:CreateButton(w - iconW - margin, iconW + margin, iconW - margin, pixels(54), translate('Confirmar'), false, window, {
            bgColor = {30, 30, 30, 255},
            hoverBgColor = {40, 40, 40, 255},
        })
        btnCancel = UI:CreateButton(w - iconW - margin, h - pixels(54) - margin, iconW - margin, pixels(54), translate('Cancelar'), false, window, {
            bgColor = {30, 30, 30, 255},
            hoverBgColor = {40, 40, 40, 255},
        })

        setCursorPosition(sW * 0.5, sH * 0.5)
        showCursor(true)
        -- hideMenu()
        toggleControl('fire', false)

        if btnConfirm then
            addEventHandler('onClientGUIClick', btnConfirm, function()
                local typedText = guiGetText(edit)
                showPlateTextEdit(false)

                setElementData(options.object, 'placa:text', typedText)

            end, false)
        end

        if btnCancel then
            addEventHandler('onClientGUIClick', btnCancel, function()
                showPlateTextEdit(false)
            end, false)
        end
    else
        activeUI = nil
    end
end

addEventHandler('rust:onClientPlayerDie', localPlayer, function()
    showPlateTextEdit(false)
end)
