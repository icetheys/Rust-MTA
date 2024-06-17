addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if (getElementType(source) == 'object') then
        setObjectBreakable(source, false)
    end
end)
