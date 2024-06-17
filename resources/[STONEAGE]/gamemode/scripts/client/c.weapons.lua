local CacheFileExists = {}
local FireEffects = {}
local Recoil = {}
Recoil.LastCheck = getTickCount()
Recoil.LastValue = 1

DoesFileExists = function(path)
    if (CacheFileExists[path] == nil) then
        CacheFileExists[path] = fileExists(path)
    end
    return CacheFileExists[path]
end

addEventHandler('onClientPlayerWeaponFire', root, function(_, _, _, hitx, hity, hitz, hitElement)
    local x, y, z = getPedWeaponMuzzlePosition(source)
    createEffect('overheat_electric', x, y, z)
    
    local weapName = getElementData(source, 'equippedItem')
    
    if (not weapName) then
        return false
    end
    
    if (source == localPlayer) then
        if (weapName == 'Grenade Launcher') then
            triggerServerEvent('rust:createGreandeLauncherExplosion', localPlayer, hitx, hity, hitz)
        elseif (weapName == 'Rocket Launcher') then
            disequipCurrentKeybarItem()
        end
    
    end
    
    CreateFireEffect(source, x, y, z, hitx, hity, hitz)
    
    local weapSettings = getPlayerDataSetting(weapName, 'weaponSettings')
    
    if (not weapSettings) then
        return false
    end
    
    if (source == localPlayer) then
        PerformRecoil(weapSettings.extraRecoil or 0)
    end
    
    local soundPath = weapSettings.shotSound and ':gamemode/files/sounds/' .. weapSettings.shotSound
    
    if (not soundPath) then
        return false
    end
    
    if DoesFileExists(soundPath) then
        local normal_sound = playSound3D(soundPath, x, y, z, false)
        setSoundMaxDistance(normal_sound, 200)
    end
    
    soundPath = soundPath:gsub('.wav', '_far.wav')
    
    if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) >= 50) then
        if DoesFileExists(soundPath) then
            local far_sound = playSound3D(soundPath, x, y, z, false)
            setSoundMaxDistance(far_sound, 400)
            setSoundMinDistance(far_sound, 200)
        end
    end
    
    return true
end)

PerformRecoil = function(weaponName)
    local center = {x = sW * 0.49735, y = isPedDucked(localPlayer) and sH * 0.493 or sH * 0.5}
    local wx, wy, wz = getWorldFromScreenPosition(center.x, center.y, 100)
    
    local verticalRecoil = GetRecoilValue(weaponName)
    local horizontalRecoil = verticalRecoil / 2
    
    local x = wx + math.random(-horizontalRecoil, horizontalRecoil)
    local y = wy + math.random(-horizontalRecoil, horizontalRecoil)
    local z = wz + verticalRecoil
    
    return setCameraTarget(x, y, z)
end

GetRecoilValue = function(extraRecoil)
    if ((getTickCount() - Recoil.LastCheck) <= 500) then
        return Recoil.LastValue
    end
    
    local recoil = 100
    
    recoil = recoil + extraRecoil
    
    if isPedDucked(localPlayer) then
        recoil = recoil - (recoil * 0.3)
    end
    
    Recoil.LastCheck = getTickCount()
    Recoil.LastValue = math.max(0, recoil / 100)
    
    return Recoil.LastValue
end

CreateFireEffect = function(player, x, y, z, endx, endy, endz)
    table.insert(FireEffects, {
        Player = player,
        Init = {x, y, z},
        Target = {endx, endy, endz},
        InitTick = getTickCount(),
        BulletSpeed = getDistanceBetweenPoints3D(x, y, z, endx, endy, endz) * 2
    })
    if (table.maxn(FireEffects) == 1) then
        addEventHandler('onClientRender', root, RenderFireEffects)
    end
end

RenderFireEffects = function()
    for k, v in ipairs(FireEffects) do
        local passed = getTickCount() - v['InitTick']
        if (passed <= v['BulletSpeed']) then
            local x, y, z = interpolateBetween(v['Init'][1], v['Init'][2], v['Init'][3], v['Target'][1], v['Target'][2], v['Target'][3], passed / v['BulletSpeed'], 'Linear')
            local xx, yy, zz = interpolateBetween(v['Init'][1], v['Init'][2], v['Init'][3], v['Target'][1], v['Target'][2], v['Target'][3], (passed / v['BulletSpeed'] + 0.25), 'Linear')
            dxDrawLine3D(x, y, z, xx, yy, zz, tocolor(255, 255, 0, 50), (v.Player == localPlayer) and 2 or 3)
        else
            table.remove(FireEffects, k)
            if (table.maxn(FireEffects) == 0) then
                removeEventHandler('onClientRender', root, RenderFireEffects)
            end
        end
    end
end

local ExplosiveSounds = {
    [0] = {-- C4/Grenade
        PossibleSounds = {'c4_1.mp3', 'c4_2.mp3', 'c4_3.mp3'},
        FarSound = 'c4_longe.mp3',
    },
    [2] = {-- Rocket Launcher
        PossibleSounds = {'rocket_1.mp3', 'rocket_2.mp3', 'rocket_4.mp3'},
        FarSound = 'rocket_longe.mp3',
    },
    [3] = {-- Satchel
        PossibleSounds = {'satchel_1.mp3', 'satchel_2.mp3'},
        FarSound = 'satchel_longe.mp3',
    },
    [12] = {-- Grenade Launcher
        PossibleSounds = {'lancagranada_1.wav'},
        FarSound = 'lancagranada_longe.wav',
    },
}

addEventHandler('onClientExplosion', root, function(x, y, z, type)
    local explosionSettings = ExplosiveSounds[type]
    
    if (not explosionSettings) then
        return false
    end
    
    local path
    
    if (#explosionSettings.PossibleSounds > 0) then
        path = ':gamemode/files/sounds/explosions/' .. explosionSettings.PossibleSounds[math.random(#explosionSettings.PossibleSounds)]
        if DoesFileExists(path) then
            local normal_sound = playSound3D(path, x, y, z)
            setSoundMaxDistance(normal_sound, 400)
        end
    end
    
    if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) >= 50) then
        path = ':gamemode/files/sounds/explosions/' .. explosionSettings.FarSound
        if DoesFileExists(path) then
            local far_sound = playSound3D(path, x, y, z)
            setSoundMaxDistance(far_sound, 2000)
            setSoundMinDistance(far_sound, 200)
        end
    end
end)
