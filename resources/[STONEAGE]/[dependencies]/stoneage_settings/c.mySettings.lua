local fileName = 'mySettings.json'

local mySettings = {}

local Init = function()
    if fileExists(fileName) then
        local file = fileOpen(fileName)
        if file then
            local fContent = fileRead(file, fileGetSize(file))
            local data = fContent and fromJSON(fContent)
            if data then
                mySettings = data
            end
        end
        fileClose(file)
    end
    local lang = getConfig('Language', 'en')
    if (lang == 'pt') or (lang == 'es') or (lang == 'ar') or (lang == 'ru') or (lang == 'tr') then
        setElementData(localPlayer, 'Language', lang)
    else
        setElementData(localPlayer, 'Language', 'en')
    end
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

local Stop = function()
    setConfig('Language', getElementData(localPlayer, 'Language') or 'en')
    if fileExists(fileName) then
        fileDelete(fileName)
    end
    local file = fileCreate(fileName)
    fileSetPos(file, 0)
    fileWrite(file, toJSON(mySettings, true, 'tabs'))
    fileClose(file)
end
addEventHandler('onClientResourceStop', resourceRoot, Stop)

getConfig = function(settingName, defaultValue)
    local setting = mySettings[settingName]
    if setting == nil then
        return defaultValue
    else
        return setting
    end
end

setConfig = function(settingName, value)
    mySettings[settingName] = value
end
