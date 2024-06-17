local allowedDamageType = {
    ['Fall'] = true,
    ['Rammed'] = true,
    ['Katana'] = true,
    ['Drowned'] = true,
    ['Chainsaw'] = true,
    ['Poolstick'] = true,
    ['Shovel'] = true,
    ['Bat'] = true,
    ['Knife'] = true,
    ['Nightstick'] = true,
    ['Golfclub'] = true,
    ['Brassknuckle'] = true,
    ['Fist'] = true,
    ['Teargas'] = true,
    ['Minigun'] = true,
    ['Flamethrower'] = true,
    ['Explosion'] = true,
    ['Grenade'] = true,
    ['Rocket'] = true,
}

doesntFaint = { -- // tipos de danos que não causa desmaio
    ['Drowned'] = true,
}

addEventHandler('onClientPlayerDamage', localPlayer, function(attacker, damageType, bodypart, loss)
    cancelEvent(true)

    local damageReason = getWeaponNameFromID(damageType)

    if getElementData(localPlayer, 'antiSpawnKill') then
        return
    end

    if getElementData(localPlayer, 'isDead') then
        return
    end

    if isAdmin(localPlayer) then
        return
    end

    if (damageReason and allowedDamageType[damageReason]) or attacker and (((damageType == 0) and (getElementType(attacker) == 'ped')) or (getElementType(attacker) == 'weapon')) then
        local damage = getPlayerDataSetting('blood', 'max') * (loss * 1.3) / 100

        if damageReason == 'Teargas' and getElementModel(localPlayer) == 73 then
            damage = damage / 300
        elseif damageReason == 'Drowned' then
            damage = damage / 10
        elseif attacker and (getElementType(attacker) == 'weapon') and (damageReason == 'AK-47') then
            damage = damage / 5
        end

        if damageReason == 'Minigun' then
            damage = damage / 3
            setElementData(localPlayer, 'bleeding', (getElementData(localPlayer, 'bleeding') or 0) + damage / 100)
        end

        if damage > 2000 then
            if math.random(100) <= 20 then
                setElementData(localPlayer, 'brokenbone', true)
            end
        end
        damage = math.floor(damage)

        setElementData(localPlayer, 'blood', (getElementData(localPlayer, 'blood') or 0) - damage)

        if getElementData(localPlayer, 'blood') <= 0 then
            triggerServerEvent('player:onDie', localPlayer, {
                reason = damageReason,
            })

        elseif getElementData(localPlayer, 'blood') < 5000 and not doesntFaint[damageReason] then
            if math.random(100) <= 40 then
                -- triggerServerEvent('onPlayerFaint', localPlayer, true)
            end
        end
    end
end)

local posTable = {
    ['head'] = {8},
    ['peito'] = {3},
    ['perna'] = {42, 52},
}

function hitedPart(x, y, z, ped, where)
    if isElement(ped) then
        local array = posTable[where]
        if array then
            for k, v in ipairs(array) do
                local px, py, pz = getPedBonePosition(ped, v)
                if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < (where == 'head' and 0.2 or 0.3) then
                    return true
                end
            end
        end
    end
    return false
end

addEventHandler('onClientPlayerWeaponFire', localPlayer, function(weap, _, _, hitx, hity, hitz, hitElement, startx, starty, startz)
    local elemType = hitElement and isElement(hitElement) and getElementType(hitElement)

    if not elemType or getElementData(hitElement, 'antiSpawnKill') or isAdmin(hitElement) then
        return
    end

    if elemType == 'player' then
        if (getSlotFromWeapon(weap) == 8) then
            return false
        end

        local usedWeapon = getElementData(localPlayer, 'equippedItem')

        local damage = usedWeapon and getWeaponDamage(usedWeapon)

        if (not damage) then
            return false
        end

        damage = damage + math.random(-100, 100)

        local bodypart

        if hitedPart(hitx, hity, hitz, hitElement, 'head') then
            bodypart = 'head'
        elseif hitedPart(hitx, hity, hitz, hitElement, 'peito') then
            bodypart = 'peito'
        end

        triggerServerEvent('Damage:Apply', localPlayer, hitElement, bodypart, damage, usedWeapon, hitx, hity, hitz)

    elseif elemType == 'vehicle' then
        addHitMarker(nil, nil, hitx, hity, hitz)

    end
end)

function getWeaponDamage(weapName)
    local weapSettings = getPlayerDataSetting(weapName, 'weaponSettings')
    if weapSettings then
        return weapSettings.damage or false
    end
    return false
end

addEventHandler('onClientPedDamage', resourceRoot, function(attacker)
    cancelEvent()
    if attacker == localPlayer and getElementData(source, 'sleepingBody') then
        if isElementLocal(source) then
            return
        end
        triggerServerEvent('player:killSleepingBody', localPlayer, source)
    end
end)

local explosionTypeFromID = {
    [0] = {
        name = 'C4/Grenade',
        damage = function()
            return 530
        end,
    },
    [1] = {
        name = 'Beans Can Grenade',
        damage = function()
            return 30
        end,
    },
    [2] = {
        name = 'Rocket Launcher',
        damage = function()
            return 600
        end,
    },
    [3] = {
        name = 'Satchel',
        damage = function()
            return 350
        end,
    },
    [12] = {
        name = 'Grenade Launcher',
        damage = function()
            return 60
        end,
    },
    [2424] = {
        name = 'Flamethrower',
        damage = function()
            return math.random(2, 10)
        end,
    },
}

