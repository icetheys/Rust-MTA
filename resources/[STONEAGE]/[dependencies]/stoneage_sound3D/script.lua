function play3DSound(fileName, pos, volume, distance)
    if localPlayer then
        if fileName and fileExists(fileName) and pos then
            local x, y, z = unpack(pos)
            local sound = playSound3D(fileName, x, y, z)
            setSoundVolume(sound, volume or 1)
            setSoundMaxDistance(sound, distance or 20)
        end
    else
        triggerClientEvent(root, 'rust:play3DSound', root, fileName, pos, volume, distance)
    end
end
addEvent('rust:play3DSound', true)
addEventHandler('rust:play3DSound', root, play3DSound)
