mathmax = math.max
mathmin = math.min
mathexp = math.exp

LastUpdate = getTickCount()
VoiceState = false

sW, sH = guiGetScreenSize()

Start = function()
    triggerServerEvent('proximity-voice:broadcastUpdate', localPlayer, getPlayersToBroadcast())
    addEventHandler('onClientRender', root, Render);
end
addEventHandler('onClientResourceStart', resourceRoot, Start);

Render = function()
    if getTickCount() - LastUpdate > 300 then
        LastUpdate = getTickCount()

        local vecCamPos = Camera.position
        local vecLook = Camera.matrix.forward.normalized

        local fMaxDistance = 45

        local fMaxVol = 5
        local fMinDistance = 5

        for _, player in pairs(getPlayersToBroadcast()) do
            local vecPlayerPos = player.position
            local fDistance = (vecPlayerPos - vecCamPos).length

            local fPanSharpness = mathmax(0, mathmin(1, (fDistance - fMinDistance) / fMinDistance))

            local fPanLimit = (0.65 * fPanSharpness + 0.35)

            local vecSound = (vecPlayerPos - vecCamPos).normalized
            local cross = vecLook:cross(vecSound)
            local fPan = mathmax(-fPanLimit, mathmin(-cross.z, fPanLimit))

            local fDistDiff = fMaxDistance - fMinDistance;

            local fVolume
            if (fDistance <= fMinDistance) then
                fVolume = fMaxVol
            elseif (fDistance >= fMaxDistance) then
                fVolume = 0.0
            else
                fVolume = mathexp(-(fDistance - fMinDistance) * (5.0 / fDistDiff)) * fMaxVol
            end

            setSoundPan(player, fPan)
            setSoundVolume(player, fVolume)
        end
    end
    if VoiceState then
        dxDrawImage(sW * 0.3 + 1, sH * 0.7 + 1, 32, 32, 'assets/icon.png', 0,0,0, tocolor(0, 0, 0))
        dxDrawImage(sW * 0.3, sH * 0.7, 32, 32, 'assets/icon.png')
    end
end

addEventHandler('onClientPlayerVoiceStart', localPlayer, function()
    VoiceState = true
end)

addEventHandler('onClientPlayerVoiceStop', localPlayer, function()
    VoiceState = false
end)

addEventHandler('onClientElementStreamIn', root, function()
    if (getElementType(source) == 'player') then
        triggerServerEvent('proximity-voice:broadcastUpdate', localPlayer, getPlayersToBroadcast())
    end
end)

addEventHandler('onClientElementStreamOut', root, function()
    if (getElementType(source) == 'player') then
        triggerServerEvent('proximity-voice:broadcastUpdate', localPlayer, getPlayersToBroadcast())
    end
end)

getPlayersToBroadcast = function()
    return getElementsByType('player', root, true)
end
