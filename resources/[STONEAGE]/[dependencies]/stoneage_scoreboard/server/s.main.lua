RequestServerInfo = function()
    triggerClientEvent(client, 'receiveScoreboardServerInfo', client, getServerName(), getMaxPlayers())
end
addEvent('requestScoreboardServerInfo', true)
addEventHandler('requestScoreboardServerInfo', root, RequestServerInfo)
