-- //------------------- USERFUL GLOBAL FUNCTIONS -------------------\\--
function getTimeString(safe)
    local slash = safe and '-' or '/'
    local dots = safe and '.' or ':'
    local now = getRealTime()
    local str = '[%02d%s%02d%s%04d - %02d%s%02d%s%02d]'
    return (str):format(now.monthday, slash, now.month + 1, slash, now.year + 1900, now.hour, dots, now.minute, dots, now.second)
end

function table.find(arr, value, attr)
    if arr and type(arr) == 'table' then
        for k, v in pairs(arr) do
            if attr then
                if type(v) == 'table' and v[attr] == value then
                    return k
                end
            else
                if v == value then
                    return k
                end
            end
        end
    end
    return false
end

function getAccountPlayer(accName)
    if accName then
        for k, v in ipairs(getElementsByType('player')) do
            if getElementData(v, 'account') == accName then
                return v
            end
        end
    end
    return false
end

function math.randomf(min, max)
    return math.random() * (max - min) + min
end

function table.size(arr)
    if arr and type(arr) == 'table' then
        local q = 0
        for _ in pairs(arr) do
            q = q + 1
        end
        return q
    end
    return false
end

function table.indexes(arr)
    if arr and type(arr) == 'table' then
        local t = {}
        for index in pairs(arr) do
            t[#t + 1] = index
        end
        return t
    end
    return false
end

function seconds(ms)
    return ms * 1000
end

function minutes(ms)
    return ms * 60000
end

function hours(ms)
    return minutes(60) * ms
end

function table.random(arr)
    local tableSize = type(arr) == 'table' and #arr
    if tableSize > 0 then
        return arr[math.random(tableSize)]
    end
    return false
end

function findRot(t)
    if t < 0 then
        return t + 360, true
    else
        return t, false
    end
end

function findRotation(x1, y1, x2, y2)
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

function getElementsNear(elem, type, dist)
    if isElement(elem) then
        local x, y, z = getElementPosition(elem)
        return getElementsWithinRange(x, y, z, dist or 5, type)
    end
    return {}
end

function loadEvent(eventName, attach, func)
    addEvent(eventName, true)
    if attach then
        addEventHandler(eventName, attach, function(...)
            -- if (client ~= source and source ~= resourceRoot) then
            --     return
            -- end

            return func(...)
        end)
    end
end

function setPedClothes(thePed, clothingSlot, clothingID)
    if not isElement(thePed) or type(clothingSlot) ~= 'number' then
        error('Invalid arguments to setPedClothes()!', 2)
    end

    if not clothingID then
        return removePedClothes(thePed, clothingSlot)
    end

    local hasClothes = getPedClothes(thePed, clothingSlot)
    if hasClothes then
        removePedClothes(thePed, clothingSlot)
    end

    local texture, model = getClothesByTypeIndex(clothingSlot, clothingID)
    return addPedClothes(thePed, texture, model, clothingSlot)
end

function applyClothes(ped, clothName)
    if not isElement(ped) then
        return false
    end

    if triggerClientEvent then
        triggerClientEvent(ped, 'inv:updatePreviewCloth', ped, clothName)
    end

    local settings = getPlayerDataSetting(clothName, 'clothSettings')

    if settings then
        return setPedClothes(ped, settings.type, settings.id)
    end

    return false
end

function removeClothes(ped, clothName)
    if not isElement(ped) then
        return false
    end

    if triggerClientEvent then
        triggerClientEvent(ped, 'inv:removePreviewCloth', ped, clothName)
    end

    local settings = getPlayerDataSetting(clothName, 'clothSettings')

    if settings then
        return setPedClothes(ped, settings.type, false)
    end

    return false
end

-- //------------------- USERFUL GLOBAL FUNCTIONS -------------------\\--

-- //------------------- PLAYER DATA FUNCTIONS -------------------\\--
function getPlayerDataSetting(dataName, setting)
    return playerDataTable[dataName] and playerDataTable[dataName][setting]
end

function isItemOfInventory(itemName)
    return getPlayerDataSetting(itemName, 'invSettings')
end

function getItemDisponibleAttachments(itemName)
    local itemSettings = getPlayerDataSetting(itemName, 'invSettings')
    return itemSettings and itemSettings.attachments
end

function getReceiveOnCraftQuant(itemName)
    local quantity = getPlayerDataSetting(itemName, 'receiveOnCraft')
    return quantity or 1
end

function getItemType(itemName)
    local itemSettings = getPlayerDataSetting(itemName, 'invSettings')
    return itemSettings and itemSettings.itemType
end

function getItemMaxStack(itemName)
    local itemSettings = getPlayerDataSetting(itemName, 'invSettings')
    return (itemSettings and itemSettings.maxStack) or 1
end

function getItemMaxSpawnQuantity(itemName)
    return getPlayerDataSetting(itemName, 'maxSpawnQuantity') or getItemMaxStack(itemName)
end

function getItemPossibleSounds(itemName)
    local itemSettings = getPlayerDataSetting(itemName, 'invSettings')
    return itemSettings and itemSettings.possibleSounds
end

function getItemIcon(itemName)
    local itemSettings = getPlayerDataSetting(itemName, 'invSettings')
    return ('files/images/%s'):format((itemSettings and itemSettings.icon) or 'logo.png')
end

function getItemCustoString(itemName, player)
    local custo = getPlayerDataSetting(itemName, 'craftingCusto')
    local str = ''
    if custo then
        for k, v in ipairs(custo) do
            local cost = v[2]
            if (v[1] == 'Level') and isVIP(player) then
                cost = math.ceil(cost * 0.75)
            end
            str = str .. ('%i %s%s'):format(cost, translate(v[1], 'name'), k == #custo and '.' or ', ')
        end
    end
    return str
end

function isWeapon(itemName)
    local itemType = getItemType(itemName)
    return itemType == 'weapon-primary' or itemType == 'weapon-secondary' or itemType == 'weapon-melee'
end

function getItemFurnanceSettings(itemName)
    return getPlayerDataSetting(itemName, 'furnanceSettings')
end

function isVIP(p)
    return isElement(p) and getElementData(p, 'VIP')
end

function getExpNeeded(level)
    return (level * 100) + 300
end

function isAdmin(p)
    return isElement(p) and getElementData(p, 'staffRole')
end

function isVIP(p)
    return isElement(p) and getElementData(p, 'VIP')
end
-- //------------------- PLAYER DATA FUNCTIONS -------------------\\--

-- //------------------- OBJECTS FUNCTIONS -------------------\\--
function getObjectDataSetting(obName, what)
    if objectsDataTable[obName] and objectsDataTable[obName][what] then
        return objectsDataTable[obName][what]
    end
    return false
end

function getObjectPossibleSounds(obName)
    return getObjectDataSetting(obName, 'possibleSounds')
end

function isBaseItem(obName)
    return getObjectDataSetting(obName, 'baseItem')
end

function getObjectCustoString(obName, percent, player)
    if (type(percent) ~= 'number') then
        percent = false
    end
    percent = percent or 1

    local custo = getObjectDataSetting(obName, 'craftingCusto')
    local str = ''

    if custo then
        for k, v in ipairs(custo) do
            local cost = v[2]
            if (v[1] == 'Level' and isVIP(player)) then
                cost = math.ceil(cost * 0.75)
            end
            str = str .. ('%i %s%s'):format(cost * percent, translate(v[1], 'name'), k == #custo and '.' or ', ')
        end
    end
    return str
end

function getObjectLimit(obName, player, isVIP)
    local level = getElementData(player, 'Level') or 0
    local isVIP = getElementData(player, 'VIP')

    if obName == 'baseItems' or isBaseItem(obName) then
        if ((getElementData(player, 'Wardrobe') or 0) <= 0) then
            return 15
        end
        if isVIP then
            return 65
        else
            if ((level + 15) <= 50) then
                return level + 15
            else
                return 50
            end
        end
    end
    local limit = getObjectDataSetting(obName, 'limit')
    if limit then
        return type(limit) == 'function' and limit(level) or limit
    end
    return false
end

function getObjectIcon(obName)
    local str = (':gamemode/files/images/%s'):format(getObjectDataSetting(obName, 'icon') or 'logo.png')
    return str
end

function getObModel(obName)
    return getObjectDataSetting(obName, 'modelID')
end

-- //------------------- OBJECTS FUNCTIONS -------------------\\--

convertTypeToValue = {
    ['string'] = function(value)
        return tostring(value)
    end,
    ['number'] = function(value)
        return tonumber(value)
    end,
    ['boolean'] = function(value)
        return value ~= '0'
    end,
    ['table'] = function(json)
        local arr = fromJSON(json)
        local temp = {}
        for key, value in pairs(arr) do
            if tonumber(key) then
                temp[tonumber(key)] = value
            else
                temp[key] = value
            end
        end
        arr = nil
        return temp
    end,
}

function removeHex(s)
    if type(s) == 'string' then
        while s:find('#%x%x%x%x%x%x') do
            s = s:gsub('#%x%x%x%x%x%x', '')
        end
    end
    return s
end

function getPlayerDataTable()
    return playerDataTable
end

getBaseObjectsByOwner = function(owner)
    local arr = {}
    for k, v in ipairs(getElementsByType('object')) do
        if getElementData(v, 'baseObject') and not isElementLowLOD(v) then
            if getElementData(v, 'owner') == owner then
                table.insert(arr, v)
            end
        end
    end
    return arr
end

getRequiresByOwner = function(owner)
    local quantity = {
        ['Wood'] = 0,
        ['Stone'] = 0,
        ['Iron'] = 0,
        ['Metal de Alta'] = 0,
    }

    for k, v in ipairs(getBaseObjectsByOwner(owner)) do
        local obName = getElementData(v, 'obName')
        if obName then
            if obName:find('de Madeira') then
                quantity['Wood'] = (quantity['Wood'] or 0) + 10
            elseif obName:find('de Palito') then
                quantity['Wood'] = (quantity['Wood'] or 0) + 5
            elseif obName:find('de Pedra') then
                quantity['Stone'] = (quantity['Stone'] or 0) + 10
            elseif obName:find('de Ferro') then
                quantity['Iron'] = (quantity['Iron'] or 0) + 15
            elseif obName:find('Blindad') then
                quantity['Metal de Alta'] = (quantity['Metal de Alta'] or 0) + 5
            end
        end
    end

    return quantity
end

fixJSONTable = function(table)
    local temp = {}
    if (type(table) == 'table') then
        for k, v in pairs(table) do
            if tonumber(k) then
                temp[tonumber(k)] = v
            else
                temp[k] = v
            end
        end
    end
    return temp
end

returnPrincTable = function()
    return playerDataTable
end