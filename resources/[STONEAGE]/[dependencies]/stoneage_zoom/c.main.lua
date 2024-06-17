bindKey('mouse3', 'both', function(_, state)
    if (state == 'down') and isCursorShowing() then
        return false
    end
    
    local fov = dxGetStatus()['SettingFOV']
    
    if (state == 'down') then
        fov = fov * 0.5
    end

    setCameraFieldOfView('player', fov)
end)