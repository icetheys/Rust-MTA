local Init = function()
    for weapID, arr in pairs(PROPERTIES) do
        for k, v in pairs(arr) do
            if k == 'flags' then
                for _, v in pairs(v) do
                    setWeaponProperty(weapID, 'poor', k, v)
                    setWeaponProperty(weapID, 'std', k, v)
                    setWeaponProperty(weapID, 'pro', k, v)
                end
            else
                setWeaponProperty(weapID, 'poor', k, v)
                setWeaponProperty(weapID, 'std', k, v)
                setWeaponProperty(weapID, 'pro', k, v)
            end
        end
    end
    local glitches = {'quickreload', 'fastmove', 'fastfire', 'crouchbug', 'highcloserangedamage', 'hitanim', 'fastsprint', 'baddrivebyhitbox',
                      'quickstand'}

    for _, glitch in ipairs(glitches) do
        setGlitchEnabled(glitch, false)
    end
end
addEventHandler('onResourceStart', resourceRoot, Init)
