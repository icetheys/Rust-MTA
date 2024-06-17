createButtons = function(WidgetName, buttons, parent, x, y, w, h, buttonW, buttonH)
    local bg = UI:CreateRectangle(x, y, w, h, false, parent, {
        bgColor = {20, 20, 20, 250},
    })

    local container = UI:CreateScrollPane(0, 0, w, h, false, bg)

    local column, row = 1, 1
    local columnMax = w / buttonW

    for k, v in ipairs(buttons) do
        local x = 2 + (buttonW + 2) * (column - 1)
        local y = 2 + (buttonH + 2) * (row - 1)

        local btn = UI:CreateButton(x, y, buttonW, buttonH, v, false, container)

        if (not hasEnoughPermission(WidgetName .. ':' .. v, true)) then
            UI:SetRectangleColor(getElementParent(btn), {40, 40, 40})
            guiSetAlpha(btn, 0.5)
            guiSetEnabled(getElementParent(btn), false)
        end

        addEventHandler('onClientGUIClick', btn, function(key, state)
            if (key == 'left') then
                if hasEnoughPermission(WidgetName .. ':' .. v) then
                    Admin.Widgets[WidgetName].OnClick(v)
                end
            end
        end, false)

        if (column + 1 >= columnMax) then
            column = 1
            row = row + 1
        else
            column = column + 1
        end
    end
end

ShowConfirmWindow = function(header, text, onConfirm)
    CloseConfirmWindow()

    local w, h = 300, 200
    GUI['ConfirmWindow'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, header, false, false, true, {
        bgColor = {25, 25, 25, 250},
    })

    guiSetProperty(GUI['ConfirmWindow'], 'AlwaysOnTop', 'True')
    addEventHandler('onCustomWindowClose', GUI['ConfirmWindow'], function()
        CloseConfirmWindow()
    end)

    UI:CreateLabel(10, 50, w - 20, 60, text, GUI['ConfirmWindow'])

    local btn = UI:CreateButton((w - 150) / 2, 120, 150, 50, 'Confirmar', false, GUI['ConfirmWindow'])
    addEventHandler('onClientGUIClick', btn, function()
        CloseConfirmWindow()
        if type(onConfirm) == 'function' then
            onConfirm()
        end
    end, false)
end

CloseConfirmWindow = function()
    if isElement(GUI['ConfirmWindow']) then
        destroyElement(GUI['ConfirmWindow'])
    end
end

ShowInputWindow = function(header, text, onConfirm)
    CloseInputWindow()

    local w, h = 300, 230
    GUI['InputWindow'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, header, false, false, true, {
        bgColor = {25, 25, 25, 250},
    })

    guiSetProperty(GUI['InputWindow'], 'AlwaysOnTop', 'True')
    guiBringToFront(GUI['InputWindow'])
    addEventHandler('onCustomWindowClose', GUI['InputWindow'], function()
        CloseInputWindow()
    end)

    UI:CreateLabel(10, 50, w - 20, 60, text, GUI['InputWindow'])
    local edit = UI:CreateEditBox((w - 200) / 2, 120, 200, 25, 'Insira aqui', false, GUI['InputWindow'])
    local btn = UI:CreateButton((w - 150) / 2, h - 70, 150, 50, 'Confirmar', false, GUI['InputWindow'])
    addEventHandler('onClientGUIClick', btn, function()
        local text = guiGetText(edit)
        CloseInputWindow()
        if type(onConfirm) == 'function' then
            onConfirm(text)
        end
    end, false)
end

CloseInputWindow = function()
    if isElement(GUI['InputWindow']) then
        destroyElement(GUI['InputWindow'])
    end
end

hasEnoughPermission = function(action, withoutNotification)
    local myRole = Admin.MySettings and Admin.MySettings.Role
    if myRole then
        if (PERMISSIONS[myRole] and PERMISSIONS[myRole][action]) then
            return true
        end
    end
    if (not withoutNotification) then
        NOTIFICATION:CreateNotification('Você não possui permissão suficiente.', 'error')
    end
    return false
end
