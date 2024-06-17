local planeSound

function iniciar_som()
    for i, obj in ipairs(getElementsByType('object', resourceRoot)) do
        if getElementModel(obj) == 1683 then
            if not planeSound then
                planeSound = playSound3D('sounds/Airdrop1.mp3', 0, 0, -500, true)
                setSoundMinDistance(planeSound, 300)
                setSoundMaxDistance(planeSound, 3000)
                setSoundVolume(planeSound, 0.2)
                attachElements(planeSound, obj)
                setTimer(function(planeSound)
                    if isElement(planeSound) then
                        stopSound(planeSound)
                    end
                end, 24000 * 5 * 1.75, 1, planeSound)
            end
        end
    end
end
addEventHandler('onClientRender', getRootElement(), iniciar_som)

addEventHandler('onClientElementDestroy', resourceRoot, function()
    if getElementModel(source) == 1683 then
        if isElement(planeSound) then
            stopSound(planeSound)
        end
    end
end)

engineSetModelLODDistance(1683, 400)
engineSetModelLODDistance(1691, 400)
engineSetModelLODDistance(2060, 400)
