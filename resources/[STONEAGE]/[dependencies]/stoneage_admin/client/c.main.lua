sW, sH = guiGetScreenSize()

UI = exports['stoneage_ui']
NOTIFICATION = exports['stoneage_notifications']

Admin = {
    Widgets = {'Home', 'Usuario', 'Veiculo', 'Grupos', 'VIP', 'Itens', 'Bans', 'Config'},
    SelectedWidget = false,
    MySettings = false,
}

GUI = {}

local InitAdminUI = function()
    local w, h = 800, 600
    GUI['Background'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, '', false, false, true, {})
    guiSetVisible(GUI['Background'], false)
    
    addEventHandler('onCustomWindowClose', GUI['Background'], function()
        ToggleAdminWindow(false)
    end)
    
    local Container = UI:CreateRectangle(0, 0, 70, h, false, GUI['Background'], {
        bgColor = {25, 25, 25, 250},
    })
    
    local iconW = 48
    for k, v in ipairs(Admin.Widgets) do
        local x = (70 - iconW) / 2
        local y = 5 + (iconW + 10) * (k - 1)
        local img = guiCreateStaticImage(x, y, iconW, iconW, 'assets/icons/' .. v .. '.png', false, Container)
        local bar = UI:CreateRectangle(x, y + iconW, iconW, 3, false, Container)
        
        guiSetVisible(bar, false)
        
        UI:SetRectangleColor(img, {210, 190, 175, 150})
        UI:SetRectangleColor(bar, {210, 190, 175, 150})
        
        if (not hasEnoughPermission('Access:' .. v, true)) then
            UI:SetRectangleColor(img, {40, 40, 40})
            guiSetEnabled(img, false)
        end
        
        addEventHandler('onClientMouseEnter', img, function()
            if (Admin.SelectedWidget ~= v) then
                UI:SetRectangleColor(img, {210, 190, 175, 200})
                UI:SetRectangleColor(bar, {210, 190, 175, 200})
            end
        end, false)
        
        addEventHandler('onClientMouseLeave', img, function()
            if (Admin.SelectedWidget ~= v) then
                UI:SetRectangleColor(img, {210, 190, 175, 150})
                UI:SetRectangleColor(bar, {210, 190, 175, 150})
            end
        end, false)
        
        addEventHandler('onClientGUIClick', img, function()
            SelectWidget(v)
        end, false)
        
        GUI['Widget:' .. v] = {
            Icon = img,
            Bar = bar,
        }
        if Admin.Widgets[v] then
            Admin.Widgets[v].Init()
        end
    end
    
    EditInventory.Init()
    
    local myLastWidget = exports['stoneage_settings']:getConfig('admin:lastWidget', 'Home')
    SelectWidget(myLastWidget)
    
    bindKey(ADMIN_GUI_BIND, 'down', ADMIN_GUI_COMMAND)
    
    setTimer(CreateBlipToNearPlayers, 3000, 0)
    setTimer(CreateBlipToNearVehicles, 3000, 0)
    
    addCommandHandler(ADMIN_GUI_COMMAND, function()
        ToggleAdminWindow(not guiGetVisible(GUI['Background']))
    end, false, false)
    
    bindKey(ADMIN_FLY_BIND, 'down', ADMIN_FLY_COMMAND)
    addCommandHandler(ADMIN_FLY_COMMAND, function()
        toggleFly(not Admin.Fly.State)
    end)
end

SelectWidget = function(widgetName)
    if (widgetName == Admin.SelectedWidget) then
        return
    end
    
    if (not hasEnoughPermission('Access:' .. widgetName)) then
        return
    end
    
    if Admin.SelectedWidget then
        UI:SetRectangleColor(GUI['Widget:' .. Admin.SelectedWidget].Icon, {210, 190, 175, 150})
        guiSetVisible(GUI['Widget:' .. Admin.SelectedWidget].Bar, false)
        if Admin.Widgets[Admin.SelectedWidget] then
            Admin.Widgets[Admin.SelectedWidget].Toggle(false)
        end
    end
    
    Admin.SelectedWidget = widgetName
    
    exports['stoneage_settings']:setConfig('admin:lastWidget', widgetName)
    
    UI:SetRectangleColor(GUI['Widget:' .. widgetName].Icon, {230, 230, 205, 250})
    guiSetVisible(GUI['Widget:' .. widgetName].Bar, true)
    
    if Admin.Widgets[widgetName] then
        Admin.Widgets[widgetName].Toggle(true)
    end
    
    CloseConfirmWindow()
    CloseInputWindow()
    CloseVIPWindow()
    CloseBanWindow()
    EditInventory.Toggle(false)
