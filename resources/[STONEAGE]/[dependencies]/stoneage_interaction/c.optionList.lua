local OptionsByElementType = {
    ['object'] = function(ob, itemInHands, equippedID, optionalArgs)
        GAMEMODE = exports['gamemode']
        
        local obName = getElementData(ob, 'obName')
        if not obName then
            return
        end
        
        if optionalArgs and optionalArgs.hitPos and itemInHands then
            local x, y, z = unpack(optionalArgs.hitPos)
            local explosives = GAMEMODE:getGamePlayConfig('explosives')
            if explosives[itemInHands] then
                CreateOption({
                    Name = translate('Plantar item', nil, itemInHands),
                    Icon = 'plantar_explosivo.png',
                }, function()
                    triggerServerEvent('craft:plantExplosive', localPlayer, itemInHands, x, y, z)
                end)
            end
        end
        
        setInteractionHeader(translate(obName, 'name'), getHealthString(ob))
        
        if (obName == 'Baú Pequeno' or obName == 'Baú Grande') then
            predefinedOption.openInventory(ob)
            local evolved = GAMEMODE:getObjectDataSetting(obName, 'evolutionTo')
            if evolved then
                CreateOption({
                    Name = translate('Evoluir'),
                    Icon = 'evoluir.png',
                }, function()
                    triggerServerEvent('craft:evolveObject', localPlayer, ob, evolved)
                end)
            end
            predefinedOption.move(ob)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'Wardrobe') then
            local pass = getElementData(ob, 'wardrobe:password')
            CreateOption({
                Name = translate('Abrir inventário'),
                Icon = 'abrir_inventario.png',
            }, function()
                local savedPass = exports['stoneage_settings']:getConfig('Senha do armário', '')
                if pass and (pass ~= savedPass) then
                    GAMEMODE:showWardrobePassword(true, {
                        TypingPass = true,
                        password = savedPass,
                        header = 'Este armário está bloqueado!\nInsira a senha para continuar.',
                    }, ob, pass)
                else
                    GAMEMODE:toggleInventory(true)
                    GAMEMODE:setLootSource(ob)
                end
            end)
            
            local creator = GAMEMODE:isCreator(ob) or isAdmin(localPlayer)
            if creator then
                CreateOption({
                    Name = translate('Alterar senha'),
                    Icon = 'alterar_senha.png',
                }, function()
                    if ((getElementData(ob, 'Locker') or 0) > 0) or GAMEMODE:isAdmin(localPlayer) then
                        GAMEMODE:showWardrobePassword(true, {
                            password = pass or '',
                            header = 'Insira uma nova senha para este armário',
                            SettingNewPassword = true,
                        }, ob)
                    else
                        exports['stoneage_notifications']:CreateNotification(
                            translate('precisa keylock dentro', nil, translate('Wardrobe', 'name'), translate('Locker', 'name')), 'error')
                    end
                end)
                
                CreateOption({
                    Name = translate('Ver permissões'),
                    Icon = 'ver_permissoes.png',
                }, function()
                    GAMEMODE:showWardrobePermissions(true, ob)
                end)
            end
            
            if GAMEMODE:isFriendly(ob) or isAdmin(localPlayer) then
                CreateOption({
                    Name = translate('Reparar Objetos'),
                    Icon = 'reparar_objetos.png',
                }, function()
                    triggerServerEvent('craft:repairAllObjects', localPlayer, ob)
                end)
                predefinedOption.move(ob)
            end
            
            if (not pass) or creator then
                predefinedOption.destroy(ob, obName)
            end
        
        elseif (obName == 'Sandbags' or obName == 'Barricade') then
            predefinedOption.move(ob)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'Espetos') then
            predefinedOption.move(ob)
            if GAMEMODE:isFriendly(ob) or isAdmin(localPlayer) then
                predefinedOption.destroy(ob, obName)
            end
        
        elseif (obName == 'Poço') then
            CreateOption({
                Name = translate('Coletar água', nil, getElementData(ob, 'poço:water'), 100),
                Icon = 'coletar_agua.png',
            }, function()
                triggerServerEvent('craft:collectWaterFromWell', localPlayer, ob)
            end)
            predefinedOption.move(ob)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'gas_station') then
            local fuel = getElementData(ob, 'gasoline') or 0
            setInteractionHeader(translate(obName), ('%iL'):format(fuel))
            CreateOption({
                Name = translate('Encher Galão'),
                Icon = 'encherGalao.png',
            }, function()
                if fuel > 20 then
                    triggerServerEvent('rust:fillGallon', localPlayer, ob, equippedID)
                else
                    exports['stoneage_notifications']:CreateNotification(translate('Gasolina insuficiente'), 'error')
                end
            end)
        
        elseif (obName == 'Workbench') then
            CreateOption({
                Name = translate('Abrir inventário'),
                Icon = 'abrir_inventario.png',
            }, function()
                GAMEMODE:toggleInventory(true, {
                    inWorkbench = true,
                })
            end)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'Sentry') then
            if (getElementData(localPlayer, 'Sentry Ammo') or 0) > 0 and (getElementData(ob, 'sentry:ammo') or 0) <
                GAMEMODE:getObjectDataSetting('Sentry', 'maxAmmo') then
                CreateOption({
                    Name = translate('Inserir Munição'),
                    Icon = 'inserir_municao.png',
                }, function()
                    triggerServerEvent('sentry:addAmmoToSentry', localPlayer, ob)
                end)
            end
            
            if ((getElementData(ob, 'sentry:ammo') or 0) > 0) and (GAMEMODE:isFriendly(ob) or isAdmin(localPlayer))  then
                CreateOption({
                    Name = translate('Remover Munição'),
                    Icon = 'remover_municao.png',
                }, function()
                    triggerServerEvent('sentry:removeAmmoFromSentry', localPlayer, ob)
                end)
            end
            
            predefinedOption.move(ob)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'Mesa de pesquisa') then
            predefinedOption.openInventory(ob)
            predefinedOption.move(ob)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'Fixed Torch') then
            if getElementData(ob, 'fire') then
                predefinedOption.apagar_fogo(ob)
            else
                predefinedOption.acender_fogo(ob, equippedID)
                predefinedOption.move(ob)
                predefinedOption.destroy(ob, obName)
            end
        
        elseif (obName == 'Fogueira') then
            if getElementData(ob, 'fire') then
                local items = {
                    ['Raw Meat'] = 'Meat Cooked',
                }
                if items[itemInHands] then
                    CreateOption({
                        Name = translate('Assar item'),
                        Icon = 'assar_item.png',
                    }, function()
                        triggerServerEvent('craft:assarItem', localPlayer, ob, equippedID, items[itemInHands])
                    end)
                end
                predefinedOption.apagar_fogo(ob)
            else
                predefinedOption.acender_fogo(ob, equippedID)
                predefinedOption.move(ob)
                predefinedOption.destroy(ob, obName)
            end
        
        elseif (obName == 'Fornalha') then
            predefinedOption.openInventory(ob)
            if getElementData(ob, 'fire') then
                predefinedOption.apagar_fogo(ob)
            else
                predefinedOption.acender_fogo(ob, equippedID)
                predefinedOption.move(ob)
                predefinedOption.destroy(ob, obName)
            end
        
        elseif (obName == 'Planter') then
            local possiblePlants = {'Seed Corn', 'Seed Pumpkin', 'Seed Potato'}
            local plantsHere = getElementData(ob, 'planter:plants')
            
            if not plantsHere or table.size(plantsHere) < 3 then
                for k, v in ipairs(possiblePlants) do
                    if (getElementData(localPlayer, v) or 0) >= 1 then
                        CreateOption({
                            Name = translate('Plantar item', nil, translate(v, 'name')),
                            Icon = 'plantar_item.png',
                        }, function()
                            triggerServerEvent('planter:onPlayerPlant', localPlayer, ob, v)
                        end)
                    end
                end
            end
            
            for k, v in pairs(plantsHere or {}) do
                if v.progress == 100 then
                    CreateOption({
                        Name = translate('Colher item', nil, translate(v.itemName, 'name')),
                        Icon = 'colher_item.png',
                    }, function()
                        triggerServerEvent('planter:onPlayerPickPlant', localPlayer, ob, v.itemName)
                    end)
                end
            end
            
            predefinedOption.move(ob)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'Placa') then
            if GAMEMODE:isFriendly(ob) or isAdmin(localPlayer) then
                CreateOption({
                    Name = translate('Mudar Texto'),
                    Icon = 'mudar_texto_placa.png',
                }, function()
                    GAMEMODE:showPlateTextEdit(true, {
                        object = ob,
                        currentText = (getElementData(ob, 'placa:text') or ''),
                    })
                end)
                
                predefinedOption.move(ob)
                predefinedOption.destroy(ob, obName)
            end
        
        elseif getElementData(ob, 'lootPickup') then
            setInteractionHeader(translate(obName), getHealthString(ob))
            if (getElementData(ob, 'health') or 0) > 0 then
                KEEP_FIRE_CONTROL = true
                
                CreateOption({
                    Name = translate('Abrir'),
                    Icon = 'causar_dano_pickup.png',
                }, function()
                    exports['stoneage_pickups']:damagePickup(ob, math.random(500, 600), true)
                end)
            end
        
        elseif (obName == 'farmObject') then
            local farmType = getElementData(ob, 'farmType')
            setInteractionHeader(translate(farmType, 'name'))
            KEEP_FIRE_CONTROL = true
            local possibleItems = exports['stoneage_farms']:getPossibleFarms() or {}
            for k, v in ipairs(possibleItems) do
                local have = getElementData(ob, v) or 0
                if have > 0 then
                    CreateOption({
                        Name = translate('Coletar item', nil, translate(v, 'name'), have),
                        Icon = 'causar_dano_pickup.png',
                    }, function()
                        exports['stoneage_farms']:damageFarm(ob, v)
                    end)
                end
            end
        
        elseif getElementData(ob, 'lootBox') or (obName == 'hospitalPack') then
            setInteractionHeader(translate(obName))
            predefinedOption.openInventory(ob)
        
        elseif getElementData(ob, 'gearPickup') then
            setInteractionHeader(obName)
            predefinedOption.openInventory(ob)
            
            if isAdmin(localPlayer) then
                CreateOption({
                    Name = 'Destruir saco (STAFF)',
                    Icon = 'destruir.png',
                }, function()
                    triggerServerEvent('destroySack', localPlayer, ob, true)
                end)
            end
        
        elseif GAMEMODE:isBaseItem(obName) then
            
            local obType = getElementData(ob, 'obType')
            local friendly = GAMEMODE:isFriendly(ob) or isAdmin(localPlayer)
            
            if (obType == 'Porta') or (obType == 'Portão') then
                if friendly then
                    CreateOption({
                        Name = translate('Abrir'),
                        Icon = 'abrir_porta.png',
                    }, function()
                        if (obType == 'Porta') then
                            triggerServerEvent('craft:abrirPorta', localPlayer, ob, GAMEMODE:directionOpenDoor(ob))
                        elseif (obType == 'Portão') then
                            triggerServerEvent('craft:abrirPortão', localPlayer, ob, GAMEMODE:directionOpenDoor(ob))
                        end
                    end)
                end
                CreateOption({
                    Name = 'Toc-Toc',
                    Icon = 'toc_toc_porta.png',
                }, function()
                    triggerServerEvent('craft:beatDoor', localPlayer, ob)
                end)
            
            elseif obType == 'Janela' then
                if friendly then
                    CreateOption({
                        Name = translate('Abrir/fechar'),
                        Icon = 'abrir_fechar_janela.png',
                    }, function()
                        triggerServerEvent('craft:abrirJanela', localPlayer, ob)
                    end)
                
                end
            end
            if (itemInHands == 'Hammer') and friendly then
                local evolved = GAMEMODE:getObjectDataSetting(obName, 'evolutionTo')
                if evolved then
                    CreateOption({
                        Name = translate('Evoluir'),
                        Icon = 'evoluir.png',
                    }, function()
                        ToggleBaseUpgrade(ob, evolved)
                    -- exports['stoneage_base_building']:ToggleBaseUpgrade(true, ob, evolved)
                    end)
                end
                
                predefinedOption.move(ob)
                predefinedOption.destroy(ob, obName)
            end
        
        elseif (obName == 'Cama') then
            predefinedOption.move(ob)
            predefinedOption.destroy(ob, obName)
        
        elseif (obName == 'keyLocker') then
            setInteractionHeader(translate(obName))
            CreateOption({
                Name = translate('Inserir cartao'),
                Icon = 'inserir_keycard.png',
            }, function()
                triggerServerEvent('inserirCard', localPlayer, ob, equippedID)
            end)
        
        elseif (obName == 'Airdrop') then
            setInteractionHeader(obName)
            predefinedOption.openInventory(ob)
        
        elseif (obName == 'Recycler') then
            setInteractionHeader(translate(obName))
            predefinedOption.openInventory(ob)
        
        end
        
        if isAdmin(localPlayer) then
            if getElementData(ob, 'owner') then
                CreateOption({
                    Name = 'Informações deste objeto',
                    Icon = 'info.png',
                }, function()
                    ToggleObjectInfo(ob)
                end)
            end
        end
    
    end,
    ['ped'] = function(ped, itemInHands, equippedID)
        if getElementData(ped, 'Horse') then
            local health = getElementData(ped, 'Health') or 0
            CreateOption({
                Name = translate('subir', nil, health),
                Icon = 'evoluir.png',
            }, function()
                triggerServerEvent('AttachPlayerToHorse', localPlayer, ped)
            end)
            
            local energy = getElementData(ped, 'Energy') or 0
            if (energy <= 80) then
                CreateOption({
                    Name = translate('alimentar', nil, energy),
                    Icon = 'comer.png',
                }, function()
                    triggerServerEvent('FeedHorse', localPlayer, ped, equippedID)
                end)
            end
        
        end
    end,
    ['player'] = function(player, itemInHands, equippedID)
        GAMEMODE = exports['gamemode']
        
        if (player == localPlayer) then
            setInteractionHeader(translate(itemInHands, 'name'))
            
            local itemType = GAMEMODE:getItemType(itemInHands)
            
            if (itemType == 'food') then
                CreateOption({
                    Name = translate('Comer'),
                    Icon = 'comer.png',
                }, function()
                    if getPedAnimation(localPlayer) then
                        return false
                    end
                    triggerServerEvent('rust:onPlayerConsumeItem', localPlayer, itemInHands, equippedID, true)
                end)
            
            elseif (itemType == 'drink') then
                CreateOption({
                    Name = translate('Beber'),
                    Icon = 'beber.png',
                }, function()
                    if getPedAnimation(localPlayer) then
                        return false
                    end
                    triggerServerEvent('rust:onPlayerConsumeItem', localPlayer, itemInHands, equippedID, true)
                end)
            
            elseif (itemType == 'medicament') then
                CreateOption({
                    Name = translate('Usar'),
                    Icon = 'beber.png',
                }, function()
                    if getPedAnimation(localPlayer) then
                        return false
                    end
                    triggerServerEvent('rust:onPlayerConsumeMedicament', localPlayer, localPlayer, itemInHands, equippedID)
                end)
            
            elseif (itemType == 'blueprint') then
                CreateOption({
                    Name = translate('Aprender'),
                    Icon = 'aprender_blueprint.png',
                }, function()
                    triggerServerEvent('rust:learnBlueprint', localPlayer, equippedID, itemInHands)
                end)
            end
        else
            setInteractionHeader(getPlayerName(player))
            local itemType = GAMEMODE:getItemType(itemInHands)
            if (not getElementData(player, 'isDead')) then
                if getElementData(player, 'desmaiado') then
                    CreateOption({
                        Name = translate('Curar'),
                        Icon = 'curar.png',
                    }, function()
                        triggerServerEvent('onSavePlayer', localPlayer, player, true, equippedID)
                    end)
                end
                if (itemType == 'medicament') then
                    CreateOption({
                        Name = translate('Usar item', nil, translate(itemInHands, 'name')),
                        Icon = 'comer.png',
                    }, function()
                        if getPedAnimation(localPlayer) then
                            return false
                        end
                        triggerServerEvent('rust:onPlayerConsumeMedicament', localPlayer, player, itemInHands, equippedID)
                    end)
                end
            end
        end
    end,
    ['vehicle'] = function(veh, itemInHands, equippedID)
        GAMEMODE = exports['gamemode']
        
        if (isVehicleBlown(veh) and (not isAdmin(localPlayer)) and (not getElementData(veh, 'HeliDrop'))) then
            return
        end
        
        setInteractionHeader(getVehicleName(veh), ('%i/1000'):format(getElementHealth(veh)))
        predefinedOption.openInventory(veh)
        
        local model = getElementModel(veh)
        local modelInfo = exports['stoneage_vehicles']:getVehicleSettingInfo(model)
        
        if modelInfo then
            if getElementHealth(veh) < 1000 then
                CreateOption({
                    Name = translate('Reparar porcentagem', nil, math.floor(getElementHealth(veh) / 10)),
                    Icon = 'reparar_veiculo.png',
                }, function()
                    triggerServerEvent('startRepairingVehicle', localPlayer, veh)
                end)
            end
            if (modelInfo.maxEngine or 0) > (getElementData(veh, 'engine') or 0) then
                CreateOption({
                    Name = translate('Colocar item', nil, translate('Engine', 'name'), (getElementData(veh, 'engine') or 0), (modelInfo.maxEngine or 0)),
                    Icon = 'colocar_engine.png',
                }, function()
                    triggerServerEvent('changeVehicleDatas', localPlayer, veh, equippedID, 'engine', 1, nil, 'Engine')
                end)
            end
            if (modelInfo.maxBattery or 0) > (getElementData(veh, 'battery') or 0) then
                CreateOption({
                    Name = translate('Colocar item', nil, translate('Vehicle Battery', 'name'), (getElementData(veh, 'battery') or 0),
                        (modelInfo.maxBattery or 0)),
                    Icon = 'colocar_bateria.png',
                }, function()
                    triggerServerEvent('changeVehicleDatas', localPlayer, veh, equippedID, 'battery', 1, nil, 'Vehicle Battery')
                end)
            end
            if (modelInfo.maxTire or 0) > (getElementData(veh, 'tires') or 0) then
                CreateOption({
                    Name = translate('Colocar item', nil, translate('Tire', 'name'), (getElementData(veh, 'tires') or 0), (modelInfo.maxTire or 0)),
                    Icon = 'colocar_pneu.png',
                }, function()
                    triggerServerEvent('changeVehicleDatas', localPlayer, veh, equippedID, 'tires', 1, nil, 'Tire')
                end)
            end
            if (modelInfo.maxFuel or 0) > (getElementData(veh, 'fuel') or 0) then
                CreateOption({
                    Name = translate('Colocar item', nil, translate('Gallon', 'name'), math.floor(getElementData(veh, 'fuel') or 0), (modelInfo.maxFuel or 0)),
                    Icon = 'colocar_galao.png',
                }, function()
                    local quantity = 20
                    if (getElementData(veh, 'fuel') or 0) + quantity > (modelInfo.maxFuel or 0) then
                        quantity = (modelInfo.maxFuel or 0) - (getElementData(veh, 'fuel') or 0)
                    end
                    triggerServerEvent('changeVehicleDatas', localPlayer, veh, equippedID, 'fuel', quantity, nil, 'Gallon')
                end)
            end
            if (itemInHands == 'Toolbox') then
                if (getElementData(veh, 'engine') or 0) > 0 then
                    CreateOption({
                        Name = translate('Tirar item', nil, translate('Engine', 'name')),
                        Icon = 'tirar_engine.png',
                    }, function()
                        triggerServerEvent('changeVehicleDatas', localPlayer, veh, equippedID, 'engine', -1, 'Engine')
                    end)
                end
                if (getElementData(veh, 'battery') or 0) > 0 then
                    CreateOption({
                        Name = translate('Tirar item', nil, translate('Vehicle Battery', 'name')),
                        Icon = 'tirar_bateria.png',
                    }, function()
                        triggerServerEvent('changeVehicleDatas', localPlayer, veh, equippedID, 'battery', -1, 'Vehicle Battery')
                    end)
                end
                if (getElementData(veh, 'tires') or 0) > 0 then
                    CreateOption({
                        Name = translate('Tirar item', nil, translate('Tire', 'name')),
                        Icon = 'tirar_pneu.png',
                    }, function()
                        triggerServerEvent('changeVehicleDatas', localPlayer, veh, equippedID, 'tires', -1, 'Tire')
                    end)
                end
            end
        end
    end,
}

