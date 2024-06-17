UTILS = exports['stoneage_utils']

local Sentrys = {}
local indexedSentrys = {}

addEventHandler('onClientResourceStart', resourceRoot, function()
    ammoTexture = dxCreateTexture('assets/ammo.png', 'argb', true, 'clamp')

    local dummy = getElementByID('Sentry')
    if dummy then
        Async:foreach(getElementChildren(dummy), function(ob, k)
            InitSentry(ob)
        end)
    end

    w = UTILS:pixels(200)
    h = UTILS:pixels(20)
    iconW = UTILS:pixels(40)
end)

function handleSentry()
    if getElementType(source) == 'object' then
        local obName = getElementData(source, 'obName')
        if obName == 'Sentry' then
            if eventName == 'onClientElementStreamIn' then
                InitSentry(source)
                triggerServerEvent('sentry:requestInfo', localPlayer, source)
            else
                forgetSentry(source)
            end
        end
    end
end
addEventHandler('onClientElementStreamIn', root, handleSentry)
addEventHandler('onClientElementStreamOut', root, handleSentry)

function InitSentry(ob)
    if Sentrys[ob] then
        return
    end

    local this = {}

    this.weapon = createWeapon('minigun', 0, 0, 3)
    attachElements(this.weapon, ob, 0.5, 0, 1.15)
    setElementParent(this.weapon, ob)
    setElementAlpha(this.weapon, 0)
    setWeaponFiringRate(this.weapon, 140)
    setWeaponState(this.weapon, 'ready')

    this.renderTarget = dxCreateRenderTarget(UTILS:pixels(200), UTILS:pixels(300), true)

    addEventHandler('onClientWeaponFire', this.weapon, onSentryFire)

    addEventHandler('onClientElementDestroy', ob, function()
        forgetSentry(source)
    end)

    local newID = #indexedSentrys + 1
    this.idInTable = newID

    table.insert(indexedSentrys, newID, ob)

    Sentrys[ob] = this

    if newID == 1 then
        addEventHandler('onClientRender', root, renderSentrys)
    end
end

function forgetSentry(ob)
    if Sentrys[ob] then
        if isElement(Sentrys[ob].weapon) then
            destroyElement(Sentrys[ob].weapon)
        end
        if isElement(Sentrys[ob].renderTarget) then
            destroyElement(Sentrys[ob].renderTarget)
        end

        if Sentrys[ob].idInTable then
            table.remove(indexedSentrys, Sentrys[ob].idInTable)
            if #indexedSentrys == 0 then
                removeEventHandler('onClientRender', root, renderSentrys)
            end
        end
    end

    Sentrys[ob] = nil
end

addEvent('sentry:receiveInfo', true)
addEventHandler('sentry:receiveInfo', resourceRoot, function(ob, infos)
    if ob and Sentrys[ob] then
        Sentrys[ob].target = infos.target
        if infos.target then
            setWeaponTarget(Sentrys[ob].weapon, infos.target)
            setWeaponState(Sentrys[ob].weapon, 'firing')
        else
            setWeaponState(Sentrys[ob].weapon, 'ready')
        end
    end
end)

function onSentryFire(target, x, y, z)
    local ob = getElementParent(source)

    if (getElementData(ob, 'sentry:ammo') or 0) <= 0 then
        triggerEvent('rust:play3DSound', localPlayer, ':gamemode/files/sounds/weapons/sentry-no-ammo.wav', {x, y, z}, 0.2, 200)
        cancelEvent()
        return
    end

    triggerEvent('rust:play3DSound', localPlayer, ':gamemode/files/sounds/weapons/sentry.wav', {x, y, z}, 0.2, 200)

    if target == localPlayer then
        setElementData(ob, 'sentry:ammo', (getElementData(ob, 'sentry:ammo') or 0) - 1)
    end
end

renderSentrys = function()
    local px, py, pz = getElementPosition(localPlayer)
    local maxHealth = exports['gamemode']:getObjectDataSetting('Sentry', 'maxHealth') or 0
    local maxAmmo = exports['gamemode']:getObjectDataSetting('Sentry', 'maxAmmo')

    for i = 1, #indexedSentrys do
        local ob = indexedSentrys[i]
        local values = ob and Sentrys[ob]
        if values and values.renderTarget then
            local health = getElementData(ob, 'health') or 0
            if health > 0 then
                local x, y, z = getElementPosition(ob)
                z = z + 1.05

                if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 30 then

                    local percent = interpolateBetween(0, 0, 0, w - 4, 0, 0, health / maxHealth, 'Linear')

                    dxSetRenderTarget(values.renderTarget, true)
                    dxSetBlendMode('modulate_add')

                    if ammoTexture then
                        dxDrawImage((w - iconW) / 2, 0, iconW, iconW, ammoTexture)
                    end

                    local ammoText = ('%s/%s'):format(getElementData(ob, 'sentry:ammo') or 0, maxAmmo)
                    dxDrawText(ammoText, 0, iconW - 10, w, iconW * 2, tocolor(255, 255, 255, 255), 2, 'default-bold', 'center', 'center')

                    dxDrawRectangle(0, 35 + iconW, w, h, tocolor(255, 0, 0, 255))
                    dxDrawRectangle(2, 37 + iconW, percent, h - 4, tocolor(255, 255, 0, 155))

                    dxSetBlendMode('blend')
                    dxSetRenderTarget()

                    dxDrawMaterialLine3D(x, y, z + 0.5, x, y, z - 0.5, values.renderTarget, 0.5, tocolor(255, 255, 255, 255), false)

                    -- local x, y = getPositionFromElementOffset(ob, 0.85, 0, 0)
                    -- dxDrawLine3D(x, y, z, x, y, z + 0.7)
                    -- local sx, sy = getScreenFromWorldPosition(x, y, z + 0.75)
                    -- if sx then
                    --     local px, py = getElementPosition(localPlayer)
                    --     local rot = findRotation(x, y, px, py)
                    --     dxDrawText(inspect(rot), sx, sy)
                    -- end
                end
            end
        end
    end
end

function setDamageInCustomWeapon(weapon, _, _, hitx, hity, hitz, hitElement)
    if hitElement and isElement(hitElement) then
        local obName = getElementData(hitElement, 'obName')
        if obName == 'Sentry' then
            setElementData(hitElement, 'health', (getElementData(hitElement, 'health') or 0) - 10)
            if getElementData(hitElement, 'health') <= 0 then

                local acc = getElementData(localPlayer, 'account')
                local nick = getPlayerName(localPlayer)
                local owner = getElementData(hitElement, 'owner') or 'unknown*'
                local logMessage = ('%s ["%s"] raidou uma %s de "%s" no tiro em %s (%s)'):format(nick, acc, obName, owner,
                                                                                                 getZoneName(hitx, hity, hitz),
                                                                                                 getZoneName(hitx, hity, hitz, true))

                triggerServerEvent('craft:destroyObject', localPlayer, hitElement, 'raid', logMessage)
                exports['gamemode']:addHitMarker('die.png', 10, hitx, hity, hitz)
            else
                exports['gamemode']:addHitMarker('health.png', 10, hitx, hity, hitz)
            end
        end
    end
end
addEventHandler('onClientPlayerWeaponFire', localPlayer, setDamageInCustomWeapon)

