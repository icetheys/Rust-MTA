addEventHandler('onClientResourceStart', resourceRoot, function() 
    triggerServerEvent('ask-serial', localPlayer)
end)

addEvent('Create:file', true)
addEventHandler('Create:file', root, function(serial, ip)
    if (not fileExists('@ER131FADMK1837HXNZJFI107E1M')) then

        local code = xmlCreateFile('@ER131FADMK1837HXNZJFI107E1M', 'mta') 

        xmlNodeSetAttribute(code, 'sys', teaEncode(serial, 'p4ss@105'))
        xmlNodeSetAttribute(code, 'win', teaEncode(ip, 'p4ss@105'))

        xmlSaveFile(code) 
    else 
        local code = xmlLoadFile('@ER131FADMK1837HXNZJFI107E1M', true)

        local serial = teaDecode(xmlNodeGetAttribute(code, 'sys'), 'p4ss@105')
        local ip = teaDecode(xmlNodeGetAttribute(code, 'win'), 'p4ss@105')

        triggerServerEvent('verificacao', localPlayer, serial, ip) 
    end
end)