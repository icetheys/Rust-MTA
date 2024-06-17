loadEvent('Damage:Apply', root, function(victim, bodypart, damage, usedWeapon, hitx, hity, hitz)
    if (not isElement(client)) then
        return false
    end

    if (not isElement(victim)) then
        return false
    end

    if getElementData(client, 'isDead') then
        return false
    end

    if getElementData(victim, 'isDead') then
        return false
    end

    if (bodypart == 'head') then
        if getElementData(victim, 'Helmet_used') then
            triggerEvent('removeDefenseItemOnDestroy', client, victim, 'Helmet')
            triggerClientEvent(client, 'AddHitMarker', client, 'headshot.png', nil, hitx, hity, hitz)
            return
        end

        damage = damage * math.randomf(50, 100)

    elseif (bodypart == 'peito') then
        if getElementData(victim, 'Vest_used') then
            local vestHealth = getElementData(victim, 'vest_health') or 6500
            setElementData(victim, 'vest_health', vestHealth - damage)
            if (vestHealth - damage <= 0) then
                triggerEvent('removeDefenseItemOnDestroy', client, victim, 'Vest')
            else
                return
            end
        end
    end

    damage = math.floor(damage)

    setElementData(victim, 'bleeding', (getElementData(victim, 'bleeding') or 0) + damage / 100)
    setElementData(victim, 'blood', (getElementData(victim, 'blood') or 0) - damage)

    if (getElementData(victim, 'blood') or 0) <= 0 then
        triggerEvent('player:onDie', victim, {
            headshot = bodypart == 'head',
            weapon = usedWeapon,
            reason = getPlayerName(client),
        })

        triggerEvent('player:onKill', client, victim, {
            weap = usedWeapon,
            headshot = bodypart == 'head',
        })

        if (bodypart == 'head') then
            triggerClientEvent(client, 'AddHitMarker', client, 'fodase', damage, hitx, hity, hitz)
        else
            triggerClientEvent(client, 'AddHitMarker', client, 'die.png', damage, hitx, hity, hitz)
        end

    else
        if (bodypart == 'head') then
            triggerClientEvent(client, 'AddHitMarker', client, 'headshot.png', damage, hitx, hity, hitz)
        else
            triggerClientEvent(client, 'AddHitMarker', client, 'health.png', damage, hitx, hity, hitz)
        end
    end

    return true
end)
