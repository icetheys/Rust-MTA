WarpTo = function(player, target)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if isElement(player) and isElement(target) then
        if ((getElementType(player) == 'player') and getPedOccupiedVehicle(player)) then
            player = getPedOccupiedVehicle(player)
        end
        local vehicle = (getElementType(target) == 'player') and (getPedOccupiedVehicle(target))
        local x, y, z = getElementPosition(target)
        setElementPosition(player, x + math.random(), y + math.random(), z)
        setElementInterior(player, getElementInterior(target))
        setElementDimension(player, getElementDimension(target))
        if vehicle then
            warpPedIntoVehicle(player, vehicle, 1)
        elseif (getElementType(target) == 'vehicle') then
            -- warpPedIntoVehicle(player, target, 0)
        end
        if (player == client) then
            NOTIFICATION:CreateNotification(client, 'Você acabou de se teletransportar até este jogador/veiculo.', 'info')
        else
            NOTIFICATION:CreateNotification(client, 'Você acabou de teletransportar este jogador/veiculo até você.', 'info')
        end
    end
end
addEvent('warpTo', true)
addEventHandler('warpTo', root, WarpTo)

FreezeUnfreeze = function(elem)
    if (isElement(elem)) then
        local state = not isElementFrozen(elem)

        if (getElementType(elem) == 'player') and getPedOccupiedVehicle(elem) then
            elem = getPedOccupiedVehicle(elem)
        end

        setElementFrozen(elem, state)
        if state then
            NOTIFICATION:CreateNotification(client, 'Você acabou de freezar este jogador/veiculo.', 'info')
        else
            NOTIFICATION:CreateNotification(client, 'Você acabou de desfreezar este jogador/veiculo.', 'info')
        end
    end
end
addEvent('freezeUnfreeze', true)
addEventHandler('freezeUnfreeze', root, FreezeUnfreeze)

_DestroyElement = function(elem)
    if (isElement(elem)) then

        local x, y, z = getElementPosition(elem)
        local str = ('%s destruiu um veiculo (%s) em %s (%s)'):format(GetAdminName(client), getVehicleName(elem),
                        getZoneName(x, y, z), getZoneName(x, y, z, true))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

        destroyElement(elem)
        NOTIFICATION:CreateNotification(client, 'Você acabou de destruir este objeto/veiculo.', 'info')
    end
end
addEvent('_destroyElement', true)
addEventHandler('_destroyElement', root, _DestroyElement)

_KickPlayer = function(player, reason)
    if isElement(player) then

        local str = ('%s expulsou %s (%s)'):format(GetAdminName(client), getPlayerName(player), reason)
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

        kickPlayer(player, reason)
        NOTIFICATION:CreateNotification(client, 'Jogador expulso com sucesso.', 'info')
    end
end
addEvent('_kickPlayer', true)
addEventHandler('_kickPlayer', root, _KickPlayer)

RepairVehicle = function(veh)
    if (isElement(veh)) then
        fixVehicle(veh)
        setElementHealth(veh, 1000)

        local _, ry, rz = getElementRotation(veh)
        setElementRotation(veh, 0, ry, rz)

        NOTIFICATION:CreateNotification(client, 'Veículo reparado com sucesso.', 'info')

        local x, y, z = getElementPosition(veh)
        local str = ('%s reparou um veiculo (%s) em %s (%s)'):format(GetAdminName(client), getVehicleName(veh),
                        getZoneName(x, y, z), getZoneName(x, y, z, true))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    end
end
addEvent('repairVehicle', true)
addEventHandler('repairVehicle', root, RepairVehicle)

MontarVeiculo = function(veh)
    if (isElement(veh)) then

        local settings = exports['stoneage_vehicles']:getVehicleSettingInfo(getElementModel(veh))

        setElementData(veh, 'fuel', settings.maxFuel or 0)
        setElementData(veh, 'engine', settings.maxEngine or 0)
        setElementData(veh, 'tires', settings.maxTire or 0)
        setElementData(veh, 'battery', settings.maxBattery or 0)

        NOTIFICATION:CreateNotification(client, 'Veículo montado com sucesso.', 'info')

        local x, y, z = getElementPosition(veh)
        local str = ('%s montou um veiculo (%s) em %s (%s)'):format(GetAdminName(client), getVehicleName(veh),
                        getZoneName(x, y, z), getZoneName(x, y, z, true))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    end
