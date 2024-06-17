UTILS = exports['stoneage_utils']

LogsCache = {}

-- //------------------- SAVE LOG -------------------\\--
saveLog = function(type, text, ignoreDebugMessage)
    if (not LogsCache[type]) then
        LogsCache[type] = {}
    end

    local str = ('%s: %s'):format(UTILS:getTimeString(), text)
    table.insert(LogsCache[type], str)

    if (not ignoreDebugMessage) then
        print(('[%s]: %s'):format(type, text))
    end
end
addEvent('saveLog', true)
addEventHandler('saveLog', root, saveLog)

saveLogsToDisk = function(type)
    local fileDir = ('logs/%s.log'):format(type)
    local file = fileExists(fileDir) and fileOpen(fileDir) or fileCreate(fileDir)
    if file then
        local fileSize = fileGetSize(file)

        if (fileSize >= 5242880) then -- // 50mb
            fileClose(file)
            fileRename(fileDir, ('logs/old/%s/%s - %s.log'):format(type, type, UTILS:getTimeString(true)))
            return saveLog(type)
        end

        fileSetPos(file, fileSize)
        fileWrite(file, '\n' .. table.concat(LogsCache[type], '\n'))
        fileFlush(file)
        fileClose(file)

        LogsCache[type] = {}

        return true
    else
        print(('LOGSYSTEM: Falha ao salvar arquivo de log do tipo "%s"'):format(tostring(type)))
    end
    return false
end

setTimer(function()
    for k, v in pairs(LogsCache) do
        if (#v >= 30) then
            saveLogsToDisk(k)
        end
    end
end, 2 * 60000, 0)

ForceSaveLogsToDisk = function()
    for k, v in pairs(LogsCache) do
        if (#v > 0) then
            saveLogsToDisk(k)
        end
    end
end
addEventHandler('onResourceStop', resourceRoot, ForceSaveLogsToDisk)

-- //------------------- SAVE LOG -------------------\\--

-- //------------------- SAVE PLAYER LOG -------------------\\--
savePlayerLog = function(player, type, text, retake)
    if not isElement(player) then
        print(('LOGSYSTEM: Falha ao salvar arquivo de log de player do tipo ["%s"] com a mensagem "%s"'):format(type,
                  text))
        return false
    end

    local playerSerial = getPlayerSerial(player)
    local fileDir = ('logs/players/%s/%s.log'):format(playerSerial, type)

    local file
    if not fileExists(fileDir) then
        file = fileCreate(fileDir)
    else
        file = fileOpen(fileDir)
    end
    if file then
        local fileSize = fileGetSize(file)
        if fileSize > 524880 then -- //50mb
            fileClose(file)
            fileRename(fileDir,
                ('logs/players/%s/old/%s [%s].log'):format(playerSerial, type, UTILS:getTimeString(true)))
            return savePlayerLog(player, type, text, true)
        end

        fileSetPos(file, fileSize)
        fileWrite(file, ('%s: %s\n'):format(UTILS:getTimeString(), text))
        fileFlush(file)
        fileClose(file)

        if not retake then
            print(('*%s [%s]: %s'):format(getPlayerName(player), type, text))
        end
        return true
    end
    return false
end
addEvent('savePlayerLog', true)
addEventHandler('savePlayerLog', root, savePlayerLog)
-- //------------------- SAVE PLAYER LOG -------------------\\--

sendDiscordLog = function(logType, embeds)
    local Setting = discordAvailableLogs[logType]
    if Setting then
        postWebhook(embeds, Setting.webHookURL)
    end
end

local webhookData = {
    ['username'] = getServerName(),
    ['avatar_url'] = 'https://media.discordapp.net/attachments/489242001829789706/617068909031456788/MOSHED-2019-6-13-4-32-50.gif'
}

function postWebhook(arr, url)
    webhookData['embeds'] = arr

    local jsonifiedData = toJSON(webhookData, true)
    local sendOptions = {
        queueName = 'discord',
        connectionAttempts = 10,
        connectTimeout = 15000,
        method = 'POST',
        postData = jsonifiedData:sub(2):sub(1, #jsonifiedData - 2),
        headers = {
            ['Content-Type'] = 'application/json',
            ['Content-Length'] = #jsonifiedData - 2
        }
    }
    fetchRemote(url, sendOptions, postWebhookCallback)
end

function postWebhookCallback(responseData, errno)
    if not errno or (not errno.success) then
        print('Erro ao enviar webhook. (' .. errno.statusCode .. ')')
    end
end
