function translate(what, subtable, ...)
    if not what then
        error('not string to translate.', 2)
    end

    local str
    
    local arr = translateArray[what]
    if arr then
        if subtable then
            arr = arr[subtable]
        end
        if arr then
            str = arr[getElementData(localPlayer, 'Language') or 'en']
        end
        if (...) then
            str = str:format(...)
        end
    end
    if not str then
        str = ('translate error: #%s'):format(what)
    end

    return str
end
