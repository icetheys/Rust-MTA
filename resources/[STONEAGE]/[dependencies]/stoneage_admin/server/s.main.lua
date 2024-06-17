NOTIFICATION = exports['stoneage_notifications']
GAMEMODE = exports['gamemode']
SQL = exports['stoneage_sql']

Admin = {
    OnlineStaffs = {},
}

-- local ip_port = "158.69.122.226:22013"	-- enter IP and port in format: 192.168.1.1:22003
-- local password = "" -- If the server is passworded insert password here (if no password, it wont use the value)
-- local ip = gettok(ip_port,1,":")
-- local port = tonumber(gettok(ip_port,2,":"))

-- function onConnectRedirect()
-- 	redirectPlayer(source, ip, port, password)
-- end
-- addEventHandler ("onPlayerJoin", root, onConnectRedirect)

local Init = function()
    setServerConfigSetting('ped_sync_interval', '50')
    setServerConfigSetting('keysync_mouse_sync_interval', '50')
    setServerConfigSetting('camera_sync_interval', '50')

    -- setServerPassword('stgpass')

    for k, v in pairs(getElementsByType('player')) do
        -- setTimer(function(v)
        --     redirectPlayer(v, ip, port, password)
        -- end, 500, 1, v)
        if getElementData(v, 'account') then
            local serial = getPlayerSerial(v)
            if (ADMINS[serial] and ADMINS[serial].Role) then
                setElementData(v, 'staffRole', ADMINS[serial].Role)
                Admin.OnlineStaffs[v] = true
                if (ADMINS[serial].Role ~= 'Youtuber') then
                    bindKey(v, 'i', 'down', 'chatbox', 'adminchat')
                end
            else
                removeElementData(v, 'staffRole')
            end
        end
    end
    RequestBanList(true, false, true)
    setTimer(RequestGroupsList, 30000, 1, true, false)
    RequestConfigList(true)
    RequestItensList(true)
    -- RequestVIPList(true)

    setTimer(function()
        setGameType(exports['stoneage_settings']:getConfig('Modo de jogo', '[Rust]'))
        -- setGameType('MAINTENANCE')
        setMaxPlayers(exports['stoneage_settings']:getConfig('MaxPlayers', 30))
        setElementData(root, 'weapon_switch_anim', exports['stoneage_settings']:getConfig('weapon_switch_anim', false))
    end, 3000, 1)
end
addEventHandler('onResourceStart', resourceRoot, Init)

addEventHandler('onResourceStop', resourceRoot, function()
    for k in pairs(Admin.OnlineStaffs) do
        removeElementData(k, 'staffRole')
    end
end)

addEventHandler('onPlayerConnect', root, function(nick)
    for serial, arr in pairs(ADMINS) do
        if string.find(nick:lower(), arr.Nick:lower()) then
            return cancelEvent(true, ('Nickname "%s" is reservated to staff.'):format(arr.Nick))
        end
    end
end)

OnLoginToStaffAccount = function()
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    local serial = getPlayerSerial(source)
    if (ADMINS[serial] and ADMINS[serial].Role) then
        setElementData(source, 'staffRole', ADMINS[serial].Role)
        setPlayerName(source, ADMINS[serial].Nick)
        Admin.OnlineStaffs[source] = true
        if (ADMINS[serial].Role ~= 'Youtuber') then
            bindKey(source, 'i', 'down', 'chatbox', 'adminchat')
        end
    else
        removeElementData(source, 'staffRole')
    end
end
addEvent('onLoginToStaffAccount', true)
addEventHandler('onLoginToStaffAccount', root, OnLoginToStaffAccount)

RequestMyPermissionResourceOnStart = function()
    if getElementData(source, 'account') then
        local Serial = getPlayerSerial(source)
        if (ADMINS[Serial]) then
            triggerClientEvent(source, 'initHandlersToOnlineStaff', source, ADMINS[Serial])
        end
    end
end
addEvent('requestMyPermissionResourceOnStart', true)
addEventHandler('requestMyPermissionResourceOnStart', root, RequestMyPermissionResourceOnStart)

RequestStaffPermissions = function()
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    local Serial = getPlayerSerial(source)
    if (ADMINS[Serial]) then
        triggerClientEvent(source, 'toggleAccountSelection', source, ADMINS[Serial])
    else
        triggerClientEvent(source, 'toggleLogin', source, true)
    end
end
addEvent('requestStaffPermissions', true)
addEventHandler('requestStaffPermissions', root, RequestStaffPermissions)

GetAdminName = function(player)
    local Serial = getPlayerSerial(player)
    if ADMINS[Serial] then
        return ADMINS[Serial].Nick
    end
    return getPlayerName(player)
end

isAdmin = function(player)
    return ADMINS[getPlayerSerial(player)] and true or false
end

addCommandHandler('tp', function(player, cmd, ...)
    if (not isAdmin(player)) then
        return false
    end

    local coords = {...}

    local x, y, z = unpack(coords)

    x = tonumber(x:gsub(',', ''):sub(1, 10))
    y = tonumber(y:gsub(',', ''):sub(1, 10))
    z = tonumber(z:gsub(',', ''):sub(1, 10))

    iprint(coords, x, y, z)

    if (not x) or (not y) or (not z) then
        return false
    end

    setElementPosition(player, x, y, z)
end)

addEventHandler('onPlayerQuit', root, function()
    if Admin.OnlineStaffs[source] then
        Admin.OnlineStaffs[source] = nil
    end
end)

addEventHandler('onElementDataChange', root, function(key, old, new)
    if (key == 'Flying') then
        setElementCollisionsEnabled(source, not new)
    end
end)

addEvent('Admin:DestroyOnFire', true)
addEventHandler('Admin:DestroyOnFire', resourceRoot, function(hitElement)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if (not isElement(hitElement)) then
        return false
    end
    if (not isElement(client)) then
        return false
    end
    if (not getElementData(client, 'admin:destruirNoTiro')) then
        return false, print('asd')
    end
    if (not getElementData(hitElement, 'owner')) then
        return false
    end

    exports['gamemode']:destroyObject(hitElement, 'staff-destroy')
end)

addCommandHandler('adminchat', function(player, _, ...)
    if (not isAdmin(player)) then
        return false, print(player)
    end

    local text = table.concat({...}, ' ')

    local role = getElementData(player, 'staffRole') or 'ADMIN'

    if (role == 'Youtuber') then
        return false
    end

    local shortRole = {
        ['Administrator'] = 'Admin',
        ['Veteran Moderator'] = 'V.Moderator',
        ['Test Moderator'] = 'T.Moderator',
    }

    role = shortRole[role] or role

    local message = ('[#FF0000%s#FFFFFF] %s: %s'):format(role, getPlayerName(player), text)

    outputChatBox(message, root, 255, 255, 255, true)
end)
