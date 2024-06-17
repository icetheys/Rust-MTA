addEvent('requestAttachmentData', true)
addEventHandler('requestAttachmentData', root, function()
    triggerClientEvent(client, 'receiveAttachmentData', client, attachments)
end)

check = function()
    Async:setPriority('low')
    Async:foreach(attachments, 'pairs', function(v, id)
        if  (not isElement(v['ob']))  or (not isElement(v['ped'])) then
            table.remove(attachments, id)
        end
    end, function()
        setTimer(check, 20000, 1)
    end)
end
setTimer(check, 20000, 1)
