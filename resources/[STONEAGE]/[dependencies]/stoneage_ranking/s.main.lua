local Ranking = {}
local LIMITE_DISPLAY = 30

updateRanking = function()
    for _, v in pairs({'alivetime:total', 'murders:total', 'Level'}) do
        local result = exports['stoneage_sql']:Query('SELECT `??`, `lastNick` FROM `Accounts` ORDER BY (SELECT CAST(? as integer)) DESC LIMIT ?', v, v, LIMITE_DISPLAY)
        table.sort(result, function(a, b)
            return a[v] > b[v]
        end)
        Ranking[v] = result
    end
    setTimer(updateRanking, 60000, 1)
end
addEventHandler('onResourceStart', resourceRoot, updateRanking)

addEvent('requestRankingList', true)
addEventHandler('requestRankingList', root, function()
    triggerClientEvent(source, 'receiveRankingList', source, Ranking)
end)
