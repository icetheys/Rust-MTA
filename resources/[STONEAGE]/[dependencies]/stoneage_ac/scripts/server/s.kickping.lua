local Checks = {}

CheckPings = function()
    local min = {
        ping = exports['stoneage_settings']:getConfig('LimitPing', 500),
        packetloss = exports['stoneage_settings']:getConfig('LimitLoss', 5),
    }
    
    local avisos = {
        ping = exports['stoneage_settings']:getConfig('AvisosPing', 5),
        packetloss = exports['stoneage_settings']:getConfig('AvisosLoss', 5),
    }
    
    for k, player in ipairs(getElementsByType('player')) do
        if (not getElementData(player, 'staffRole')) then
            if (not Checks[player]) then
                Checks[player] = {
                    ping = {},
                    packetloss = {},
                }
            end
            
            local current = {
                ping = getPlayerPing(player),
                packetloss = getNetworkStats(player)['packetlossLastSecond']
            }
            
            for type, value in pairs(current) do
                table.insert(Checks[player][type], value)
                
                local str = ('Your %s is too high: %i/%i'):format(type, value, min[type])
                
                if (value > min[type]) then
                    outputChatBox(str, player, 255, 255, 0)
                end
                
                if (#Checks[player][type] > avisos[type]) then
                    local q = 0
                    
                    for _, v in ipairs(Checks[player][type]) do
                        q = q + v
                    end
                    
                    local avg = q / avisos[type]
                    
                    if (avg > min[type]) then
                        triggerEvent('rust:customKick', player, str)
                    else
                        Checks[player][type] = {}
                    end
                end
            end
        end
    end
end
-- setTimer(CheckPings, 1000, 0)

addEventHandler('onPlayerQuit', root, function()
    Checks[source] = nil
end)
