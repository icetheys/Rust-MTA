CreateNotification = function(elem, ...)
    if isElement(elem) then
        triggerClientEvent(elem, 'CreateNotification', elem, ...)
    end
end