predefinedOption = {
    acender_fogo = function(ob, equippedID)
        CreateOption({
            Name = translate('Acender'),
            Icon = 'acender_fogo.png',
        }, function()
            triggerServerEvent('craft:toggleFire', localPlayer, ob, true, equippedID)
        end)
    end,
    apagar_fogo = function(ob)
        CreateOption({
            Name = translate('Apagar'),
            Icon = 'apagar_fogo.png',
        }, function()
            triggerServerEvent('craft:toggleFire', localPlayer, ob, false)
        end)
    end,
    destroy = function(ob, obName)
        CreateOption({
            Name = translate('Destruir'),
            Icon = 'destruir.png',
        }, function()
            GAMEMODE:showConfirmWindow(true, {
                reason = 'destroyObject',
                object = ob,
                obName = obName,
            })
        end)
    end,
    move = function(ob)
        if GAMEMODE:isFriendly(ob) or isAdmin(localPlayer) then
            CreateOption({
                Name = translate('Movimentar'),
                Icon = 'movimentar.png',
            }, function()
                if isPedOnGround(localPlayer) then
                    setElementCollisionsEnabled(ob, false)
                    setElementFrozen(localPlayer, true)
                    triggerServerEvent('craft:startMovingObject', localPlayer, ob)
                end
            end)
        end
    end,
    openInventory = function(ob)
        CreateOption({
            Name = translate('Abrir inventário'),
            Icon = 'abrir_inventario.png',
        }, function()
            GAMEMODE:toggleInventory(true)
            GAMEMODE:setLootSource(ob)
        end)
    end,
}