end
addEvent('montarVeiculo', true)
addEventHandler('montarVeiculo', root, MontarVeiculo)

TogglePlayerAlpha = function(state)
    setElementAlpha(source, state and 0 or 255)
end
addEvent('togglePlayerAlpha', true)
addEventHandler('togglePlayerAlpha', root, TogglePlayerAlpha)

KickAll = function(reason)
    local q = 0
    for k, v in ipairs(getElementsByType('player')) do
        if not Admin.OnlineStaffs[v] then
            kickPlayer(v, reason)
            q = q + 1
        end
    end
    NOTIFICATION:CreateNotification(client, ('Você acabou de expulsar %i jogadores do servidor.'):format(q), 'info')

    local str = ('%s expulsou todos os jogadores do servidor (%s).'):format(GetAdminName(client), reason)
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

end
addEvent('kickAll', true)
addEventHandler('kickAll', root, KickAll)

SendNotification = function(target, text, time)
    NOTIFICATION:CreateNotification(target, text, 'info', time)

    local str
    if (getElementType(target) == 'player') then
        str = ('%s enviou uma notificação para "%s" com o texto "%s" (%i segundos)'):format(GetAdminName(client),
                  getPlayerName(target), text, time / 1000)
    else
        str = ('%s enviou uma notificação global com o texto "%s" (%i segundos)'):format(GetAdminName(client), text,
                  time / 1000)
    end
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)
end
addEvent('sendNotification', true)
addEventHandler('sendNotification', root, SendNotification)

SetVehicleGasoline = function(vehicle, percent)
    if isElement(vehicle) then
        setElementData(vehicle, 'fuel', percent)
        NOTIFICATION:CreateNotification(client,
            ('Você acabou de setar a gasolina deste veiculo para %i%%.'):format(percent), 'info')
    end
end
addEvent('setVehicleGasoline', true)
addEventHandler('setVehicleGasoline', root, SetVehicleGasoline)

SpawnAirdrop = function()
    exports['stoneage_airdrop']:spawnDrop(client)
    NOTIFICATION:CreateNotification(client, 'Airdrop enviado com sucesso.', 'info')

    local x, y, z = getElementPosition(client)
    local str = ('%s spawnou um airdrop em %s (%s)'):format(GetAdminName(client), getZoneName(x, y, z),
                    getZoneName(x, y, z, true))
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFFFF00,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

end
addEvent('spawnAirdrop', true)
addEventHandler('spawnAirdrop', root, SpawnAirdrop)

local possibleNames = {'SwiftBlaze', 'CrystalKiller', 'NeonNemesis', 'CrimsonFury', 'ElectricVortex', 'FrozenFlame', 
'DarkValkyrie', 'SilverSaber', 'ThunderousTitan', 'SonicSpear', 'SpectralSorceress', 'BlazingBrawler', 
'ShadowSoldier', 'MightyMage', 'RadiantRanger', 'StormySiren', 'GhostlyGladiator', 'FrostFire', 'EnchantedEagle', 
'FieryFeline', 'DarknessDominator', 'VenomousViper', 'ChaosChampion', 'ShimmeringShark', 'MysticMystique', 
'ThunderBoltz', 'EternalEmperor', 'RagingRider', 'SavageSpartacus', 'DivineDiva', 'ToxicTerminator', 'FlameFalcon', 
'IceImpaler', 'SilentSamurai', 'NightmareNinja', 'BloodthirstyBear', 'GrimGunslinger', 'LunarLion', 'ElectricEnigma', 
'MoonMist', 'SolarSavage', 'ThunderousThunderbird', 'ShadowSlash', 'ElysianEmpress', 'CrimsonCurse', 'MysticalMermaid', 
'SilverStreak', 'FrostFrenzy', 'NeonNinjaWarrior', 'VenomousValkyrie', 'EnigmaticEagle', 'BlazingBanshee', 'DarkDestroyer', 
'RadiantRaven', 'StormySeer', 'GhostlyGrimoire', 'SpectralSpecter', 'FrozenFalcon', 'FieryFury', 'ThunderousThundercat', 
'SavageSalamander', 'DivineDoom', 'ToxicTyrant', 'FlameFeline', 'IceInferno', 'SilentStorm', 'NightshadeNecromancer', 
'BloodthirstyBison', 'GrimGhost', 'LunarLeopard', 'ElectricEcho', 'MoonMaelstrom', 'SolarSorceror', 'ThunderousThunderstorm', 
'ShadowShaman', 'ElysianElemental', 'CrimsonClaw', 'MysticalMyth', 'SilverSonic', 'FrostFang', 'NeonNimble', 'VenomousVampire',
'EnigmaticEclipse', 'BlazingBolt', 'DarkDagger', 'RadiantRaider', 'StormySorcerer', 'GhostlyGuardian', 
'SpectralSwordsman', 'FrozenFury', 'FieryFlare', 'ThunderousTiger', 'SavageSwordsman', 'DivineDancer', 
'ToxicTornado', 'FlameFist', 'IceInfliction', 'SilentSaber', 'NightmareNavigator', 'BloodthirstyBeast', 
'GrimGoliath', 'LunarLancer'}

