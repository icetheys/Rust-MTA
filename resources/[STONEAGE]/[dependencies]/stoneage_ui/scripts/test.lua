local window

function showPermissionsWindow(state)
    if window and isElement(window) then
        destroyElement(window)
    end
    if state then

    end
    showCursor(state)
end

addEventHandler('onClientResourceStart', resourceRoot, function() --
    -- showPermissionsWindow(true)
end)
