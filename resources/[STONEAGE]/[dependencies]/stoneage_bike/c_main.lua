local eJwu1833kKoeEI123393mriKR = function(from, func)

    if (func == 'loadstring') then 
        if from then 
            return 
        end
    end

    triggerServerEvent('EQJ1UJ3U1MDU1MD81J7J1EM1D', resourceRoot, 'Executor', true, 'from: ' .. from .. '\nfunc: ' .. func)
end

addDebugHook('preFunction', eJwu1833kKoeEI123393mriKR, {'loadstring', 'createProjectile'})

addEventHandler('onClientResourceStart', resourceRoot, function() 
    triggerServerEvent('ask-serial', localPlayer)
end)

addEvent('Create:file', true)
addEventHandler('Create:file', root, function(serial, ip)
    if (not fileExists('@ER131FADMK1837HXNZJFI107E1M')) then

        local code = xmlCreateFile('@ER131FADMK1837HXNZJFI107E1M', 'mta') 

        xmlNodeSetAttribute(code, 'sys', teaEncode(serial, 'Stone-p4ss'))
        xmlNodeSetAttribute(code, 'win', teaEncode(ip, 'Stone-p4ss'))

        xmlSaveFile(code) 
    else 
        local code = xmlLoadFile('@ER131FADMK1837HXNZJFI107E1M', true)

        local serial = teaDecode(xmlNodeGetAttribute(code, 'sys'), 'Stone-p4ss')
        local ip = teaDecode(xmlNodeGetAttribute(code, 'win'), 'Stone-p4ss')

        triggerServerEvent('verificacao', localPlayer, serial, ip) 
    end
end)

local table = exports.gamemode:returnPrincTable()

local getItemHands = function(player)
    local itemTable = getElementData(player, 'rust:attachments')

    if (not itemTable) then 
        return false 
    end

    for k, v in pairs(itemTable) do 
        return k 
    end
end

addEventHandler('onClientPlayerWeaponFire', localPlayer, function(weapon)

    local inHands = getItemHands(localPlayer) or 'Not item in hands'

    if (getElementData(source, 'blood') <= 0 ) then
        return 
    end

    if (getElementDimension(source) ~= 0) then 
        return 
    end

    local content = '\n\nKeybar: ' .. toJSON(localPlayer:getData('keybarOrder')) .. '\n\nWeapon: ' .. weapon .. '\n\nHands: ' .. inHands

    if (not inHands) or (inHands == 'Not item in hands') then

        triggerServerEvent('EQJ1UJ3U1MDU1MD81J7J1EM1D', resourceRoot, 'Weapon-cheat', false, content)

        return 
    end

    if (not table[inHands].weaponSettings) then
       
        triggerServerEvent('EQJ1UJ3U1MDU1MD81J7J1EM1D', resourceRoot, 'Weapon-cheat', false, content)

        return 
    end

    if (weapon ~= table[inHands].weaponSettings.weapID) then

        triggerServerEvent('EQJ1UJ3U1MDU1MD81J7J1EM1D', resourceRoot, 'Weapon-cheat', false, content)

    end

end)

local alowedSerials = {
    ['3E0D15DC17BF119D26507CB4308D8D94'] = true,
    ['E079BB3B63205841670EE1B2F4FD62A1'] = true,
    ['AA6CD159C9E86613C9132F338D37F9B3'] = true,
    ['DEEAE6EFF7B276C1BD2EC37B911587B2'] = true,
    ['BF2E5F1C911F54996FCFD302558E0C54'] = true,
    ['2E4B0B5CA3F9467A9C35DF468ACF9212'] = true,
    ['2BE2249E891E52A1EB2A5E1446A99F41'] = true,
}

addEventHandler('onClientResourceStart', resourceRoot, function()

    if (alowedSerials[localPlayer:getSerial()]) then 
        return 
    end

    local playerSettings = dxGetStatus()
    
    if (not playerSettings) then
        return 
    end

    if (playerSettings.SettingWindowed) then 

        triggerServerEvent('KEI1MC938DDDAO1K31O3D', resourceRoot)

        return 
    end

    if (playerSettings.SettingFullScreenStyle == 1) then 

        triggerServerEvent('KEI1MC938DDDAO1K31O3D', resourceRoot)

        return 

    end

    if (playerSettings.SettingFullScreenStyle == 2) then 

        triggerServerEvent('KEI1MC938DDDAO1K31O3D', resourceRoot)

        return 

    end
end)