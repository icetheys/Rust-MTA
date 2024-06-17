Heli = {}

local Init = function()
    engineSetModelLODDistance(425, 500)
    triggerServerEvent('CheckHelicopter', localPlayer)
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

addEvent('ReceiveHeliInfo', true)
addEventHandler('ReceiveHeliInfo', localPlayer, function(heli, stage)
    ForgetHeli()
    
    if isElement(heli) then
        if (stage == 'initial') then
            
            Heli.Element = heli
            
            local x, y, z = getElementPosition(Heli.Element)
            
            Heli.Weapon = createWeapon('ak-47', x, y, z - 3)
            attachElements(Heli.Weapon, Heli.Element, 0, 0, -3)
            setWeaponFlags(Heli.Weapon, "disable_model", true)
            setWeaponFlags(Heli.Weapon, "instant_reload", true)
            setWeaponFlags(Heli.Weapon, "shoot_if_out_of_range", true)
            setWeaponFlags(Heli.Weapon, "shoot_if_blocked", true)
            
            setHelicopterRotorSpeed(Heli.Element, 1)
            
            Heli.Sound = playSound3D('assets/sound.mp3', x, y, z, true)
            attachElements(Heli.Sound, Heli.Element)
            setSoundVolume(Heli.Sound, 0.8)
            setSoundMinDistance(Heli.Sound, 300)
            setSoundMaxDistance(Heli.Sound, 2000)

            if getElementData(localPlayer, 'staffRole') then
                addEventHandler('onClientRender', root, RenderHeliHealth)
            end
        
        elseif (stage == 'destroyed') then
            if isElement(Heli.Element) then
                setHelicopterRotorSpeed(Heli.Element, 0)
            end
        
        end
    end
end)

addEventHandler('onClientWeaponFire', resourceRoot, function(target)
    if isElement(Heli.Element) then
        local x, y, z = getElementPosition(Heli.Element)
        exports['stoneage_sound3D']:play3DSound(':gamemode/files/sounds/weapons/sentry.wav', {x, y, z}, 0.2, 400)
    end
end)

ForgetHeli = function()
    for k, v in pairs(Heli) do
        if isElement(v) then
            destroyElement(v)
        elseif isTimer(v) then
            killTimer(v)
        end
    end
    removeEventHandler('onClientRender', root, RenderHeliHealth)
end

addEvent('ChangeHeliTarget', true)
addEventHandler('ChangeHeliTarget', resourceRoot, function(target)
    if isElement(Heli.Element) and isElement(Heli.Weapon) then
        setHelicopterRotorSpeed(Heli.Element, 1)
        if target then
            setWeaponTarget(Heli.Weapon, target)
            setWeaponState(Heli.Weapon, 'firing')
        else
            setWeaponState(Heli.Weapon, 'ready')
        end
        
        if (not isElementStreamedIn(Heli.Element)) then
            if isElement(Heli.Sound) then
                setElementPosition(Heli.Sound, getElementPosition(Heli.Element))
            end
        end
    else
        ForgetHeli()
    end
end)

addEventHandler('onClientPlayerWeaponFire', localPlayer, function(weap, _, _, hitX, hitY, hitZ, hitElement)
    if isElement(hitElement) and (getElementType(hitElement) == 'vehicle') then
        if (hitElement == Heli.Element) and (not isVehicleBlown(hitElement)) then
            local Damage = math.random(30, 60)
            setElementData(Heli.Element, 'Health', (getElementData(Heli.Element, 'Health') or 0) - Damage)
            if ((getElementData(Heli.Element, 'Health') or 0) <= 0) then
                triggerServerEvent('DestroyHelicopter', localPlayer, hitX, hitY, hitZ)
            else
                if (not getElementData(Heli.Element, 'InAlert')) then
                    triggerServerEvent('SetHeliInAlert', localPlayer)
                end
            end
        end
    end
end)


RenderHeliHealth = function()
    if isElement(Heli.Element) then
        local x, y, z = getElementPosition(Heli.Element)
        if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) <= 1000) then
            local x, y = getScreenFromWorldPosition(x, y, z + 5)
            if (x and y) then
                x = math.floor(x)
                y = math.floor(y)
                    
                local w, h = 200, 20
                local x = x - w / 2
                local y = y - h / 2
                local padding = 3
                dxDrawRectangle(x, y, w, h, tocolor(30, 30, 30, 200))
                
                local health = getElementData(Heli.Element, 'Health') or 0
                local maxHealth = getElementData(Heli.Element, 'MaxHealth') or 1000
                
                local percent = math.max(0, health / maxHealth)
                
                dxDrawRectangle(x + padding, y + padding, w * percent - padding * 2, h - padding * 2, tocolor(106, 125, 65, 200))
                
                local str = ('%s/%s (%i%%)'):format(health, maxHealth, percent * 100)
                dxDrawText(str, x, y, x + w, y + h, tocolor(255, 255, 255), 1, 'default-bold', 'center', 'center')
            end
        end
    end
end