SetRandomNickname = function(state)
    local nick = state and possibleNames[math.random(#possibleNames)] or GetAdminName(client)
    local tries = 0
    while getPlayerFromName(nick) and (tries <= 100) do
        nick = possibleNames[math.random(#possibleNames)]
        tries = tries + 1
    end
    if setPlayerName(client, nick) then
        return NOTIFICATION:CreateNotification(client, ('Nome setado para "%s"'):format(nick), 'info')
    end
    NOTIFICATION:CreateNotification(client, 'Falha ao trocar de nick.', 'error')
end
addEvent('setRandomNick', true)
addEventHandler('setRandomNick', root, SetRandomNickname)

local lastVehiclesWipe = 0
WipeVehicles = function()
    if ((getTickCount() - lastVehiclesWipe) >= 5000) then
        lastVehiclesWipe = getTickCount()
        exports['stoneage_vehicles']:wipeVehicles()
        NOTIFICATION:CreateNotification(client, 'Veículos resetados com sucesso.', 'info')

        local str = ('%s acabou de wipar todos os veiculos.'):format(GetAdminName(client))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFFFF00,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Este botão já foi utilizado por alguem nos ultimos 2 minutos.',
            'error')
    end
end
addEvent('wipeVehicles', true)
addEventHandler('wipeVehicles', root, WipeVehicles)

local lastFarmsWipe = 0
WipeFarms = function()
    if ((getTickCount() - lastFarmsWipe) >= 2 * 60000) then
        lastFarmsWipe = getTickCount()
        exports['stoneage_farms']:wipeFarms()
        NOTIFICATION:CreateNotification(client, 'Farms resetados com sucesso.', 'info')

        local str = ('%s acabou de wipar todos os recursos de farm.'):format(GetAdminName(client))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFFFF00,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Este botão já foi utilizado por alguem nos ultimos 2 minutos.',
            'error')
    end
end
addEvent('wipeFarms', true)
addEventHandler('wipeFarms', root, WipeFarms)

local lastRunDecay = 0
RunDecay = function()
    if ((getTickCount() - lastRunDecay) >= 2 * 60000) then
        lastRunDecay = getTickCount()
        exports['gamemode']:RunDecay()
        NOTIFICATION:CreateNotification(client, 'Decay executado com sucesso.', 'info')

        local str = ('%s acabou de executar o decay manual.'):format(GetAdminName(client))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFFFF00,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Este botão já foi utilizado por alguem nos ultimos 2 minutos.',
            'error')
    end
end
addEvent('runDecay', true)
addEventHandler('runDecay', root, RunDecay)

RunObjectsRepair = function()
    if ((getTickCount() - lastRunDecay) >= 2 * 60000) then
        exports['gamemode']:RepairAllObjects()
        NOTIFICATION:CreateNotification(client, 'Objetos reparados com sucesso.', 'info')

        local str = ('%s acabou de reparar todos os objetos de base'):format(GetAdminName(client))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFFFF00,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Este botão já foi utilizado por alguem nos ultimos 2 minutos.',
            'error')
    end
end
addEvent('runObjectsRepair', true)
addEventHandler('runObjectsRepair', root, RunObjectsRepair)

local lastSaveLogs = 0
SaveLogsToDisk = function()
    if ((getTickCount() - lastSaveLogs) >= 10000) then
        lastSaveLogs = getTickCount()
        exports['stoneage_logs']:ForceSaveLogsToDisk()
        NOTIFICATION:CreateNotification(client, 'Logs salvos com sucesso com sucesso.', 'info')

        local str = ('%s acabou de salvar os logs no disco'):format(GetAdminName(client))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFFFF00,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Este botão já foi utilizado por alguem nos ultimos 10 segundos.',
            'error')
    end
