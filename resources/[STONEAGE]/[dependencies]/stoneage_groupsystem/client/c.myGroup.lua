Group.myGroup = {
    Cache = {},
    Buttons = {{
        Name = 'Convidar',
        Translate = 'inviteplayer',
        Permissions = {
            ['Leader'] = true,
            ['Sub'] = true,
            ['Staff'] = true,
        },
    }, {
        Name = 'Expulsar',
        Translate = 'kick',
        Permissions = {
            ['Leader'] = true,
            ['Sub'] = true,
            ['Staff'] = true,
        },
    }, {
        Name = 'Cargo',
        Translate = 'Cargo',
        Permissions = {
            ['Leader'] = true,
            ['Staff'] = true,
        },
    }, {
        Name = 'Definir Mensagem',
        Translate = 'dfmsg',
        Permissions = {
            ['Leader'] = true,
            ['Sub'] = true,
            ['Staff'] = true,
        },
    }},
}

InitMyGroup = function()
    local w, h = 450, 300

    GUI['myGroup'], GUI['myGroup:Header'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, 'Group (F1)', false, false, false, {
        bgColor = {25, 25, 25},
    })

    guiSetVisible(GUI['myGroup'], false)

    GUI['myGroup:PlayerList'] = UI:CreateList(10, 35, 250, 215, false, GUI['myGroup'], {
        bgColor = {30, 30, 30},
    })

    addEventHandler('ui:onSelectListItem', GUI['myGroup:PlayerList'], OnSelectGroupMember)

    GUI['myGroup:Container'] = UI:CreateRectangle(270, 35, 170, 85, false, GUI['myGroup'], {
        bgColor = {20, 20, 20},
    })

    local column, row = 1, 1
    for k, v in ipairs(Group.myGroup.Buttons) do
        local w = 77
        local h = 35

        local x = (column - 1) * (w + 5) + 5
        local y = (row - 1) * (h + 5) + 5

        local btn = UI:CreateButton(x, y, w, h, v.Name, false, GUI['myGroup:Container'])

        GUI['myGroup:Button:' .. v.Name] = btn

        addEventHandler('onClientGUIClick', btn, function()
            if (v.Permissions[Group.MyRole]) then
                onMyGroupClick(v.Name)
            else
                exports['stoneage_notifications']:CreateNotification(translate('Sem permissão!'), 'error')
            end
        end, false)

        if (column + 1 > 2) then
            column = 1
            row = row + 1
        else
            column = column + 1
        end
    end

    GUI['myGroup:OpenGroupDoors'] = UI:CreateCheckbox(270, 130, 22, false, false, GUI['myGroup'], {
        bgColor = {20, 20, 20},
    })
    addEventHandler('onClientGUIClick', GUI['myGroup:OpenGroupDoors'], function()
        if (Group.MyRole == 'Leader') or (Group.MyRole == 'Sub') or (Group.MyRole == 'Staff') then
            onMyGroupClick('Abrir Porta')
        else
            exports['stoneage_notifications']:CreateNotification(translate('Sem permissão!'), 'error')
        end
    end, false)

    GUI['myGroup:OpenGroupDoorsText'] = UI:CreateLabel(295, 130, 150, 22, 'Teste', GUI['myGroup'], 'left')

    GUI['myGroup:Description'] = UI:CreateEditBox(10, 260, 250, 30, '', false, GUI['myGroup'])
    guiSetEnabled(GUI['myGroup:Description'], false)

    GUI['myGroup:LeaveGroup'] = UI:CreateButton(270, 260, 170, 30, translate('sairgp'), false, GUI['myGroup'])

    addEventHandler('onClientGUIClick', GUI['myGroup:LeaveGroup'], function()
        onMyGroupClick('Deixar Grupo')
    end, false)

end

ToggleMyGroupUI = function(state)
    if state then
        UI:ResetListItems(GUI['myGroup:PlayerList'])
        Group.myGroup.Cache = {}

        local q = 0
        for k, v in pairs(Group.myGroupInfo.Members) do
            local str = ('%s [%s]'):format(v.Nick, v.Role)
            UI:addListItem(GUI['myGroup:PlayerList'], str)
            Group.myGroup.Cache[str] = k
            q = q + 1
        end
        guiSetText(GUI['myGroup:Header'], ('%s (%s/%s)'):format(Group.myGroupInfo.Name, q, Group.myGroupInfo.MaxMembers))

        guiSetText(GUI['myGroup:Description'], Group.myGroupInfo.Description)
        guiSetText(GUI['myGroup:OpenGroupDoorsText'], translate('abrirPortas'))

        for k, v in ipairs(Group.myGroup.Buttons) do
            guiSetText(GUI['myGroup:Button:' .. v.Name], translate(v.Translate))
        end

        guiSetEnabled(GUI['myGroup:OpenGroupDoors'], ((Group.MyRole == 'Leader') or (Group.MyRole == 'Sub') or (Group.MyRole == 'Staff')) or false)
        guiSetEnabled(GUI['myGroup:Description'], ((Group.MyRole == 'Leader') or (Group.MyRole == 'Sub') or (Group.MyRole == 'Staff')) or false)
    end
    showCursor(state)
    guiSetVisible(GUI['myGroup'], state)