CheckOptionsToDisplay = function(optionalArgs)
    local elemType = getElementType(Interaction.SelectedObject)
    
    if OptionsByElementType[elemType] then
        local itemInHands = getElementData(localPlayer, 'equippedItem')
        local equippedID = getElementData(localPlayer, 'equippedSlotID')
        
        KEEP_FIRE_CONTROL = false
        
        OptionsByElementType[elemType](Interaction.SelectedObject, itemInHands, equippedID, optionalArgs)
        
        if (#Interaction.DisplayOptions == 0) then
            KEEP_FIRE_CONTROL = true
        end
        
        ToggleInteractionUI(true)
    
    end
end

setInteractionHeader = function(str, ...)
    if ({...}) then
        Interaction.Header = (str or '') .. '\n' .. table.concat({...}, '\n')
    else
        Interaction.Header = str
    end
end

CreateOption = function(displayArray, callBack)
    table.insert(Interaction.DisplayOptions, {
        options = displayArray,
        callBack = callBack,
    })
end

ResetOptions = function()
    Interaction.SubTable = nil
    Interaction.DisplayOptions = {}
end

function getHealthString(ob)
    if ob and isElement(ob) then
        local obName = getElementData(ob, 'obName')
        local health = getElementData(ob, 'health') or 0
        local maxHealth = getElementData(ob, 'maxHealth') or exports['gamemode']:getObjectDataSetting(obName, 'maxHealth') or 999999
        return ('(%i/%i)'):format(health, maxHealth)
    end
    return false
end

ToggleBaseUpgrade = function(ob, options)
    KEEP_FIRE_CONTROL = false
    
    Interaction.SelectedOptionID = 1
    Interaction.DisplayOptions = {}
    Interaction.SubTable = true
    
    setInteractionHeader(translate('Evoluir'), translate(getElementData(ob, 'obName'), 'name'), '\n⮟')
    for k, v in ipairs(options) do
        CreateOption({
            Name = ('%s\n\n\n\n%s'):format(translate(v, 'name'), exports['gamemode']:getObjectCustoString(v, 1, localPlayer)),
            Icon = ('base_upgrade_%s.png'):format(exports['gamemode']:getObjectDataSetting(v, 'objLevel') or 1),
        }, function()
            
            local newLevel = exports['gamemode']:getObjectDataSetting(getElementData(ob, 'obName'), 'objLevel') or 1
            
            if (not CheckObjectLevel(ob, newLevel + 1)) then
                local str = exports['stoneage_translations']:translate('cant_evolve')
                exports['stoneage_notifications']:CreateNotification(str, 'error')
                return false
            end
            
            if getElementData(localPlayer, 'WaitingResponse') then
                return
            end

            setElementData(localPlayer, 'WaitingResponse', true)
            
            triggerServerEvent('craft:evolveObject', localPlayer, ob, v)
        end)
    end
    
    Interaction.DisplayQuantity = #Interaction.DisplayOptions
end

CheckObjectLevel = function(ob, newLevel)
    local x, y, z = getElementPosition(ob)
    
    local hit, _, _, _, hitElement = processLineOfSight(x, y, z, x, y, z - 5, false, false, false, true, false, false, false, false, ob)
    
    if (not hit) then
        return true
    end
    
    if (not isElement(hitElement)) then
        return true
    end
    
    local hitElementObName = getElementData(hitElement, 'obName')
    
    if (not hitElementObName) then
        return true
    end
    
    local hitElementLevel = exports['gamemode']:getObjectDataSetting(hitElementObName, 'objLevel') or 1

    if (newLevel <= hitElementLevel) then
        return true
    end
    
    return false
end

ToggleObjectInfo = function(ob)
    Interaction.RequestedObjectInfo = ob
    Interaction.SubTable = true
    triggerServerEvent('requestObjectInfo', localPlayer, ob)
end

ReceiveObjectInfo = function(ob, infos)
    if (Interaction.RequestedObjectInfo == ob) then
        KEEP_FIRE_CONTROL = false
        
        Interaction.SelectedOptionID = 1
        Interaction.DisplayOptions = {}
        
        setInteractionHeader('Informações sobre', (getElementData(ob, 'obName') or '*Desconhecido'))
        
        for k, v in ipairs(infos) do
            if v[2] then
                local str = ('%s:\n%s'):format(v[1], v[2])
                CreateOption({
                    Name = str,
                    Icon = 'info.png',
                }, function()
                    outputConsole(str)
                end)
            end
        end
        
        Interaction.DisplayQuantity = #Interaction.DisplayOptions
        
        Interaction.RequestedObjectInfo = nil
    end
end
addEvent('receiveObjectInfo', true)
addEventHandler('receiveObjectInfo', root, ReceiveObjectInfo)
