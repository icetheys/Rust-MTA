local fileName = 'serverSettings.json'

local ServerSettings = {}

local Init = function()
    if fileExists(fileName) then
        local file = fileOpen(fileName)
        if file then
            local fContent = fileRead(file, fileGetSize(file))
            local data = fContent and fromJSON(fContent)
            if data then
                ServerSettings = data
            end
        end
        fileClose(file)
    end
end
addEventHandler('onResourceStart', resourceRoot, Init)

local Stop = function()
    if fileExists(fileName) then
        fileDelete(fileName)
    end
    local file = fileCreate(fileName)
    fileSetPos(file, 0)
    fileWrite(file, toJSON(ServerSettings, true, 'tabs'))
    fileClose(file)
end
addEventHandler('onResourceStop', resourceRoot, Stop)

getConfig = function(settingName, defaultValue)
    local setting = ServerSettings[settingName]
    if setting == nil then
        return defaultValue
    else
        return setting
    end
end

setConfig = function(settingName, value)
    ServerSettings[settingName] = value
end
