giveExp = function(player, quantity)
    if isElement(player) then
        local extraPercent = tonumber(exports['stoneage_settings']:getConfig('Multiplicador de experiência', 0)) or 1
        if extraPercent > 1 then
            quantity = quantity * extraPercent
            exports['stoneage_notifications']:CreateNotification(player, ('+%s Exp (%sx)'):format(quantity, extraPercent), 'event', 1000)
        else
            exports['stoneage_notifications']:CreateNotification(player, ('+%s Exp'):format(quantity), 'info', 1000)
        end
        setElementData(player, 'Exp', (getElementData(player, 'Exp') or 0) + quantity)
    end
end
