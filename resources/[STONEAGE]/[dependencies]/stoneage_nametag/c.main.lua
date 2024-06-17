addEventHandler('onClientResourceStart', resourceRoot, function()
    addEventHandler('onClientRender', root, Render)
end)

Talking = {}
addEventHandler('onClientPlayerVoiceStart', root, function()
    -- Talking[source] = true
end)

addEventHandler('onClientPlayerVoiceStop', root, function()
    -- Talking[source] = nil
end)

addEventHandler('onClientElementStreamOut', root, function()
    -- Talking[source] = nil
end)