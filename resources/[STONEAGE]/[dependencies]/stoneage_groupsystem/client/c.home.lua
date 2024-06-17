Group.Home = {
    Cache = {},
}

InitGroupHome = function()
    local w, h = 500, 400

    GUI['Home'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, 'Group (F1)', false, false, false, {
        bgColor = {25, 25, 25},
    })
    guiSetVisible(GUI['Home'], false)

    GUI['Home:InviteList'] = UI:CreateList(10, 35, 480, 255, false, GUI['Home'], {
        bgColor = {30, 30, 30},
    })

    GUI['Home:AcceptInvite'] = UI:CreateButton(10, 295, 480, 30, 'aceitar', false, GUI['Home'])
    addEventHandler('onClientGUIClick', GUI['Home:AcceptInvite'], onHomeClick, false)

    GUI['Home:CreateGroupLabel'] = UI:CreateLabel(10, 330, 480, 30, 'Criar Grupo', GUI['Home'], 'left')

    GUI['Home:CreateGroupEdit'] = UI:CreateEditBox(10, 360, 300, 30, '', false, GUI['Home'])
    GUI['Home:CreateGroupButton'] = UI:CreateButton(315, 360 - 1, 175, 30 + 1, translate('Confirmar'), false, GUI['Home'])
    addEventHandler('onClientGUIClick', GUI['Home:CreateGroupButton'], onHomeClick, false)
end

ToggleGroupHome = function(state)
    if (state) then
        UI:ResetListItems(GUI['Home:InviteList'])

        Group.Home.Cache = {}

        for k, v in ipairs(Group.Home.Invites or {}) do
            local str = ('%s [%s]'):format(v.Name, v.Inviter)
            UI:addListItem(GUI['Home:InviteList'], str)
            Group.Home.Cache[str] = v.Name
        end

        guiSetText(GUI['Home:AcceptInvite'], translate('Aceitar convite'))
        guiSetText(GUI['Home:CreateGroupLabel'], translate('criarCla'))
        guiSetText(GUI['Home:CreateGroupButton'], translate('Confirmar'))
    end
    guiSetVisible(GUI['Home'], state)
    showCursor(state)
end

onHomeClick = function(key)
    if (key == 'left') then
        if (source == GUI['Home:CreateGroupButton']) then
            local name = guiGetText(GUI['Home:CreateGroupEdit'])
            if (utf8.len(name) > 4) and (utf8.len(name) <= 10) then
                triggerServerEvent('CreateGroup', localPlayer, localPlayer, name)
            else
                exports['stoneage_notifications']:CreateNotification(translate('caracteres grupo'), 'error')
            end
        elseif (source == GUI['Home:AcceptInvite']) then
            local selected = UI:getSelectedListItem(GUI['Home:InviteList'])
            if (selected and Group.Home.Cache[selected]) then
                triggerServerEvent('AcceptGroupInvite', localPlayer, Group.Home.Cache[selected])
            end
        end
    end
end
