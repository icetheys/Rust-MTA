Admin.Itens = {
    Cache = {},
    ItemsToSearch = {'C4', 'L96', 'Grenade', 'Satchel', 'Rocket Launcher Ammo', 'Rocket Launcher', 'Grenade Launcher', 'Grenade Launcher Ammo', 'Flame Ammo', 'Gunpowder', 'Minerio de Enxofre', 'Sulphur'},
    -- ItemsToSearch = {'Bandage', 'Morphine'},
    LasGenTick = 0,
}

GenerateItensList = function()
    if (getTickCount() - Admin.Itens.LasGenTick) <= 30000 then
        return {}, true
    end
    Admin.Itens.LasGenTick = getTickCount()
    local elements = {}
    for _, elemType in ipairs({'object', 'vehicle', 'player'}) do
        elements[elemType] = {}
        for k, elem in ipairs(getElementsByType(elemType)) do
            if (getElementData(elem, 'invOrder')) then
                for _, itemName in ipairs(Admin.Itens.ItemsToSearch) do
                    if (getElementData(elem, itemName) or 0) > 0 then
                        if (not elements[elemType][elem]) then
                            local owner = getElementData(elem, 'owner')
                            local ownerName, ownerGroup
                            if owner then
                                local player = GAMEMODE:getAccountPlayer(owner)
                                if player then
                                    ownerGroup = getElementData(player, 'Group')
                                    ownerName = getPlayerName(player)
                                else
                                    ownerGroup = GAMEMODE:GetAccountData(owner, 'Group')
                                    ownerName = GAMEMODE:GetAccountData(owner, 'lastNick')
                                end
                            end
                            if (elemType == 'player') then
                                ownerGroup = getElementData(elem, 'Group')
                            end
                            elements[elemType][elem] = {
                                ID = getElementData(elem, 'objID') or k,
                                Name = (((elemType == 'vehicle' and getVehicleName(elem)) or getElementData(elem, 'obName')) or (elemType == 'player') and
                                    getPlayerName(elem)) or '*Desconhecido',
                                Position = {getElementPosition(elem)},
                                Owner = ownerName,
                                OwnerGroup = ownerGroup,
                                Items = {},
                            }
                        end
                        elements[elemType][elem]['Items'][itemName] = (getElementData(elem, itemName) or 0)
                    end
                end
            end
        end
    end
    elements['Accounts'] = {}
    local Query = SQL:Query('SELECT * FROM `Accounts`')
    if (#Query > 0) then
        for k, account in ipairs(Query) do
            local accName = account.name
            if (not GAMEMODE:GetAccountData(accName, 'isDead')) then
                if (not GAMEMODE:getAccountPlayer(accName)) then
                    for _, itemName in ipairs(Admin.Itens.ItemsToSearch) do
                        local has = GAMEMODE:GetAccountData(accName, itemName) or 0
                        if (has > 0) then
                            if (not elements['Accounts'][accName]) then
                                local position = GAMEMODE:GetAccountData(accName, 'position')
                                if position then
                                    elements['Accounts'][accName] = {
                                        ID = k,
                                        Name = 'Conta',
                                        Owner = GAMEMODE:GetAccountData(accName, 'lastNick') or '*Desconhecido',
                                        Position = {position.x, position.y, position.z},
                                        Items = {},
                                    }
                                end
                            end
                            if elements['Accounts'][accName] then
                                elements['Accounts'][accName]['Items'][itemName] = has
                            end
                        end
                    end
                end
            end
        end
    end
    return elements
end

RequestItensList = function(forced, sync)
    if forced then
        local cache, failed = GenerateItensList()
        Admin.Itens.Cache = cache

        if failed and isElement(client) then
            return NOTIFICATION:CreateNotification(client, 'Esta lista só pode ser recarregada a cada 30 segundos.', 'error')
        end
    end
    if sync then
        for k in pairs(Admin.OnlineStaffs) do
            triggerClientEvent(k, 'receiveItensList', k, Admin.Itens.Cache)
        end
    end
end
addEvent('requestItensList', true)
addEventHandler('requestItensList', root, RequestItensList)