end
addEvent('saveLogsToDisk', true)
addEventHandler('saveLogsToDisk', root, SaveLogsToDisk)

local lastPocosFill = 0
fillPocos = function()
    if ((getTickCount() - lastPocosFill) >= 10000) then
        lastPocosFill = getTickCount()
        exports['gamemode']:addWaterToPocos()
        NOTIFICATION:CreateNotification(client, 'Poços abastecidos com sucesso com sucesso.', 'info')

        local str = ('%s acabou de adicionar água para todos os poços craftados.'):format(GetAdminName(client))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFFFF00,
        }}
        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

    else
        NOTIFICATION:CreateNotification(client, 'Este botão já foi utilizado por alguem nos ultimos 10 segundos.',
            'error')
    end
end
addEvent('fillPocos', true)
addEventHandler('fillPocos', root, fillPocos)

addEvent('clearChat', true)
addEventHandler('clearChat', root, function()
    for i = 1, 50 do
        outputChatBox(' ')
    end

    local str = ('%s acabou de limpar o chat.'):format(GetAdminName(client))
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFFFF00,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

    NOTIFICATION:CreateNotification(client, 'Você acabou de limpar o chat.', 'info')
end)

addEvent('resetSerialObjects', true)
addEventHandler('resetSerialObjects', root, function(serial)
    local q = 0
    for k, v in ipairs(getElementsByType('object')) do
        if (getElementData(v, 'owner') == serial) then
            local obName = getElementData(v, 'obName')
            local nick = GetAdminName(client)
            local x, y, z = getElementPosition(v)

            local logMessage = ('STAFF-RESET: %s destruiu um "%s" de "%s" em %s (%s)'):format(nick, obName, serial,
                                   getZoneName(x, y, z), getZoneName(x, y, z, true))

            q = q + 1

            exports['gamemode']:destroyObject(v, 'object-destroy', logMessage)
        end
    end

    local str = ('%s acabou de resetar todos os objetos do serial "%s".'):format(GetAdminName(client), serial)
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

    NOTIFICATION:CreateNotification(client, ('%s objetos foram deletados.'):format(q), 'info')
end)

addEvent('resetAccount', true)
addEventHandler('resetAccount', root, function(serial)
    local player = exports['gamemode']:getAccountPlayer(serial)
    if player then
        kickPlayer(player, 'account-reset')
    end

    local groupName = GAMEMODE:GetAccountData(serial, 'Group')
    if groupName then
        local Group = exports['stoneage_groupsystem']:GetGroup(groupName)
        if Group then
            if (Group.Creator == serial) then
                exports['stoneage_groupsystem']:DestroyGroup(groupName)
            else
                exports['stoneage_groupsystem']:RemoveSerialFromGroup(groupName, serial)
            end
        end
    end

    SQL:Exec('DELETE * FROM `Accounts` WHERE `Owner`=?', serial)
    exports['gamemode']:ClearAccountDataCache(serial)

    local str = ('%s acabou de resetar a conta do serial "%s".'):format(GetAdminName(client), serial)
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

    NOTIFICATION:CreateNotification(client, 'Conta resetada com sucesso.', 'info')

end)

addEvent('checkAccount', true)
addEventHandler('checkAccount', root, function(serial)
    local infos = {}

    local player = exports['gamemode']:getAccountPlayer(serial)
    if player then
        infos['Nick'] = getPlayerName(player)
        infos['Group'] = getElementData(player, 'Group')
        infos['Level'] = getElementData(player, 'Level')
    else
        infos['Nick'] = exports['gamemode']:GetAccountData(serial, 'lastNick')
        infos['Group'] = exports['gamemode']:GetAccountData(serial, 'Group')
        infos['Level'] = exports['gamemode']:GetAccountData(serial, 'Level')
    end

    outputChatBox(('----'):rep(25), client, 255, 255, 255)
    outputChatBox(('Informações sobre o serial %s'):format(serial), client, 255, 255, 255)
    for k, v in pairs(infos) do
        if v then
            outputChatBox(('%s: %s'):format(k, v), client, 255, 255, 255, true)
        end
    end
    outputChatBox(('----'):rep(25), client, 255, 255, 255)

    local str = ('%s buscou informalções sobre o serial "%s".'):format(GetAdminName(client), serial)
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}
    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)
