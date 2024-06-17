function getTimeString(safe)
    local slash = safe and '-' or '/'
    local dots = safe and '.' or ':'
    local now = getRealTime()
    return ('[%02d%s%02d%s%04d - %02d%s%02d%s%02d]'):format(now.monthday, slash, now.month + 1, slash, now.year + 1900, now.hour, dots, now.minute,
                                                            dots, now.second)
end

function seconds(ms)
    return ms * 1000
end

function minutes(ms)
    return seconds(60) * ms
end

function hours(ms)
    return minutes(60) * ms
end

function days(ms)
    return hours(24) * ms
end

SecondsToTimeDesc = function(seconds, simplified, ignoreSecs)
    if seconds then
        local results = {}
        local sec = (seconds % 60)
        local min = math.floor((seconds % 3600) / 60)
        local hou = math.floor((seconds % 86400) / 3600)
        local day = math.floor(seconds / 86400)

        if day > 0 then
            table.insert(results, day .. (simplified and 'd' or (day == 1 and ' dia' or ' dias')))
        end
        if hou > 0 then
            table.insert(results, hou .. (simplified and 'h' or (hou == 1 and ' hora' or ' horas')))
        end
        if min > 0 then
            table.insert(results, min .. (simplified and 'm' or (min == 1 and ' minuto' or ' minutos')))
        end
        if sec > 0 and not ignoreSecs then
            table.insert(results, sec .. (simplified and 's' or (sec == 1 and ' segundo' or ' segundos')))
        end

        return string.reverse(table.concat(results, ', '):reverse():gsub(' ,', ' e ', 1))
    end
    return ''
end

function randomValueInTable(arr)
    local tableSize = type(arr) == 'table' and #arr
    if tableSize > 0 then
        return arr[math.random(tableSize)]
    end
    return false
end

function getTableSize(arr)
    local q = 0
    for _ in pairs(arr) do
        q = q + 1
    end
    return q
end

function randomFloatNumber(min, max)
    return math.random() * (max - min) + min
end

function getElementsNear(elem, type, dist)
    if isElement(elem) then
        local x, y, z = getElementPosition(elem)
        return getElementsWithinRange(x, y, z, dist or 5, type)
    end
    return {}
end

function getPositionFromElementOffset(element, offX, offY, offZ)
    local m = getElementMatrix(element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

function findValueInTable(arr, value)
    if arr and type(arr) == 'table' then
        for k, v in pairs(arr) do
            if (v == value) then
                return k
            end
        end
    end
    return false
end

-- local debugQ = 0
-- local defDebug = debug

-- function debug(...) -- nao vai pegar nunca por causa do getinfo(2)
--     debugQ = debugQ + 1
--     local fileName = defDebug.getinfo(2).short_src
--     local fileLine = defDebug.getinfo(2).currentline
--     fileName = utf8.sub(fileName, 23)
--     fileName = utf8.gsub(fileName, '\\', '/')

--     local prefix = string.format('#00ff00[%s - ln:%s ID:%i]', fileName, fileLine, debugQ)

--     local options
--     if localPlayer then
--         options = {255, 255, 255, true}
--     else
--         options = {root, 255, 255, 255, true}
--     end
--     return outputChatBox(prefix .. ': #ffffff' .. inspect({...}), unpack(options))
-- end

function secondsToTimeDesc(seconds)
    if seconds == 0 then
        return '0s'
    end
    if seconds then
        local results = {}
        local sec = math.floor((seconds % 60))
        local min = math.floor((seconds % 3600) / 60)
        local hou = math.floor((seconds % 86400) / 3600)
        local day = math.floor(seconds / 86400)
        if day > 0 then
            table.insert(results, day .. 'd')
        end
        if hou > 0 then
            table.insert(results, hou .. 'h')
        end
        if min > 0 then
            table.insert(results, min .. 'm')
        end
        if sec > 0 then
            table.insert(results, sec .. 's')
        end
        return string.reverse(table.concat(results, ', '):reverse():gsub(' ,', ' ', 1))
    end
    return ''
end