end

onMyGroupClick = function(action)
    local selected = UI:getSelectedListItem(GUI['myGroup:PlayerList'])
    local accountName = Group.myGroup.Cache[selected]
    local cache = accountName and Group.myGroupInfo.Members[accountName]

    if (action == 'Convidar') then
        local arr = {}
        for k, v in ipairs(getElementsByType('player')) do
            if (not getElementData(v, 'Group')) then
                table.insert(arr, getPlayerName(v))
            end
        end

        createChooseWindow(translate('inviteplayer'), arr, function(selected)
            local player = getPlayerFromName(selected)
            if (player) then
                triggerServerEvent('InvitePlayer', localPlayer, player)
                return true
            else
                exports['stoneage_notifications']:CreateNotification('Error.', 'error')
            end
        end)

    elseif (action == 'Cargo') then
        if (selected and cache) then
            if (cache.Role ~= 'Leader') and (cache.Role ~= 'Staff' or Group.MyRole == 'Staff') then
                local arr = {}
                if cache.Role == 'Sub' then
                    table.insert(arr, 'Member')
                elseif cache.Role == 'Member' then
                    table.insert(arr, 'Sub')
                elseif cache.Role == 'Staff' then
                    table.insert(arr, 'Leader')
                    table.insert(arr, 'Sub')
                    table.insert(arr, 'Member')
                end
                createChooseWindow(translate('Cargo'), arr, function(option)
                    triggerServerEvent('SetMemberRole', localPlayer, Group.myGroupInfo.Name, accountName, option)
                    return true
                end)
            else
                exports['stoneage_notifications']:CreateNotification(translate('Sem permissão!'), 'error')
            end
        else
            exports['stoneage_notifications']:CreateNotification(translate('Selecione um item para ver as informações sobre ele.'), 'error')
        end

    elseif (action == 'Expulsar') then
        if (selected and cache) then
            if (cache.Role ~= 'Leader') and (cache.Role ~= 'Staff') then
                triggerServerEvent('KickPlayer', localPlayer, Group.myGroupInfo.Name, accountName)
            else
                exports['stoneage_notifications']:CreateNotification(translate('Sem permissão!'), 'error')
            end
        else
            exports['stoneage_notifications']:CreateNotification(translate('Selecione um item para ver as informações sobre ele.'), 'error')
        end

    elseif (action == 'Abrir Porta') then
        if (selected and cache) then
            if isTimer(Group.myGroup.TimerSyncDoors) then
                killTimer(Group.myGroup.TimerSyncDoors)
            end

            Group.myGroup.TimerSyncDoors = setTimer(function(member, allow)
                if Group.myGroupInfo and Group.myGroupInfo.Name then
                    triggerServerEvent('AllowMemberToOpenDoor', localPlayer, Group.myGroupInfo.Name, member, allow)
                end
            end, 1000, 1, accountName, guiGetText(GUI['myGroup:OpenGroupDoors']) == '✔')

        else
            exports['stoneage_notifications']:CreateNotification(translate('Selecione um item para ver as informações sobre ele.'), 'error')
            guiSetText(GUI['myGroup:OpenGroupDoors'], '')
        end

    elseif (action == 'Definir Mensagem') then
        local msg = guiGetText(GUI['myGroup:Description'])
        if (msg ~= Group.myGroupInfo.Description) then
            if (utf8.len(msg) >= 4 and utf8.len(msg) <= 30) then
                createChooseWindow(translate('dfmsg'), {msg}, function(option)
                    triggerServerEvent('SetGroupDescription', localPlayer, Group.myGroupInfo.Name, msg)
                    return true
                end)
            else
                exports['stoneage_notifications']:CreateNotification(translate('caracteres mensagem grupo'), 'error')
            end
        end

    elseif (action == 'Deixar Grupo') then
        if (Group.MyRole == 'Leader') then
            createChooseWindow(translate('ctzfimgp'), {translate('sim, destruir grupo')}, function(option)
                triggerServerEvent('DestroyGroup', localPlayer, Group.myGroupInfo.Name)
                return true
            end, translate('Confirmar'))
        else
            createChooseWindow(translate('sairgp'), {translate('sim, aceito sair do grupo.')}, function(option)
                triggerServerEvent('LeaveGroup', localPlayer, Group.myGroupInfo.Name)
                return true
            end, translate('Confirmar'))
        end

    end
end

OnSelectGroupMember = function(str)
    if (Group.myGroup.Cache[str]) then
        local state = Group.myGroupInfo.Members[Group.myGroup.Cache[str]].CanOpenDoors
        guiSetText(GUI['myGroup:OpenGroupDoors'], state and '✔' or '')
    end
end