end

ToggleAdminWindow = function(state)
    if state and (not getElementData(localPlayer, 'staffRole')) then
        return
    end
    guiSetVisible(GUI['Background'], state)
    showCursor(state)
    
    CloseConfirmWindow()
    CloseInputWindow()
    CloseVIPWindow()
    CloseBanWindow()
    EditInventory.Toggle(false)
end

ToggleAccountSelection = function(mySettings)
    local w, h = 300, 190
    GUI['SelectAccBackground'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, 'Escolha de contas', false, false,
        false, {
            bgColor = {20, 20, 20},
        })
    
    local str =
        'O seu serial está listado com cargos administrativos. Selecione abaixo qual conta você deseja utilizar.'
    UI:CreateLabel(20, 30, w - 40, 70, str, GUI['SelectAccBackground'])
    
    local Staff = UI:CreateButton(40, 110, 100, 50, 'Staff', false, GUI['SelectAccBackground'])
    local Player = UI:CreateButton(165, 110, 100, 50, 'Player', false, GUI['SelectAccBackground'])
    
    addEventHandler('onClientGUIClick', Staff, function(button)
        if (button == 'left') then
            if (isElement(GUI['SelectAccBackground'])) then
                destroyElement(GUI['SelectAccBackground'])
                showCursor(false)
                triggerServerEvent('player:onTryToLogin', localPlayer, true)
                triggerServerEvent('onLoginToStaffAccount', localPlayer)
                Admin.MySettings = mySettings
                InitAdminUI()
            end
        end
    end)
    
    addEventHandler('onClientGUIClick', Player, function(button)
        if (button == 'left') then
            if (isElement(GUI['SelectAccBackground'])) then
                destroyElement(GUI['SelectAccBackground'])
                showCursor(false)
                triggerEvent('toggleLogin', localPlayer, true)
            end
        end
    end)
    
    showCursor(true)
end
addEvent('toggleAccountSelection', true)
addEventHandler('toggleAccountSelection', localPlayer, ToggleAccountSelection)

InitHandlersToOnlineStaff = function(mySettings)
    Admin.MySettings = mySettings
    InitAdminUI()
end
addEvent('initHandlersToOnlineStaff', true)
addEventHandler('initHandlersToOnlineStaff', localPlayer, InitHandlersToOnlineStaff)

addEventHandler('onClientResourceStart', resourceRoot, function()
    triggerServerEvent('requestMyPermissionResourceOnStart', localPlayer)
end)

local playerBlips = {}
CreateBlipToNearPlayers = function()
    for k, v in pairs(playerBlips) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    playerBlips = {}
    if exports['stoneage_settings']:getConfig('admin:drawNearPlayers') then
        for k, v in ipairs(getElementsByType('player')) do
            if (v ~= localPlayer) then
                playerBlips[v] = createBlipAttachedTo(v, 0, 2, 255, 255, 0)
            end
        end
    end
end

local vehicleBlips = {}
CreateBlipToNearVehicles = function()
    for k, v in pairs(vehicleBlips) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    vehicleBlips = {}
    if exports['stoneage_settings']:getConfig('admin:drawNearVehicles') then
        for k, v in ipairs(getElementsByType('vehicle')) do
            vehicleBlips[v] = createBlipAttachedTo(v, 0, 2, 255, 0, 0)
        end
    end
end

addEventHandler('onClientPlayerWeaponFire', localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    if (not isElement(hitElement)) then
        return false
    end
    if (not hasEnoughPermission('destroyOnFire', true)) then
        return false
    end
    if (not getElementData(localPlayer, 'admin:destruirNoTiro')) then
        return false
    end
    if (not getElementData(hitElement, 'owner')) then
        return false
    end
    triggerServerEvent('Admin:DestroyOnFire', resourceRoot, hitElement)
end)