end)

addEvent('setHour', true)
addEventHandler('setHour', root, function(hour)
    setTime(hour, 0)

    local str = ('%s alterou a hora do servidor para "%s".'):format(GetAdminName(client), hour)
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}

    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)
end)

addEvent('removePlayerItem', true)
addEventHandler('removePlayerItem', root, function(player, itemName, quantity)
    if isElement(player) then
        setElementData(player, itemName, math.max(0, (getElementData(player, itemName) or 0) - quantity))

        local str = ('%s removeu %i "%s" do inventário de %s ("%s")'):format(GetAdminName(client), quantity, itemName,
                        getPlayerName(player), getPlayerSerial(player))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}

        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

        triggerClientEvent(client, 'SyncWhenEditPlayerInv', client, player)
    else
        NOTIFICATION:CreateNotification(client, 'Jogador não encontrado.', 'error')
    end
end)

addEvent('_givePlayerItem', true)
addEventHandler('_givePlayerItem', root, function(player, itemName, quantity)
    if isElement(player) then
        setElementData(player, itemName, (getElementData(player, itemName) or 0) + quantity)

        local str = ('%s deu %i "%s" para %s ("%s")'):format(GetAdminName(client), quantity, itemName,
                        getPlayerName(player), getPlayerSerial(player))
        local embeds = {{
            ['description'] = str,
            ['color'] = 0xFF0000,
        }}

        exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
        exports['stoneage_logs']:saveLog('staff-actions', str)

        triggerClientEvent(client, 'SyncWhenEditPlayerInv', client, player)
    else
        NOTIFICATION:CreateNotification(client, 'Jogador não encontrado.', 'error')
    end
end)

addEvent('refuelGasStations', true)
addEventHandler('refuelGasStations', root, function()
    exports['stoneage_gas_stations']:RefuelGasStations()

    local str = ('%s abasteceu todos os postos de gasolina.'):format(GetAdminName(client))
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}

    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

end)

addEvent('toggleChatState', true)
addEventHandler('toggleChatState', root, function()
    local state = not getElementData(root, 'BlockedChat')
    setElementData(root, 'BlockedChat', state)
    if state then
        NOTIFICATION:CreateNotification(client, 'Você acabou de bloquear o chat.', 'info')
    else
        NOTIFICATION:CreateNotification(client, 'Você acabou de desbloquear o chat.', 'error')
    end
end)

addEvent('weaponAnim', true)
addEventHandler('weaponAnim', root, function()
    local state = not getElementData(root, 'weapon_switch_anim')
    setElementData(root, 'weapon_switch_anim', state)
    exports['stoneage_settings']:setConfig('weapon_switch_anim', state)
    if state then
        NOTIFICATION:CreateNotification(client, 'Você acabou de habilitar a animação ao trocar de arma.', 'info')
    else
        NOTIFICATION:CreateNotification(client, 'Você acabou de desabilitar a animação ao trocar de arma', 'error')
    end
end)

addEvent('spawnHelicopter', true)
addEventHandler('spawnHelicopter', root, function()
    exports['stoneage_helicopter']:SpawnHeli()

    local str = ('%s acabou de spawnar um helicoptero atirador.'):format(GetAdminName(client))
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}

    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

end)

addEvent('destroyHelicopter', true)
addEventHandler('destroyHelicopter', root, function()
    exports['stoneage_helicopter']:DestroyPreviousHeli()

    local str = ('%s acabou de destruir o helicoptero atirador.'):format(GetAdminName(client))
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}

    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

end)

addEvent('spawnShip', true)
addEventHandler('spawnShip', root, function()
    exports['stoneage_ship']:SpawnShip()

    local str = ('%s acabou de spawnar um navio.'):format(GetAdminName(client))
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}

    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

end)

addEvent('destroyShip', true)
addEventHandler('destroyShip', root, function()
    exports['stoneage_ship']:ForgetPreviousShip()

    local str = ('%s acabou de destruir o navio.'):format(GetAdminName(client))
    local embeds = {{
        ['description'] = str,
        ['color'] = 0xFF0000,
    }}

    exports['stoneage_logs']:sendDiscordLog('staff-actions', embeds)
    exports['stoneage_logs']:saveLog('staff-actions', str)

end)