addEventHandler('onClientExplosion', localPlayer, function(x, y, z, type)
    local settings = explosionTypeFromID[type]
    if settings then
        local nearObjects = {}

        for k, v in ipairs(getElementsByType('object', resourceRoot, true)) do
            if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= 3) then
                table.insert(nearObjects, v)
            end
        end

        local hitted = {}
        for k, ob in ipairs(nearObjects) do
            if not isElementLowLOD(ob) then
                local health = getElementData(ob, 'health') or 0
                local owner = getElementData(ob, 'owner')

                if owner and health > 0 then
                    local hitDirection = getHitDirection(x, y, z, ob)
                    local damage = settings.damage()

                    if hitDirection == 'cima' or hitDirection == 'dentro' then
                        damage = damage * 2
                    end

                    setElementData(ob, 'health', health - damage)

                    addHitMarker('raid.png', damage)

                    if getElementData(ob, 'wardrobe:password') then
                        setElementData(ob, 'wardrobe:password', nil)
                    end

                    table.insert(hitted, {
                        object = ob,
                        damage = damage,
                        owner = getElementData(ob, 'owner'),
                        obName = getElementData(ob, 'obName'),
                    })

                    if (getElementData(ob, 'health') <= 0) then
                        local acc = getElementData(localPlayer, 'account')
                        local nick = getPlayerName(localPlayer)
                        local obName = getElementData(ob, 'obName') or 'unknown'
                        local str = '%s ["%s"] raidou um "%s" de "%s" utilizando "%s" em %s (%s)'
                        local logMessage = (str):format(nick, acc, obName, owner, settings.name, getZoneName(x, y, z), getZoneName(x, y, z, true))
                        triggerServerEvent('craft:destroyObject', localPlayer, ob, 'raid', logMessage)
                    end
                end
            end
        end
        triggerServerEvent('onExplodeObjects', localPlayer, hitted, settings.name)
        hitted = nil
    end
end)

function getHitDirection(x, y, z, ob)
    local obName = isElement(ob) and getElementData(ob, 'obName')
    if not obName then
        return false
    end

    -- TEMP DISABLED
    do
        return false
    end

    local x1, y1, z1 = getElementPosition(ob)

    local relativePos = {
        x = x - x1,
        y = y - y1,
        z = z - z1,
    }

    local vectors = {}

    if obName:find('Fundação') or obName:find('Teto') then
        vectors = {
            ['cima'] = ob.matrix.up,
            ['baixo'] = -ob.matrix.up,
        }
    else
        vectors = {
            ['fora'] = ob.matrix.forward,
            ['dentro'] = -ob.matrix.forward,
        }
    end

    local minDistance, minIndex = 9999, 0
    for i, point in pairs(vectors) do
        local dist = getDistanceBetweenPoints3D(point.x, point.y, point.z, relativePos.x, relativePos.y, relativePos.z)
        if dist < minDistance then
            minDistance = dist
            minIndex = i
        end
    end

    return minIndex
end

local allowed_destroy_with_flame = {
    ['Wardrobe'] = true,
    ['Baú Pequeno'] = true,
    ['Baú Grande'] = true,
    ['Workbench'] = true,
    ['Espetos'] = true,
}

-- FLAME THROWER BASES DAMAGES
addEventHandler('onClientPlayerWeaponFire', localPlayer, function(weap, _, _, hitx, hity, hitz, hitElem)
    if (weap ~= 37) then
        return false
    end

    if (not isElement(hitElem)) then
        return false
    end

    if (getElementType(hitElem) ~= 'object') then
        return false
    end

    if isElementLowLOD(hitElem) then
        return false
    end

    local health = getElementData(hitElem, 'health') or 0

    if (health <= 0) then
        return false
    end

    local obName = getElementData(hitElem, 'obName')

    if (not obName) then
        return false
    end

    local check = function(obName)
        if allowed_destroy_with_flame[obName] then
            return true
        end
        if obName:find('de Madeira') or obName:find('de Palito') then
            return true
        end
        return false
    end

    if (not check(obName)) then
        return false
    end

    local damage = explosionTypeFromID[2424].damage()

    setElementData(hitElem, 'health', health - damage)

    addHitMarker('raid.png', damage, hitx, hity, hitz)

    if getElementData(hitElem, 'health') <= 0 then
        local acc = getElementData(localPlayer, 'account')
        local nick = getPlayerName(localPlayer)
        local owner = getElementData(hitElem, 'owner') or 'unknown*'
        local logMessage = '%s ["%s"] raidou um "%s" de "%s" utilizando flamethrower em %s (%s)'
        logMessage = logMessage:format(nick, acc, obName, owner, getZoneName(hitx, hity, hitz), getZoneName(hitx, hity, hitz, true))
        triggerServerEvent('craft:destroyObject', localPlayer, hitElem, 'raid', logMessage)
    end
end)

local ammoBeforeDie = {}

addEventHandler('onClientPlayerWeaponFire', localPlayer, function()
    local weapon = getElementData(localPlayer, 'equippedItem')

    if (not weapon) then
        return false
    end

    local ammo = getPlayerDataSetting(weapon, 'ammo')

    if ammo then
        if allowed_weapons_to_dec_ammo_clientside[weapon] then
            triggerServerEvent('consumeAmmo', localPlayer, ammo.name)
        end

        ammoBeforeDie = {ammo.name, getElementData(localPlayer, ammo.name) - 1}
    end
end)

loadEvent('checkAmmo1', localPlayer, function(ammo, ammoQuantity, body)
    if (ammo ~= ammoBeforeDie[1]) then
        return false
    end

    if ((ammoBeforeDie[2] or 0) > (ammoQuantity or 0)) then
        return false
    end

    setElementData(body, ammo, (ammoBeforeDie[2] or 0))

    return true
end)

loadEvent('rust:onClientPlayerDie', localPlayer, function()
    ammoBeforeDie = {}
end)
