UI = exports['stoneage_ui']

sW, sH = guiGetScreenSize()
GUI = {}

Group = {
    myGroupInfo = false,
    Cache = {},
}

local Init = function()
    InitMyGroup()
    InitGroupHome()
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

ToggleGroupSystem = function(state, myGroup, invites)
    state = state or false

    if myGroup then
        Group.myGroupInfo = myGroup
        local account = getElementData(localPlayer, 'account')
        Group.MyRole = myGroup.Members[account] and myGroup.Members[account].Role or false

        ToggleGroupHome(false)
        ToggleMyGroupUI(state)

    else

        Group.Home.Invites = invites or {}

        ToggleMyGroupUI(false)
        ToggleGroupHome(state)

    end

    DestroyChooseWindow()
end
addEvent('ToggleGroupSystem', true)
addEventHandler('ToggleGroupSystem', localPlayer, ToggleGroupSystem)

translate = function(...)
    return exports['stoneage_translations']:translate(...)
end

createChooseWindow = function(header, list, callBack, buttonText)
    DestroyChooseWindow()

    local w, h = 275, 275
    GUI['InviteWindow'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, header, false, false, true, {
        bgColor = {35, 35, 35},
    })
    guiSetProperty(GUI['InviteWindow'], 'AlwaysOnTop', 'True')

    addEventHandler('onCustomWindowClose', GUI['InviteWindow'], DestroyChooseWindow)

    local w2 = w - 20

    local List = UI:CreateList((w - w2) / 2, 35, w2, 185, false, GUI['InviteWindow'], {})

    for k, v in ipairs(list) do
        UI:addListItem(List, v)
    end

    local InviteButton = UI:CreateButton((w - w2) / 2, h - 47, w2, 40, buttonText or header, false, GUI['InviteWindow'])

    addEventHandler('onClientGUIClick', InviteButton, function()
        local selected = UI:getSelectedListItem(List)
        if selected and type(callBack) == 'function' then
            if callBack(selected) then
                DestroyChooseWindow()
            end
        end
    end, false)
end

DestroyChooseWindow = function()
    if isElement(GUI['InviteWindow']) then
        destroyElement(GUI['InviteWindow'])
    end
end

local Blips = {}

setTimer(function()
    for k, v in pairs(Blips) do
        if isElement(v) then
            destroyElement(v)
        end
    end

    local myGroup = getElementData(localPlayer, 'Group')
    if (not myGroup) then
        return
    end
    
    Blips = {}

    for k, v in pairs(getElementsByType('player')) do
        if (v ~= localPlayer) and (getElementData(v, 'Group') == myGroup) then
            Blips[v] = createBlipAttachedTo(v, 0, 2, 255, 255, 0)
        end
    end
end, 3000, 0)
