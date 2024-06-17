-- //------------------- CHAT STUFF -------------------\\--
local chat = {
    floods = {},
}

addEventHandler('onPlayerChat', root, function(msg, msgType)
    cancelEvent()

    -- normal message
    if msgType == 0 then
        if chat.floods[source] then
            sendTranslatedMessage(source, 'nao spame', 255, 0, 0)
            return
        end
        if isPlayerMuted(source) then
            sendTranslatedMessage(source, 'você está mutado', 255, 0, 0)
            return
        end
        chat.floods[source] = true
        msg = ('[LOCAL]%s: %s'):format(getPlayerName(source), removeHex(msg))
        for k, v in ipairs(getElementsNear(source, 'player', 100)) do
            outputChatBox(msg, v, 255, 255, 255)
        end

        LOGS:saveLog('chat.local', removeHex(msg))

        setTimer(function(player)
            if chat.floods[player] then
                chat.floods[player] = nil
            end
        end, 1000, 1, source)

        LOGS:onSendChatMessage(source, 'chat-local', removeHex(msg))
    end
end)

addCommandHandler('globalchat', function(player, _, ...)
    if getElementData(root, 'BlockedChat') then
        outputChatBox('Global chat is blocked.', player, 255, 0, 0)
        return false
    end
    if chat.floods[player] then
        sendTranslatedMessage(player, 'nao spame', 255, 0, 0)
        return
    end
    if isPlayerMuted(player) then
        sendTranslatedMessage(player, 'você está mutado', 255, 0, 0)
        return
    end
    local msg = table.concat({...}, ' ')

    chat.floods[player] = true
    if utf8.len(msg) > 0 then
        msg = ('%s%s: #FFF5EE%s'):format(isVIP(player) and '#DAA520' or '#A52A2A', getPlayerName(player), removeHex(msg))
        outputChatBox(msg, root, 255, 255, 255, true)
        LOGS:saveLog('chat.global', removeHex(msg))
        LOGS:onSendChatMessage(player, 'chat-global', removeHex(msg))
    end

    setTimer(function(player)
        if chat.floods[player] then
            chat.floods[player] = nil
        end
    end, 1000, 1, player)
end, false, false)

addEventHandler('onPlayerQuit', root, function()
    if chat.floods[source] then
        chat.floods[source] = nil
    end
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for k, v in ipairs(getElementsByType('player')) do
        bindKey(v, 'm', 'down', 'chatbox', 'globalchat')
    end
end)

addEventHandler('onPlayerJoin', root, function()
    bindKey(source, 'm', 'down', 'chatbox', 'globalchat')
end)
-- //------------------- CHAT STUFF -------------------\\--
