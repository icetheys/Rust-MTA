LOGS = exports['stoneage_logs']
SQL = exports['stoneage_sql']
BONE_ATTACH = exports['stoneage_bone_attach']
TRANSLATION = exports['stoneage_translations']
UTILS = exports['stoneage_utils']

-- //------------------- WORLD MANIPULATION -------------------\\--
addEventHandler('onResourceStart', resourceRoot, function() --
    local now = getRealTime()
    setTime(now.hour, now.minute)
    setMinuteDuration(6000)
    setFPSLimit(65)
    for k, data in pairs(playerSpawns) do
        for _, v in ipairs(data) do
            local dummy = createElement('playerSpawn')
            setElementPosition(dummy, unpack(v))
        end
    end
end)

addEventHandler('onPlayerJoin', root, function()
    setPlayerName(source, removeHex(getPlayerName(source)))
end)
-- //------------------- WORLD MANIPULATION -------------------\\--
