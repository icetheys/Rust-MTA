local window, closeBG

function showWardrobePermissions(state, ob)
    if window then
        if isElement(closeBG) then
            destroyElement(closeBG)
        end
        if isElement(window) then
            destroyElement(window)
        end
    end

    if state then
        if activeUI then
            return
        end
        activeUI = true

        if ob and isElement(ob) then
            local w, h = sW * 0.3, sH * 0.4

            window = UI:CreateRectangle(sW * 0.5 - w / 2, sH * 0.5 - h / 2, w, h, false, nil, {
                bgColor = {210, 190, 175, 250}
            })

            local closew, closeh = w / 4, sH * 0.05
            closeBG = UI:CreateRectangle(sW * 0.5 - w / 8, sH * 0.5 - h / 2 + h + 1, closew, closeh, false, nil, {
                bgColor = {210, 190, 175, 250}
            })

            local closeBtn = UI:CreateButton(1, 1, closew - 2, closeh - 2, 'Fechar', false, closeBG)
            addEventHandler('onClientGUIClick', closeBtn, function() --
                showWardrobePermissions(false)
            end, false)

            -- LEFT SIDE
            UI:CreateTextWithBG(1, 1, w * 0.44, w * 0.05 - 2, 'Permissões concedidas', false, window, {
                bgColor = {w * 0.05, w * 0.05, w * 0.05, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

            local leftList = UI:CreateList(1, w * 0.05, w * 0.44, h - w * 0.05 - 1, false, window, {
                bgColor = {w * 0.05, w * 0.05, w * 0.05, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

            local permissions = getElementData(ob, 'wardrobe:permissions')
            if permissions then
                for serial, nick in pairs(permissions) do --
                    UI:addListItem(leftList, ('%s (%s)'):format(nick, serial:sub(1, 5)))
                end
            end

            local btnLeft = UI:CreateButton(w * 0.44 + 2, 1, w * 0.05, h - 2, '>', false, window, {
                ignoreCollapse = true,
                bgColor = {w * 0.05, w * 0.05, w * 0.05, 255},
                hoverBgColor = {40, 40, 40, 255}
            })
            addEventHandler('onClientGUIClick', btnLeft, function()
                local selected = UI:getSelectedListItem(leftList)
                if selected then
                    local sepPos = string.find(selected, '%(')
                    local onlyNick = selected:sub(1, sepPos - 2)
                    if onlyNick then
                        triggerServerEvent('wardrobe:removePermission', localPlayer, ob, onlyNick)
                        showWardrobePermissions(false)
                    end
                end
            end, false)

            -- RIGHT SIDE
            UI:CreateTextWithBG(w - w * 0.44 - 1, 1, w * 0.44, w * 0.05 - 2, 'Jogadores próximos', false, window, {
                bgColor = {w * 0.05, w * 0.05, w * 0.05, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

            local btnRight = UI:CreateButton(w - w * 0.44 - w * 0.05 - 2, 1, w * 0.05, h - 2, '<', false, window, {
                ignoreCollapse = true,
                bgColor = {w * 0.05, w * 0.05, w * 0.05, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

            local rightList = UI:CreateList(w - w * 0.44 - 1, w * 0.05, w * 0.44, h - w * 0.05 - 1, false, window, {
                bgColor = {w * 0.05, w * 0.05, w * 0.05, 255},
                hoverBgColor = {40, 40, 40, 255}
            })

            local x, y, z = getElementPosition(localPlayer)
            for k, v in ipairs(getElementsWithinRange(x, y, z, 30, 'player')) do
                local serial = getElementData(v, 'account')
                if serial then
                    if (permissions and (not permissions[serial])) then
                        UI:addListItem(rightList, ('%s (%s)'):format(getPlayerName(v), serial:sub(1, 5)))
                    else    
                        UI:addListItem(rightList, ('%s (%s)'):format(getPlayerName(v), serial:sub(1, 5)))
                    end
                end
            end

            addEventHandler('onClientGUIClick', btnRight, function()
                local selected = UI:getSelectedListItem(rightList)
                if selected then
                    local sepPos = string.find(selected, '%(')
                    local onlyNick = selected:sub(1, sepPos - 2)
                    if onlyNick then
                        local player = getPlayerFromName(onlyNick)
                        if player then
                            showWardrobePermissions(false)
                            triggerServerEvent('wardrobe:addPermission', localPlayer, ob, player)
                        end
                    end
                end
            end, false)

            setCursorPosition(sW * 0.5, sH * 0.5)
        end
    else
        activeUI = nil
    end
    showCursor(state)
end
