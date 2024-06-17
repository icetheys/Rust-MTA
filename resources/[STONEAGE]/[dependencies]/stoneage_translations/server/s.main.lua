function translate(p, what, subtable, ...)
    if not what then
        error('noting to translate.', 2)
    end

    local str
    local arr = translateArray[what]
    if arr then
        if subtable then
            arr = arr[subtable]
        end
        if arr then
            str = arr[getElementData(p, 'Language') or 'pt']
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

function sendTranslatedMessage(p, msg, r, g, b)
    msg = translate(p, msg)
    outputChatBox(msg, p, r or 255, g or 255, b or 255, true)
    return true
end
